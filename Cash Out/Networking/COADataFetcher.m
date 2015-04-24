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
    NSString *urlString = self.currencyDictionary[symbol];

    if (urlString.length == 0) {
        return;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";

    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id query = responseObject[@"query"];
        if ([query isKindOfClass:[NSDictionary class]]) {
            id results = query[@"results"];
            
            if ([results isKindOfClass:[NSDictionary class]]) {
                id row = results[@"row"];
                
                if ([row isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        id col1 = row[@"col1"];
                        RLMRealm *defaultRealm = [RLMRealm defaultRealm];
                        [defaultRealm beginWriteTransaction];
                        COASymbolValue *symbolValue = [[COASymbolValue alloc] init];
                        symbolValue.timestamp = [NSDate date];
                        symbolValue.symbol = symbol;
                        symbolValue.value = [col1 doubleValue];
                        [defaultRealm addObject:symbolValue];
                        [defaultRealm commitWriteTransaction];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:symbol object:nil userInfo:nil];
                        });
                    });


                    // completionBlock(col1);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void)initialImport {
    if ([COASymbolValue allObjects].count > 100) {
        // return;
    }
    // fetch data
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    operationManager.responseSerializer = serializer;
    [operationManager GET:@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/21/2015&Submit=Get%20Daily%20Stats" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *lines = [[operation responseString] componentsSeparatedByString:@"\r\n"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"%y-%M-%d";

        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.decimalSeparator = @".";

        RLMRealm *defaultRealm = [RLMRealm defaultRealm];
        [defaultRealm beginWriteTransaction];
        [defaultRealm deleteObjects:[COASymbolValue allObjects]];

        for (NSString *line in lines) {
            if ([line rangeOfString:@"201"].location != 0) {
                continue;
            }
            NSArray *components = [line componentsSeparatedByString:@","];
            
            // 2013-01-01,1.3219,86.7,0.9156,1.623,0.9934,0.8121,114.47,1.2078,1.0403,140.76,94.7,1.4852,0.8278

            if (components.count != 14) {
                continue;
            }

            NSDate *date = [[dateFormatter dateFromString:components[0]] mt_startOfCurrentDay];

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

- (NSDictionary *)currencyDictionary {
    return @{
            @"USDCAD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DUSDCAD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"GBPUSD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DGBPUSD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"GBPJPY":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DGBPJPY%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"USDCHF":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DUSDCHF%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"NZDUSD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DNZDUSD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURJPY":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURJPY%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURGBP":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURGBP%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURUSD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURUSD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURGBP":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURGBP%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"GOLD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3D274702%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"BITCOINS":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DBTCUSD%3DX%22%3B&format=json&diagnostics=true&callback="
    };
}

- (NSDictionary *)currencyHistoryDictionary {
    return @{
            @"USDCAD":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"GBPUSD":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"GBPJPY":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"USDCHF":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"NZDUSD":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"EURJPY":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"EURGBP":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"EURUSD":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"EURGBP":@"http://www.global-view.com/forex-trading-tools/forex-history/exchange_csv_report.html?CLOSE_1=ON&CLOSE_2=ON&CLOSE_3=ON&CLOSE_4=ON&CLOSE_5=ON&CLOSE_6=ON&CLOSE_7=ON&CLOSE_8=ON&CLOSE_9=ON&CLOSE_10=ON&CLOSE_11=ON&CLOSE_12=ON&CLOSE_13=ON&start_date=4/14/2010&stop_date=4/14/2015&Submit=Get%20Daily%20Stats",
            @"GOLD":@"http://ichart.finance.yahoo.com/table.csv?s=GOLD&a=0&b=1&c=2000&d=3&e=19&f=2015&g=d&ignore=.csv",
            @"BITCOINS":@"http://ichart.finance.yahoo.com/table.csv?s=BITCOINS&a=0&b=1&c=2000&d=3&e=19&f=2015&g=d&ignore=.csv"
    };
}

@end