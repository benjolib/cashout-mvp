//
// Created by Stefan Walkner on 14.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAProgressView.h"

@interface COAProgressView()

@property (nonatomic, strong) UIView *circle1;
@property (nonatomic, strong) UIView *circle2;
@property (nonatomic, strong) UIView *circle3;
@property (nonatomic, strong) UIView *circle4;

@end

@implementation COAProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _circle1 = [[UIView alloc] initWithFrame:CGRectZero];
        self.circle1.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.circle1];

        _circle2 = [[UIView alloc] initWithFrame:CGRectZero];
        self.circle2.backgroundColor = self.circle1.backgroundColor;
        [self addSubview:self.circle2];

        _circle3 = [[UIView alloc] initWithFrame:CGRectZero];
        self.circle3.backgroundColor = self.circle1.backgroundColor;
        [self addSubview:self.circle3];

        _circle4 = [[UIView alloc] initWithFrame:CGRectZero];
        self.circle4.backgroundColor = self.circle1.backgroundColor;
        [self addSubview:self.circle4];
    }

    return self;
}

@end
