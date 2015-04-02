//
//  COStartViewController.m
//  Cash Out
//
//  Created by Stefan Walkner on 01.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COStartViewController.h"
#import "COPlayHomeViewController.h"

@interface COStartViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *balanceTitelLabel;
@property (nonatomic, strong) UILabel *balanceAmountLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSMutableArray *customConstraints;

@end

@implementation COStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customConstraints = [[NSMutableArray alloc] init];

    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.logoImageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.logoImageView];

    self.balanceTitelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceTitelLabel.text = [NSLocalizedString(@"your balance is", @"") uppercaseString];
    self.balanceTitelLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.balanceTitelLabel];

    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.currencyCode = @"USD";
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    self.balanceAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceAmountLabel.text = [currencyFormatter stringFromNumber:@(100000)];
    [self.view addSubview:self.balanceAmountLabel];

    self.playButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.playButton.backgroundColor = [UIColor greenColor];
    [self.playButton setTitle:[NSLocalizedString(@"play", @"") uppercaseString] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];

    [self.view setNeedsUpdateConstraints];
}

- (void)play {
    COPlayHomeViewController *playHomeViewController = [[COPlayHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:playHomeViewController animated:YES];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"logoImageView" : self.logoImageView,
            @"balanceTitelLabel" : self.balanceTitelLabel,
            @"balanceAmountLabel" : self.balanceAmountLabel,
            @"playButton" : self.playButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceAmountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceAmountLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceTitelLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceTitelLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.balanceAmountLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-60]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    [self.view addConstraints:self.customConstraints];
}

@end
