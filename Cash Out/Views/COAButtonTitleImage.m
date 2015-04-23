//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAButtonTitleImage.h"

@interface COAButtonTitleImage()

@property (nonatomic, strong) UIImageView *coaImageView;
@property (nonatomic, strong) UILabel *coaTitleLabel;

@end

@implementation COAButtonTitleImage

- (instancetype)initWithImage:(UIImage *)coaImage title:(NSString *)coaTitle {
    self = [super init];
    if (self) {
        _coaTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.coaTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.coaTitleLabel setFont:[UIFont systemFontOfSize:10]];
        self.coaTitleLabel.textColor = [UIColor whiteColor];
        self.coaTitleLabel.text = coaTitle;

        _coaImageView = [[UIImageView alloc] initWithImage:coaImage];
        [self.coaImageView setContentMode:UIViewContentModeCenter];
        [self addSubview:self.coaImageView];
        [self addSubview:self.coaTitleLabel];

        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{
            @"label" : self.coaTitleLabel,
            @"imageView" : self.coaImageView
    };

    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.coaImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.coaTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:5]];
}

@end
