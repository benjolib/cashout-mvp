//
//  COStartViewController.m
//  Cash Out
//
//  Created by Stefan Walkner on 01.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COStartViewController.h"
#import "COAPlayHomeViewController.h"
#import "COAConstants.h"
#import "COAButton.h"
#import "COAFormatting.h"
#import "COADataHelper.h"
#import "COASignUpViewController.h"

@interface COStartViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *balanceTitelLabel;
@property (nonatomic, strong) UILabel *balanceAmountLabel;
@property (nonatomic, strong) COAButton *playButton;
@property (nonatomic, strong) COAButton *ranOutOfMoneyButton;
@property (nonatomic, strong) NSMutableArray *customConstraints;

@end

@implementation COStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customConstraints = [[NSMutableArray alloc] init];

    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.logoImageView.image = [UIImage imageNamed:@"App-Logo"];
    [self.logoImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logoImageView];

    self.balanceTitelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceTitelLabel.text = [NSLocalizedString(@"your balance is", @"") uppercaseString];
    self.balanceTitelLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.balanceTitelLabel];

    self.balanceAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceAmountLabel.textColor = [COAConstants darkBlueColor];
    self.balanceAmountLabel.font = [UIFont boldSystemFontOfSize:50];
    [self.balanceAmountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.view addSubview:self.balanceAmountLabel];

    _ranOutOfMoneyButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:nil outterTriangleColor:[COAConstants greenColor]];
    self.ranOutOfMoneyButton.backgroundColor = [COAConstants greenColor];
    [self.ranOutOfMoneyButton setTitle:NSLocalizedString(@"you ran out of money", @"").uppercaseString forState:UIControlStateNormal];
    self.ranOutOfMoneyButton.hidden = [COADataHelper instance].money > 0;
    self.ranOutOfMoneyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.ranOutOfMoneyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.ranOutOfMoneyButton addTarget:self action:@selector(ranOutOfMoneyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ranOutOfMoneyButton];

    self.playButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:[UIColor whiteColor] outterTriangleColor:nil];
    self.playButton.backgroundColor = [COAConstants darkBlueColor];
    NSString *buttonTitle = [COADataHelper instance].money > 0 ? NSLocalizedString(@"play", @"") : NSLocalizedString(@"refill your balance", @"");
    [self.playButton setTitle:[buttonTitle uppercaseString] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];

    [self.balanceAmountLabel sizeToFit];

    [self.view setNeedsUpdateConstraints];
}

- (void)ranOutOfMoneyButtonPressed {
    COASignUpViewController *signUpViewController = [[COASignUpViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.balanceAmountLabel.text = [COAFormatting currencyStringFromValue:[COADataHelper instance].money];
}

- (void)play {
    if ([COADataHelper instance].money == 0) {
        [self ranOutOfMoneyButtonPressed];
        return;
    }
    COAPlayHomeViewController *playHomeViewController = [[COAPlayHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:playHomeViewController animated:YES];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"logoImageView" : self.logoImageView,
            @"balanceTitelLabel" : self.balanceTitelLabel,
            @"balanceAmountLabel" : self.balanceAmountLabel,
            @"ranOutOfMoneyButton" : self.ranOutOfMoneyButton,
            @"playButton" : self.playButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceTitelLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceTitelLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.logoImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceAmountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.balanceAmountLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.balanceTitelLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[ranOutOfMoneyButton]-30-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[balanceAmountLabel]-(>=15)-[ranOutOfMoneyButton]-30-[playButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    [self.view addConstraints:self.customConstraints];
}

@end
