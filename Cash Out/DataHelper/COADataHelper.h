//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface COADataHelper : NSObject

+ (COADataHelper *)instance;

- (void)saveMoney:(double)money;

- (double)money;

- (void)setTutorialSeen;

- (BOOL)tutorialSeen;

- (void)setOnboardingSeen;

- (BOOL)onboardingSeen;

- (NSDate *)toDateDayScaleForSymbol:(NSString *)symbol;

- (NSDate *)toDateHourScaleForSymbol:(NSString *)symbol;

- (NSDate *)toDateMinuteScaleForSymbol:(NSString *)symbol;

- (void)saveDayScaleForSymbol:(NSString *)symbol date:(NSDate *)toDate;

- (void)saveHourScaleForSymbol:(NSString *)symbol date:(NSDate *)toDate;

- (void)saveMinuteScaleForSymbol:(NSString *)symbol date:(NSDate *)toDate;

@end