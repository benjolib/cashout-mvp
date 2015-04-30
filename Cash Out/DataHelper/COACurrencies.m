//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACurrencies.h"


@implementation COACurrencies

+ (NSArray *)currencyDisplayStrings {
    return @[
            @"$ AUD / $ USD",
            @"FR CHF / ¥ JPY",
            @"€ EUR / ¥ JPY",
            @"€ EUR / $ USD",
            @"$ NZD / $ USD",
            @"$ USD / $ CAD",
            @"$ USD / FR CHF",
            @"Gold"
    ];
}

+ (NSArray *)currencies {
    return @[
            @"AUDUSD",
            @"CHFJPY",
            @"EURJPY",
            @"EURUSD",
            @"NZDUSD",
            @"USDCAD",
            @"USDCHF",
            @"Gld"
    ];
}

@end
