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
#import "COAOnboardingViewController.h"
#import "COAMarketHelper.h"
#import "COAMarketClosedView.h"
#import "COADataFetcher.h"

@interface COStartViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *balanceTitelLabel;
@property (nonatomic, strong) UILabel *balanceAmountLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *overallPositionLabel;
@property (nonatomic, strong) COAButton *playButton;
@property (nonatomic, strong) COAButton *ranOutOfMoneyButton;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) NSMutableArray *overlayCustomConstraints;
@property (nonatomic, strong) COAOnboardingViewController *onboardingViewController;
@property (nonatomic, strong) COAMarketClosedView *marketClosedView;

@end

@implementation COStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customConstraints = [[NSMutableArray alloc] init];
    _overlayCustomConstraints = [[NSMutableArray alloc] init];

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

    _positionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.positionLabel.textColor = [COAConstants greenColor];
    self.positionLabel.textAlignment = NSTextAlignmentCenter;
    self.positionLabel.font = [COAConstants tradeBudgetCurrencyRate];
    [self.view addSubview:self.positionLabel];

    _overallPositionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.overallPositionLabel.textColor = [COAConstants grayColor];
    self.overallPositionLabel.font = [COAConstants pageHeadlineTutorialBtnText];
    self.overallPositionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.overallPositionLabel];

    _ranOutOfMoneyButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:nil outterTriangleColor:[COAConstants greenColor]];
    self.ranOutOfMoneyButton.backgroundColor = [COAConstants greenColor];
    [self.ranOutOfMoneyButton setTitle:NSLocalizedString(@"you ran out of money", @"").uppercaseString forState:UIControlStateNormal];
    self.ranOutOfMoneyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.ranOutOfMoneyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.ranOutOfMoneyButton addTarget:self action:@selector(ranOutOfMoneyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ranOutOfMoneyButton];

    self.playButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:[UIColor whiteColor] outterTriangleColor:nil];
    self.playButton.backgroundColor = [COAConstants darkBlueColor];
    [self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];

    [self.balanceAmountLabel sizeToFit];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBalanceToZero)];
    tapGestureRecognizer.numberOfTapsRequired = 3;
    tapGestureRecognizer.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    [self.view setNeedsUpdateConstraints];
    
    if (![COAMarketHelper checkIfMarketIsOpen]) {
        self.marketClosedView = [[COAMarketClosedView alloc] initWithCompletionBlock:^(BOOL onlyClose) {
        }];
        [self.view addSubview:self.marketClosedView];
    }
}

- (void)setBalanceToZero {
    [[COADataHelper instance] saveMoney:0];

    [self updateView];
}

- (void)ranOutOfMoneyButtonPressed {
    COASignUpViewController *signUpViewController = [[COASignUpViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (void)updateView {
    self.ranOutOfMoneyButton.hidden = [COADataHelper instance].money > 0;
    self.balanceAmountLabel.text = [COAFormatting currencyStringFromValue:[COADataHelper instance].money];
    NSString *buttonTitle = [COADataHelper instance].money > 0 ? NSLocalizedString(@"play", @"") : NSLocalizedString(@"refill your balance", @"");
    [self.playButton setTitle:[buttonTitle uppercaseString] forState:UIControlStateNormal];

    self.positionLabel.hidden = !self.ranOutOfMoneyButton.hidden;
    self.overallPositionLabel.hidden = self.positionLabel.hidden;

    self.playButton.enabled = [COAMarketHelper checkIfMarketIsOpen];

    [[COADataFetcher instance] fetchPositionWithCompletionBlock:^(NSInteger position) {
        NSString *positionSuffix = [COStartViewController ordinalNumberFormat:[COADataFetcher position]];
        NSString *globalPositionSuffix = [COStartViewController ordinalNumberFormat:[COADataFetcher globalPosition]];
        
        self.positionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"position", @""), (long)[COADataFetcher position], positionSuffix].uppercaseString;
        self.overallPositionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"globalPosition", @""), (long)[COADataFetcher globalPosition], globalPositionSuffix].uppercaseString;
    }];
}

+(NSString*)ordinalNumberFormat:(NSInteger)num{
    int ones = num % 10;
    int tens = (int) floor(num / 10);
    tens = tens % 10;
    if(tens == 1){
        return @"th";
    }else {
        switch (ones) {
            case 1:
                return @"st";
            case 2:
                return @"nd";
            case 3:
                return @"rd";
            default:
                return @"th";
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateView];
    
    if (![[COADataHelper instance] onboardingSeen]) {
        [[COADataHelper instance] setOnboardingSeen];
        self.onboardingViewController = [[COAOnboardingViewController alloc] initWithNibName:@"COAOnboardingViewController" bundle:nil];
        [self presentViewController:self.onboardingViewController animated:NO completion:^{
            
        }];
    }
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
            @"positionLabel" : self.positionLabel,
            @"overallPositionLabel" : self.overallPositionLabel,
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

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[positionLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[overallPositionLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[ranOutOfMoneyButton]-30-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[balanceAmountLabel]-(>=15)-[ranOutOfMoneyButton]-30-[playButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[balanceAmountLabel]-5-[positionLabel]-0-[overallPositionLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    if (self.marketClosedView.superview) {
        [self.overlayCustomConstraints removeAllObjects];
        UIView *viewToAddOverlay = self.view;

        while (viewToAddOverlay.superview) {
            viewToAddOverlay = viewToAddOverlay.superview;
        }

        [viewToAddOverlay addSubview:self.marketClosedView];

        [viewToAddOverlay removeConstraints:self.overlayCustomConstraints];

        [self.overlayCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"cv":self.marketClosedView}]];
        [self.overlayCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"cv":self.marketClosedView}]];
        [viewToAddOverlay addConstraints:self.overlayCustomConstraints];
    }

    [self.view addConstraints:self.customConstraints];
}

@end
