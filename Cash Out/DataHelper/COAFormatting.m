//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAFormatting.h"


@implementation COAFormatting

+ (NSString *)currencyStringFromValue:(double)value {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.currencyCode = @"USD";
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    return [currencyFormatter stringFromNumber:@(value)];
}

@end