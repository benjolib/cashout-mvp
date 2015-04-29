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

- (void)fetchLiveDataForSymbol:(NSString *)symbol fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate completionBlock:(void (^)(NSString *value))completionBlock {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600];

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
        if ([query isKindOfClass:[NSArray class]]) {
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            [defaultRealm beginWriteTransaction];
            for (id row in query) {
                if ([row isKindOfClass:[NSDictionary class]]) {
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

- (void)initialImport {
    // fetch data
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    operationManager.responseSerializer = serializer;

    NSDateFormatter *dateFormatterDownload = [[NSDateFormatter alloc] init];
    dateFormatterDownload.dateFormat = @"M/d/y";
    NSString *toDateString = [dateFormatterDownload stringFromDate:[NSDate date]];

    NSString *downloadString = [NSString stringWithFormat:@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2015&stop_date=%@&Submit=Get%%20Daily%%20Stats", toDateString];
    [operationManager GET:downloadString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *lines = [[operation responseString] componentsSeparatedByString:@"\r\n"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"y-M-d";

        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.decimalSeparator = @".";

        RLMRealm *defaultRealm = [RLMRealm defaultRealm];
        [defaultRealm beginWriteTransaction];

        for (NSString *line in lines) {
            if ([line rangeOfString:@"201"].location != 0) {
                continue;
            }
            NSArray *components = [line componentsSeparatedByString:@","];
            
            // 2013-01-01,1.3219,86.7,0.9156,1.623,0.9934,0.8121,114.47,1.2078,1.0403,140.76,94.7,1.4852,0.8278

            if (components.count != 14) {
                continue;
            }

            NSDate *date = [[dateFormatter dateFromString:components[0]] mt_startOfCurrentMinute];

            [defaultRealm deleteObjects:[COASymbolValue objectsInRealm:defaultRealm withPredicate:[NSPredicate predicateWithFormat:@"timestamp = %@", date]]];

            for (int i = 1; i < 14; i++) {
                COASymbolValue *symbolValue = [[COASymbolValue alloc] init];
                symbolValue.timestamp = date;
                NSNumber *value = [f numberFromString:components[i]];
                symbolValue.value = value.doubleValue;

                switch (i) {
                    case 1:
                        symbolValue.symbol = @"EURUSD";
                        break;
                    case 2:
                        symbolValue.symbol = @"USDJPY";
                        break;
                    case 3:
                        symbolValue.symbol = @"USDCHF";
                        break;
                    case 4:
                        symbolValue.symbol = @"GBPUSD";
                        break;
                    case 5:
                        symbolValue.symbol = @"USDCAD";
                        break;
                    case 6:
                        symbolValue.symbol = @"EURGBP";
                        break;
                    case 7:
                        symbolValue.symbol = @"EURJPY";
                        break;
                    case 8:
                        symbolValue.symbol = @"EURCHF";
                        break;
                    case 9:
                        symbolValue.symbol = @"AUDUSD";
                        break;
                    case 10:
                        symbolValue.symbol = @"GBPJPY";
                        break;
                    case 11:
                        symbolValue.symbol = @"CHFJPY";
                        break;
                    case 12:
                        symbolValue.symbol = @"GBPCHF";
                        break;
                    case 13:
                        symbolValue.symbol = @"NZDUSD";
                        break;
                    default:
                        break;
                }

                [defaultRealm addObject:symbolValue];
            }
        }
        [defaultRealm commitWriteTransaction];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end