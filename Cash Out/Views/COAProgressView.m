//
// Created by Stefan Walkner on 14.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAProgressView.h"

@interface COAProgressView()

@end

@implementation COAProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

//// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(14, 1, 12, 12)];
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];


//// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(34, 1, 12, 12)];
    
    if (self.currentStep >= 1) {
        [[UIColor whiteColor] setFill];
    } else {
        [[UIColor clearColor] setFill];
    }
    [oval2Path fill];
    [[UIColor whiteColor] setStroke];
    oval2Path.lineWidth = 1;
    [oval2Path stroke];


//// Oval 3 Drawing
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(54, 1, 12, 12)];
    if (self.currentStep >= 2) {
        [[UIColor whiteColor] setFill];
    } else {
        [[UIColor clearColor] setFill];
    }
    [oval3Path fill];
    [[UIColor whiteColor] setStroke];
    oval3Path.lineWidth = 1;
    [oval3Path stroke];


//// Oval 4 Drawing
    UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(74, 1, 12, 12)];
    if (self.currentStep >= 3) {
        [[UIColor whiteColor] setFill];
    } else {
        [[UIColor clearColor] setFill];
    }
    [oval4Path fill];
    [[UIColor whiteColor] setStroke];
    oval4Path.lineWidth = 1;
    [oval4Path stroke];
}

@end
