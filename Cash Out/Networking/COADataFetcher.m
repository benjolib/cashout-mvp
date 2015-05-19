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
#import "NSDate+COAAdditions.h"


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
                    
                    if (ask != [NSNull null] && bid != [NSNull null] && time != [NSNull null]) {
                        COASymbolValue *symbolValue = [[COASymbolValue alloc] init];
                        symbolValue.timestamp = [dateFormatter dateFromString:time];
                        symbolValue.symbol = symbol;
                        symbolValue.value = ([ask doubleValue] + [bid doubleValue]) / 2;
                        [defaultRealm addObject:symbolValue];
                    }
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

- (void)fetchHistoricalDataForSymbol:(NSString *)symbol forDates:(NSArray *)dates completionBlock:(void (^)(void))completionBlock {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/rates?symbol=%@", symbol];
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (NSArray *subArray in dates) {
        for (NSDate *date in subArray) {
            NSString *dateString = [dateFormatter stringFromDate:date];
            BOOL valueAlreadyFetched = [COASymbolValue objectsWithPredicate:[NSPredicate predicateWithFormat:@"symbol = %@ and timestamp = %@", symbol, date]].count > 0;
            BOOL dataFetched = ![symbol.lowercaseString isEqualToString:@"gld"] || [date mt_isOnOrAfter:[NSDate mt_dateFromYear:2015 month:4 day:30]];
            if (![parameters containsObject:dateString] && !valueAlreadyFetched && dataFetched) {
                [parameters addObject:dateString];
            }
        }
    }
    
    if (parameters.count == 0) {
        completionBlock();
        return;
    }
    
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager POST:urlString parameters:@{@"dates":parameters} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id query = responseObject[@"data"];
        
        if ([query isKindOfClass:[NSDictionary class]]) {
            NSDictionary *queryDict = (NSDictionary *) query;
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            [defaultRealm beginWriteTransaction];
            for (NSString *key in queryDict.allKeys) {
                NSDictionary *value = queryDict[key];
                
                id ask = value[@"ask"];
                if (ask != [NSNull null]) {
                    COASymbolValue *symbolValue = [[COASymbolValue alloc] init];
                    symbolValue.timestamp = [dateFormatter dateFromString:key];
                    symbolValue.symbol = symbol;
                    symbolValue.value = [value[@"ask"] doubleValue];
                    
                    [defaultRealm addObject:symbolValue];
                }
            }
            [defaultRealm commitWriteTransaction];
        }

        completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock();
    }];
}

- (void)createUserWithCompletionBlock:(void (^)())completionBlock {
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
                [self fetchPositionWithCompletionBlock:^(NSInteger position) {
                    completionBlock();
                }];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}

- (void)sendMailToServer:(NSString *)email completionBlock:(void (^)())completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"http://api-cashout.makers.do/users/update?id=%i&email=%@", [COADataFetcher userId], email];
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id success = responseObject[@"success"];

            if ([success boolValue]) {
                [[COADataHelper instance] saveMoney:100000];
                [[COADataFetcher instance] updateBalance];
                completionBlock();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
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

- (void)fetchPositionWithCompletionBlock:(void (^)())completionBlock {
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
                    completionBlock();
                    [[NSNotificationCenter defaultCenter] postNotificationName:POSITION_FETCHED object:nil];
                }
            } else {
                [self createUserWithCompletionBlock:^{
                    completionBlock();
                }];
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

+ (NSArray *)datesToFetch {
    NSDate *toDate = [NSDate date];

    NSMutableArray *outterArray = [[NSMutableArray alloc] init];

    NSInteger numberOfValues = 25;
    
    // 30 minutes
    NSMutableArray *minutesArray = [[NSMutableArray alloc] init];
    NSDate *fromDate = [[[NSDate date] mt_startOfCurrentHour] mt_dateMinutesBefore:30];
    NSInteger secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    NSInteger secondsBetweenDates = secondsBetween / numberOfValues;
    
    for (int i = 1; i <= numberOfValues; i++) {
        [minutesArray addObject:[fromDate mt_dateSecondsAfter:secondsBetweenDates * i].coa_modifiedDate];
    }
    [outterArray addObject:minutesArray];
    
    // 1 day
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    fromDate = [[[NSDate date] mt_startOfCurrentHour] mt_dateDaysBefore:1];
    secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    secondsBetweenDates = secondsBetween / numberOfValues;
    
    for (int i = 1; i <= numberOfValues; i++) {
        [dayArray addObject:[fromDate mt_dateSecondsAfter:secondsBetweenDates * i].coa_modifiedDate];
    }
    [outterArray addObject:dayArray];
    
    // 5 days
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    fromDate = [[[NSDate date] mt_startOfCurrentHour] mt_dateDaysBefore:5];
    secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    secondsBetweenDates = secondsBetween / numberOfValues;
    for (int i = 1; i <= numberOfValues; i++) {
        [daysArray addObject:[fromDate mt_dateSecondsAfter:secondsBetweenDates * i].coa_modifiedDate];
    }
    [outterArray addObject:daysArray];

    // 3 months
    NSMutableArray *months3Array = [[NSMutableArray alloc] init];
    fromDate = [[[NSDate date] mt_startOfCurrentDay] mt_dateMonthsBefore:3];
    secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    secondsBetweenDates = secondsBetween / numberOfValues;
    for (int i = 1; i <= numberOfValues; i++) {
        [months3Array addObject:[fromDate mt_dateSecondsAfter:secondsBetweenDates * i].coa_modifiedDate];
    }
    [outterArray addObject:months3Array];

    // 6 months
    NSMutableArray *month6Array = [[NSMutableArray alloc] init];
    fromDate = [[[NSDate date] mt_startOfCurrentDay] mt_dateMonthsBefore:6];
    secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    secondsBetweenDates = secondsBetween / numberOfValues;
    for (int i = 1; i <= numberOfValues; i++) {
        [month6Array addObject:[fromDate mt_dateSecondsAfter:secondsBetweenDates * i].coa_modifiedDate];
    }
    [outterArray addObject:month6Array];

    // 1 year
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    fromDate = [[[NSDate date] mt_startOfCurrentDay] mt_dateYearsBefore:1];
    secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    secondsBetweenDates = secondsBetween / numberOfValues;
    for (int i = 1; i <= numberOfValues; i++) {
        [yearArray addObject:[fromDate mt_dateSecondsAfter:secondsBetweenDates * i].coa_modifiedDate];
    }
    [outterArray addObject:yearArray];

    return outterArray;
}

@end