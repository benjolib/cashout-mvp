//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "COAAbstractViewController.h"

@interface COATradeModeViewController : COAAbstractViewController

- (instancetype)initWithCurrencySymbol:(NSString *)currencySymbol moneySet:(double)moneySet betOnRise:(BOOL)rise;

@end