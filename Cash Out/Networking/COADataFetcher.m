//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Realm/realm/RLMResults.h>
#import <LUKeychainAccess/LUKeychainAccess.h>
#import "COADataFetcher.h"
#import "AFHTTPRequestOperationManager.h"
#import "RLMRealm.h"
#import "COASymbolValue.h"
#import "NSDate+MTDates.h"
#import "COADataHelper.h"
#import "COACountryDeterminator.h"
#import "COAConstants.h"


@implementation COADataFetcher

+ (COADataFetcher *)instance {
    static COADataFetcher *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)fetchDataForSymbol:(NSString *)symbol completionBlock:(void (^)(NSString *value))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/rates?symbol=%@", symbol];

    if (urlString.length == 0) {
        return;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id query = responseObject[@"data"];
        if ([query isKindOfClass:[NSArray class]]) {
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            [defaultRealm beginWriteTransaction];
            for (id row in query) {
                if ([row isKindOfClass:[NSDictionary class]]) {
                    id ask = row[@"ask"];
                    id bid = row[@"bid"];
                    id time = row[@"time"];
                    COASymbolValue *symbolValue = [[COASymbolValue alloc] init];
                    symbolValue.timestamp = [dateFormatter dateFromString:time];
                    symbolValue.symbol = symbol;
                    symbolValue.value = ([ask doubleValue] + [bid doubleValue]) / 2;
                    [defaultRealm addObject:symbolValue];
                }
            }
            [defaultRealm commitWriteTransaction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:symbol object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:SOME_SYMBOL_VALUE_FETCHED object:nil userInfo:nil];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void)fetchHistoricalDataForSymbol:(NSString *)symbol fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate completionBlock:(void (^)(NSString *value))completionBlock {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString *fromDateString = [dateFormatter stringFromDate:fromDate];
    NSString *toDateString = [dateFormatter stringFromDate:toDate];
    NSString *scaleString;

    if ([toDate mt_daysSinceDate:fromDate] > 100) {
        scaleString = @"1d";
    } else if ([toDate mt_hoursSinceDate:fromDate] > 10) {
        scaleString = @"1h";
    } else {
        scaleString = @"1m";
    }

    NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/rates?symbol=%@&fromDate=%@&toDate=%@&scale=%@", symbol, encodeToPercentEscapeString(fromDateString), encodeToPercentEscapeString(toDateString), scaleString];

    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id query = responseObject[@"data"];
        BOOL success = NO;
        if ([query isKindOfClass:[NSArray class]]) {
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            [defaultRealm beginWriteTransaction];
            for (id row in query) {
                if ([row isKindOfClass:[NSDictionary class]]) {
                    success = YES;
                    id ask = row[@"ask"];
                    id bid = row[@"bid"];
                    id time = row[@"time"];
                    COASymbolValue *symbolValue = [[COASymbolValue alloc] init];
                    NSDate *date = [dateFormatter dateFromString:time];

                    if ([scaleString isEqualToString:@"1d"]) {
                        date = [date mt_startOfCurrentDay];
                    } else if ([scaleString isEqualToString:@"1h"]) {
                        date = [date mt_startOfCurrentHour];
                    } else {
                        date = [date mt_startOfCurrentMinute];
                    }

                    symbolValue.timestamp = date;
                    symbolValue.symbol = symbol;
                    symbolValue.value = ([ask doubleValue] + [bid doubleValue]) / 2;
                    [defaultRealm addObject:symbolValue];
                }
            }

            if (success) {
                if ([scaleString isEqualToString:@"1d"]) {
                    [[COADataHelper instance] saveDayScaleForSymbol:symbol date:toDate];
                } else if ([scaleString isEqualToString:@"1h"]) {
                    [[COADataHelper instance] saveHourScaleForSymbol:symbol date:toDate];
                } else {
                    [[COADataHelper instance] saveMinuteScaleForSymbol:symbol date:toDate];
                }
            }
            [defaultRealm commitWriteTransaction];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:symbol object:nil userInfo:nil];
        });
        completionBlock(@"");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error.localizedDescription);
    }];
}

- (void)createUser {
    NSString *key = [COADataFetcher identifierForVendor];
    double balance = [[COADataHelper instance] money];
    NSString *country = [[COACountryDeterminator instance] country];

    if (country.length > 0) {
        NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/users/create?email=%@&balance=%f&country=%@", key, balance, country];
        AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
        [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id query = responseObject[@"data"];
            if ([query isKindOfClass:[NSDictionary class]]) {
                [COADataFetcher setUserId:query[@"id"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}

- (void)updateBalance {
    NSInteger userId = [COADataFetcher userId];
    double balance = [[COADataHelper instance] money];

    NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/users/balance?id=%li&balance=%f", (long)userId, balance];
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)fetchPositionWithCompletionBlock:(void (^)(NSInteger position))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/users/list?orderProperty=balance&orderDir=DESC&start=0&limit=1&email=%@", [COADataFetcher identifierForVendor]];
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id query = responseObject[@"data"];
        if ([query isKindOfClass:[NSArray class]]) {
            if (((NSArray *) query).count > 0) {
                id dataEntry = query[0];
                if ([dataEntry isKindOfClass:[NSDictionary class]]) {
                    [COADataFetcher setPosition:[dataEntry[@"position"] integerValue]];
                    [COADataFetcher setGlobalPosition:[dataEntry[@"overallPosition"] integerValue]];
                    [COADataFetcher setUserId:[dataEntry[@"id"] integerValue]];
                    completionBlock(0);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

+ (NSInteger)userId {
    return [[LUKeychainAccess standardKeychainAccess] integerForKey:@"userid"];
}

+ (void)setUserId:(NSInteger)userId {
    [[LUKeychainAccess standardKeychainAccess] setInteger:userId forKey:@"userid"];
}

+ (NSInteger)globalPosition {
    return [[LUKeychainAccess standardKeychainAccess] integerForKey:@"globalposition"];
}

+ (void)setGlobalPosition:(NSInteger)globalPosition {
    [[LUKeychainAccess standardKeychainAccess] setInteger:globalPosition forKey:@"globalposition"];
}

+ (NSInteger)position {
    return [[LUKeychainAccess standardKeychainAccess] integerForKey:@"position"];
}

+ (void)setPosition:(NSInteger)position {
    [[LUKeychainAccess standardKeychainAccess] setInteger:position forKey:@"position"];
}

+ (NSString *)identifierForVendor {

    NSString *encryptionKeyFromKeychain = [[LUKeychainAccess standardKeychainAccess] stringForKey:@"identifierForVendorUUID"];

    if (encryptionKeyFromKeychain.length == 0) {
        encryptionKeyFromKeychain = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        [[LUKeychainAccess standardKeychainAccess] setString:encryptionKeyFromKeychain forKey:@"identifierForVendorUUID"];
    }

    return encryptionKeyFromKeychain;
}

NSString *encodeToPercentEscapeString(NSString *string) {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

@end