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

        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)removeSelf:(id)sender {

    [self removeFromSuperview];

    self.completionBlock(NO);
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{
            @"backgroundView" : self.backgroundView,
            @"topLabel" : self.topLabel,
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[topLabel]-40-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLabel(170)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"buttonHeight":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self addConstraints:self.customConstraints];
}

@end
