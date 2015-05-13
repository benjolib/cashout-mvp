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
extern NSString *HISTORY_DATA_LOADED;
extern NSString *ONBOARDING_SEEN;
extern NSString *MARKET_NOTIFICATION;
extern NSString *TRADE_END_NOTIFICATION;
extern NSString *RECEIVED_GAME_OVER_NOTIFICATION;
extern NSString *SOME_SYMBOL_VALUE_FETCHED;

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
