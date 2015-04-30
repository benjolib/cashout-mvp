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

+ (NSString *)displayStringForSymbol:(NSString *)symbol {
    NSInteger index = [[COACurrencies currencies] indexOfObject:symbol];
    return [COACurrencies currencyDisplayStrings][index];
}

+ (NSString *)symbolForDisplayString:(NSString *)dislayString {
    NSInteger index = [[COACurrencies currencyDisplayStrings] indexOfObject:dislayString];
    return [COACurrencies currencies][index];
}

@end
