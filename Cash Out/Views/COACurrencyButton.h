//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COACurrencyButton : UIButton

@property (nonatomic) BOOL active;
@property (nonatomic, strong, readonly) NSString *currencySymbol;

- (instancetype)initWithCurrencySymbol:(NSString *)currencyString;

@end