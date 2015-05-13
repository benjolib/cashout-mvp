//
//  COAMarketClosedView.m
//  Cash Out
//
//  Created by Stefan Walkner on 12.05.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAMarketClosedView.h"
#import "COAConstants.h"
#import "NSString+COAAdditions.h"
#import "COAButton.h"
#import "COAMarketHelper.h"
#import "UIImage+ImageWithColor.h"

@interface COAMarketClosedView()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) void (^completionBlock)(BOOL onlyClose);
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) COAButton *centerButton;
@property (nonatomic, strong) COAButton *yesButton;
@property (nonatomic, strong) COAButton *noButton;

@end

@implementation COAMarketClosedView

- (instancetype)initWithCompletionBlock:(void (^) (BOOL onlyClose))completionBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.completionBlock = completionBlock;
        self.backgroundColor = [UIColor clearColor];

        self.translatesAutoresizingMaskIntoConstraints = NO;

        _customConstraints = [[NSMutableArray alloc] init];

        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [UIColor darkGrayColor];
        self.backgroundView.alpha = 0.6f;
        [self addSubview:self.backgroundView];

        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.numberOfLines = 4;
        self.topLabel.backgroundColor = [COAConstants darkBlueColor];
        self.topLabel.textColor = [UIColor whiteColor];
        NSString *topText = [NSString stringWithFormat:@"%@\n\n%@", NSLocalizedString(@"Sorry!", @""), NSLocalizedString(@"the stocket market is currently closed", @"")].uppercaseString;
        self.topLabel.attributedText = [topText coa_firstLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:30]
        } secondLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
        }];
        [self addSubview:self.topLabel];

        _centerButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:self.topLabel.backgroundColor outterTriangleColor:nil];
        self.centerButton.titleLabel.numberOfLines = 2;
        self.centerButton.enabled = NO;
        [self.centerButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.centerButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
        NSString *centerText = NSLocalizedString(@"get notified when the market opens again", @"").uppercaseString;
        NSAttributedString *attributedText = [centerText coa_firstLineAttributes:@{
                NSFontAttributeName:[UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName:[UIColor grayColor]
        } secondLineAttributes:@{
                NSFontAttributeName:[UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName:[UIColor grayColor]
        }];
        [self.centerButton setAttributedTitle:attributedText forState:UIControlStateNormal];
        [self.centerButton setAttributedTitle:attributedText forState:UIControlStateDisabled];
        [self addSubview:self.centerButton];

        _yesButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:nil outterTriangleColor:nil];
        [self.yesButton setTitle:NSLocalizedString(@"yes", @"").uppercaseString forState:UIControlStateNormal];
        self.yesButton.backgroundColor = [COAConstants greenColor];
        [self.yesButton addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.yesButton];

        _noButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:nil outterTriangleColor:nil];
        [self.noButton setTitle:NSLocalizedString(@"no", @"").uppercaseString forState:UIControlStateNormal];
        self.noButton.backgroundColor = [UIColor colorWithRed:0.42 green:0.584 blue:0.176 alpha:1];
        [self.noButton addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.noButton];

        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)removeSelf:(id)sender {

    if ([sender isEqual:self.yesButton]) {
        [COAMarketHelper scheduleLocalNotificationWhenMarketOpens];
    }

    [self removeFromSuperview];

    self.completionBlock(NO);
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{
            @"backgroundView" : self.backgroundView,
            @"topLabel" : self.topLabel,
            @"centerButton" : self.centerButton,
            @"yesButton" : self.yesButton,
            @"noButton" : self.noButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[topLabel]-40-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[centerButton]-40-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.centerButton attribute:NSLayoutAttributeHeight multiplier:1.2 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[yesButton][noButton]-40-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLabel(170)][centerButton][yesButton(buttonHeight)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"buttonHeight":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.yesButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.yesButton attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-30]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.noButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self addConstraints:self.customConstraints];
}

@end
