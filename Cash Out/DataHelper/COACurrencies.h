//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COACurrencies : NSObject

+ (NSArray *)currencyDisplayStrings;

+ (NSArray *)currencies;

+ (NSString *)displayStringForSymbol:(NSString *)symbol;

+ (NSString *)symbolForDisplayString:(NSString *)dislayString;

@end