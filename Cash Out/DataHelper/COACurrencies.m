//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACurrencies.h"
#import "COASymbolValue.h"


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

+ (double)usdCounterPart:(NSString *)currencySymbol {
    if ([currencySymbol rangeOfString:@" / "].location == NSNotFound) {
        return 0;
    }

    NSInteger index = [[COACurrencies currencyDisplayStrings] indexOfObject:currencySymbol];
    currencySymbol = [COACurrencies currencies][index];
    
    if (currencySymbol.length != 6) {
        return 0;
    }
    
    NSString *firstCurrency = [currencySymbol substringToIndex:3];

    for (NSString *currentCurrencySymbol in [COACurrencies currencies]) {
        if ([currentCurrencySymbol rangeOfString:@"USD"].location != NSNotFound
                && [currentCurrencySymbol rangeOfString:firstCurrency].location != NSNotFound) {
            if ([currentCurrencySymbol rangeOfString:@"USD"].location == 0) {
                return 1 / [COASymbolValue latestValueForSymbol:currentCurrencySymbol];
            } else {
                return [COASymbolValue latestValueForSymbol:currentCurrencySymbol];
            }
        }
    }

    return 0;
}

+ (NSString *)displayStringForSymbol:(NSString *)symbol {
    NSInteger index = [[COACurrencies currencies] indexOfObject:symbol];
    return [COACurrencies currencyDisplayStrings][index];
}

@end
