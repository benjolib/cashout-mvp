//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COACongratsView : UIView

@property (nonatomic, copy) void (^completionBlock)(BOOL onlyClose);

- (instancetype)initWithCompletionBlock:(void (^) (BOOL onlyClose))completionBlock winLoss:(double)winLoss;

@end