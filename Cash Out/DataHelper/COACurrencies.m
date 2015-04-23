//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACurrencies.h"


@implementation COACurrencies

+ (NSArray *)currencyDisplayStrings {
    return @[
            @"$ USD / $ CAD",
            @"£ GBP / $ USD",
            @"£ GBP / ¥ JPY",
            @"$ USD / FR CHF",
            @"$ NZD / $ USD",
            @"€ EUR / ¥ JPY",
            @"€ EUR / £ GBP",
            @"€ EUR / $ USD",
            @"€ EUR / £ GBP",
            @"GOLD",
            @"BITCOINS"
    ];
}

+ (NSArray *)currencies {
    return @[
            @"USDCAD",
            @"GBPUSD",
            @"GBPJPY",
            @"USDCHF",
            @"NZDUSD",
            @"EURJPY",
            @"EURGBP",
            @"EURUSD",
            @"EURGBP",
            @"GOLD",
            @"BITCOINS"
    ];
}

@end