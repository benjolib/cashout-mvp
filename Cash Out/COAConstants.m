//
//  COAConstants.m
//  Cash Out
//
//  Created by Stefan Walkner on 13.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAConstants.h"

@implementation COAConstants

const NSInteger BUTTON_HEIGHT = 80;

NSString *MONEY_USER_SETTING = @"MONEY_USER_SETTING";
NSString *TUTORIAL_SEEN = @"TUTORIAL_SEEN";
NSString *ONBOARDING_SEEN = @"ONBOARDING_SEEN";
NSString *HISTORY_DATA_LOADED = @"HISTORY_DATA_LOADED";
NSString *MARKET_NOTIFICATION = @"MARKET_NOTIFICATION";
NSString *SOME_SYMBOL_VALUE_FETCHED = @"SOME_SYMBOL_VALUE_FETCHED";
NSString *POSITION_FETCHED = @"POSITION_FETCHED";

+ (UIColor *)darkBlueColor {
    return [UIColor colorWithRed:0.278 green:0.596 blue:0.808 alpha:1]; /*#4798ce*/
}

+ (UIColor *)lightBlueColor {
    return [UIColor colorWithRed:0.416 green:0.753 blue:0.941 alpha:1]; /*#6ac0f0*/
}

+ (UIColor *)greenColor {
    return [UIColor colorWithRed:0.608 green:0.835 blue:0.259 alpha:1]; /*#9bd542*/
}

+ (UIColor *)fleshColor {
    return [UIColor colorWithRed:0.992 green:0.624 blue:0.502 alpha:1]; /*#fd9f80*/
}

+ (UIColor *)grayColor {
    return [UIColor colorWithRed:0.776 green:0.776 blue:0.776 alpha:1]; /*#c6c6c6*/
}

+ (UIFont *)pageHeadlineTutorialBtnText {
    return [UIFont fontWithName:@"Avenir-Light" size:22];
}

+ (UIFont *)tradeBudgetCurrencyRate {
    return [UIFont fontWithName:@"Avenir-Heavy" size:28];
}

+ (UIFont *)tradeModeCurrencyProfitLoss {
    return [UIFont fontWithName:@"Avenir-Heavy" size:35];
}

+ (UIFont *)tradeTime {
    return [UIFont fontWithName:@"Avenir-Book" size:35];
}

+ (UIFont *)currencyOverviewChartDataCurrencyInBracketsChartView {
    return [UIFont fontWithName:@"Avenir-Book" size:15];
}

@end
