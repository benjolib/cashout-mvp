//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COATradeModeViewController.h"

@interface COATradeModeViewController()

@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) UILabel *firstCurrencyLabel;
@property (nonatomic, strong) UILabel *secondCurrencyLabel;
@property (nonatomic, strong) UILabel *priceKeyLabel;
@property (nonatomic, strong) UIImageView *priceImageView;
@property (nonatomic, strong) UILabel *priceValueLabel;
@property (nonatomic, strong) UILabel *winLossKeyLabel;
@property (nonatomic, strong) UIImageView *winLossImageView;
@property (nonatomic, strong) UILabel *winLossValueLabel;
@property (nonatomic, strong) UILabel *timeLeftKeyLabel;
@property (nonatomic, strong) UIImageView *timeLeftImageView;
@property (nonatomic, strong) UILabel *timeLeftValueLabel;
@property (nonatomic, strong) UIButton *cashOutButton;

@end

@implementation COATradeModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _customConstraints = [[NSMutableArray alloc] init];

    _firstCurrencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.firstCurrencyLabel.textAlignment = NSTextAlignmentCenter;
    self.firstCurrencyLabel.backgroundColor = [UIColor grayColor];
    self.firstCurrencyLabel.text = @"EUR";
    [self.view addSubview:self.firstCurrencyLabel];

    _secondCurrencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.secondCurrencyLabel.textAlignment = NSTextAlignmentCenter;
    self.secondCurrencyLabel.backgroundColor = [UIColor grayColor];
    self.secondCurrencyLabel.text = @"USD";
    self.secondCurrencyLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.secondCurrencyLabel];

    _priceKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceKeyLabel.text = [NSLocalizedString(@"Price (Live)", @"") uppercaseString];
    [self.view addSubview:self.priceKeyLabel];

    _priceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.priceImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.priceImageView];

    _priceValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceValueLabel.text = @"1.0870";
    self.priceValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.priceValueLabel];

    _winLossKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.winLossKeyLabel.text = [@"Loss (live)" uppercaseString];
    [self.view addSubview:self.winLossKeyLabel];

    _winLossImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.winLossImageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.winLossImageView];

    _winLossValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.winLossValueLabel.text = @"$ 200";
    self.winLossValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.winLossValueLabel];

    _timeLeftKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLeftKeyLabel.text = [NSLocalizedString(@"time left", @"") uppercaseString];
    [self.view addSubview:self.timeLeftKeyLabel];

    _timeLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.timeLeftImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.timeLeftImageView];

    _timeLeftValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLeftValueLabel.text = @"9:50";
    self.timeLeftValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.timeLeftValueLabel];

    _cashOutButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.cashOutButton setTitle:[NSLocalizedString(@"cash out", @"") uppercaseString] forState:UIControlStateNormal];
    self.cashOutButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.cashOutButton];

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"firstCurrencyLabel":self.firstCurrencyLabel,
            @"secondCurrencyLabel":self.secondCurrencyLabel,
            @"priceKeyLabel":self.priceKeyLabel,
            @"priceImageView":self.priceImageView,
            @"priceValueLabel":self.priceValueLabel,
            @"winLossKeyLabel":self.winLossKeyLabel,
            @"winLossImageView":self.winLossImageView,
            @"winLossValueLabel":self.winLossValueLabel,
            @"timeLeftKeyLabel":self.timeLeftKeyLabel,
            @"timeLeftImageView":self.timeLeftImageView,
            @"timeLeftValueLabel":self.timeLeftValueLabel,
            @"cashOutButton":self.cashOutButton
    };

    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstCurrencyLabel][secondCurrencyLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.secondCurrencyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.firstCurrencyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.secondCurrencyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.firstCurrencyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[priceKeyLabel][priceImageView][priceValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.priceKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.priceKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.priceKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[priceImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[winLossKeyLabel][winLossImageView][winLossValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.winLossValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.winLossKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.winLossImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.winLossKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.winLossValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.winLossKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[winLossImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[winLossImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[timeLeftKeyLabel][timeLeftImageView][timeLeftValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.timeLeftValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.timeLeftKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.timeLeftImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.timeLeftKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.timeLeftValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.timeLeftKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[timeLeftImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[timeLeftImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cashOutButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.cashOutButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstCurrencyLabel]-10-[priceKeyLabel]-10-[winLossKeyLabel]-10-[timeLeftKeyLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.firstCurrencyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.view addConstraints:self.customConstraints];
}

@end