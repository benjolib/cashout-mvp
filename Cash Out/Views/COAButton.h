//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class COATriangleView;

@interface COAButton : UIButton

@property (nonatomic, strong, readonly) COATriangleView *triangleView;
@property (nonatomic, strong, readonly) COATriangleView *outterTriangleView;

- (instancetype)initWithBorderColor:(UIColor *)borderColor triangleColor:(UIColor *)triangleColor outterTriangleColor:(UIColor *)outterTriangleColor;

@end