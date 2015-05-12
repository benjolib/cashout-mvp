//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Realm/realm/RLMResults.h>
#import "COADataFetcher.h"
#import "AFHTTPRequestOperationManager.h"
#import "RLMRealm.h"
#import "COASymbolValue.h"
#import "NSDate+MTDates.h"
#import "COADataHelper.h"


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

NSString *encodeToPercentEscapeString(NSString *string) {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

@end