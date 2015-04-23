//
//  COAConstants.h
//  Cash Out
//
//  Created by Stefan Walkner on 13.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COAConstants : NSObject

extern const NSInteger BUTTON_HEIGHT;

extern NSString *MONEY_USER_SETTING;
extern NSString *TUTORIAL_SEEN;

+ (UIColor *)darkBlueColor;

+ (UIColor *)lightBlueColor;

+ (UIColor *)greenColor;

+ (UIColor *)grayColor;

+ (UIColor *)fleshColor;

+ (UIFont *)pageHeadlineTutorialBtnText;

+ (UIFont *)tradeBudgetCurrencyRate;

+ (UIFont *)tradeModeCurrencyProfitLoss;

+ (UIFont *)tradeTime;

+ (UIFont *)currencyOverviewChartDataCurrencyInBracketsChartView;

@end
