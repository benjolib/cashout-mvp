//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COADataFetcher.h"
#import "AFHTTPRequestOperationManager.h"


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

- (void)fetchDataForSymbol:(NSString *)symbol {
    NSString *urlString = self.currencyDictionary[symbol];

    if (urlString.length == 0) {
        return;
    }

    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] init];
    [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id query = responseObject[@"query"];
        if ([query isKindOfClass:[NSDictionary class]]) {
            id results = query[@"results"];
            
            if ([results isKindOfClass:[NSDictionary class]]) {
                id row = results[@"row"];
                
                if ([row isKindOfClass:[NSDictionary class]]) {
                    id col1 = row[@"col1"];
                    NSLog(@"%@", col1);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];


//    Operation.manager.GET(ApiEndPoints.BASE_URL_NEW.stringByAppendingPathComponent("contents/mobile/faqs"), parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
//        let realm = RLMRealm.defaultRealm()
//        realm.beginWriteTransaction()
//        realm.deleteObjects(ABOFAQModel.allObjects())
//        ABOFAQModel.createOrUpdateInRealm(realm, withJSONArray: responseObject as [NSDictionary])
//        realm.commitWriteTransaction()
//
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        AboalarmAppDelegate.hideLoadingOverlay()
//        success()
//        concurrentOperation.finished = true
//        })
//    }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//        concurrentOperation.finished = true
//    }
//
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
            @"DAX":@"",
            @"GOLD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3D274702%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"DOW":@"",
            @"CRUDE OIL":@"",
            @"NASDAQ":@"",
            @"SP500":@"",
            @"BITCOINS":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DBTCUSD%3DX%22%3B&format=json&diagnostics=true&callback="
    };
}

@end