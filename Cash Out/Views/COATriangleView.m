//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COATriangleView.h"

@interface COATriangleView ()

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic) BOOL pointingToTop;

@end

@implementation COATriangleView

- (instancetype)initWithFillColor:(UIColor *)fillColor pointToTop:(BOOL)top {
    self = [super init];
    if (self) {
        self.fillColor = fillColor;
        self.backgroundColor = [UIColor clearColor];
        self.pointingToTop = top;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    UIBezierPath* polygonPath = UIBezierPath.bezierPath;

    if (self.pointingToTop) {
        [polygonPath moveToPoint: CGPointMake(10, 0)];
        [polygonPath addLineToPoint: CGPointMake(20, 10)];
        [polygonPath addLineToPoint: CGPointMake(0, 10.0)];
    } else {
        [polygonPath moveToPoint: CGPointMake(0, 0)];
        [polygonPath addLineToPoint: CGPointMake(20, 0.0)];
        [polygonPath addLineToPoint: CGPointMake(10, 10)];
    }
    [polygonPath closePath];
    [self.fillColor setFill];
    [polygonPath fill];
}

- (void)setTriangleColor:(UIColor *)triangleColor {
    _fillColor = triangleColor;

    [self setNeedsDisplayInRect:self.frame];
}

@end
