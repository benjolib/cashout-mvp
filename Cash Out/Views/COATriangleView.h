//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COATriangleView : UIView

- (instancetype)initWithFillColor:(UIColor *)fillColor pointToTop:(BOOL)top;

- (void)setTriangleColor:(UIColor *)triangleColor;

@end
