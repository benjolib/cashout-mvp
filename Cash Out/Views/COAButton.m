//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAButton.h"
#import "COATriangleView.h"
#import "COAConstants.h"

@interface COAButton()

@property (nonatomic, strong, readwrite) COATriangleView *triangleView;
@property (nonatomic, strong, readwrite) COATriangleView *outterTriangleView;
@property (nonatomic, strong) UIColor *outterTriangleColor;

@end

@implementation COAButton

- (instancetype)initWithBorderColor:(UIColor *)borderColor triangleColor:(UIColor *)triangleColor outterTriangleColor:(UIColor *)outterTriangleColor {
    self = [super init];
    if (self) {
        self.outterTriangleColor = outterTriangleColor;

        self.titleLabel.font = [COAConstants pageHeadlineTutorialBtnText];

        _triangleView = [[COATriangleView alloc] initWithFillColor:triangleColor ? triangleColor : [UIColor clearColor] pointToTop:NO];
        self.triangleView.translatesAutoresizingMaskIntoConstraints = NO;

        _outterTriangleView = [[COATriangleView alloc] initWithFillColor:outterTriangleColor ? outterTriangleColor : [UIColor clearColor] pointToTop:YES];
        self.outterTriangleView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:self.triangleView];

        if (self.outterTriangleColor) {
            [self addSubview:self.outterTriangleView];
        }

        if (borderColor) {
            self.layer.borderColor = borderColor.CGColor;
            self.layer.borderWidth = 1.f;
            self.layer.cornerRadius = 0;
        }

        [self setNeedsUpdateConstraints];
    }

    return self;
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (self.outterTriangleColor) {
        if (enabled) {
            [self.outterTriangleView setTriangleColor:[COAConstants greenColor]];
        } else {
            [self.outterTriangleView setTriangleColor:self.outterTriangleColor];
        }
    }
}

- (void)updateConstraints {
    [super updateConstraints];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.triangleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[triangleView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"triangleView":self.triangleView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[triangleView(10)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"triangleView":self.triangleView}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.triangleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    if (self.outterTriangleColor) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.outterTriangleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.outterTriangleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.triangleView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.outterTriangleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.triangleView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.outterTriangleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.triangleView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
}

@end