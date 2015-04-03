//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACashOutViewController.h"

@interface COACashOutViewController()

@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) UILabel *congratsLabel;
@property (nonatomic, strong) UILabel *balanceTextLabel;
@property (nonatomic, strong) UILabel *balanceAmountLabel;
@property (nonatomic, strong) UIButton *playAgainButton;

@end

@implementation COACashOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _customConstraints = [[NSMutableArray alloc] init];

    _congratsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *substring = [NSString stringWithFormat:NSLocalizedString(@"You won %@", @""), @"$ 20.000"];
    self.congratsLabel.text = [NSString stringWithFormat:@"%@\n%@", [NSLocalizedString(@"congrats", @"") uppercaseString], substring.uppercaseString];
    self.congratsLabel.backgroundColor = [UIColor grayColor];
    self.congratsLabel.textAlignment = NSTextAlignmentCenter;
    self.congratsLabel.numberOfLines = 0;
    [self.view addSubview:self.congratsLabel];

    _balanceTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceTextLabel.text = [NSLocalizedString(@"your new balance is", @"") uppercaseString];
    self.balanceTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.balanceTextLabel];

    _balanceAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceAmountLabel.text = @"$ 120.000";
    self.balanceAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.balanceAmountLabel];

    _playAgainButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.playAgainButton setTitle:[NSLocalizedString(@"play again", @"") uppercaseString] forState:UIControlStateNormal];
    [self.playAgainButton addTarget:self action:@selector(playAgain) forControlEvents:UIControlEventTouchUpInside];
    self.playAgainButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.playAgainButton];

    [self.view setNeedsUpdateConstraints];
}

- (void)playAgain {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"congratsLabel":self.congratsLabel,
            @"balanceTextLabel":self.balanceTextLabel,
            @"balanceAmountLabel":self.balanceAmountLabel,
            @"playAgainButton":self.playAgainButton
    };

    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[congratsLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[balanceTextLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[balanceAmountLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playAgainButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[congratsLabel][balanceTextLabel][balanceAmountLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.playAgainButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    [self.view addConstraints:self.customConstraints];
}

@end