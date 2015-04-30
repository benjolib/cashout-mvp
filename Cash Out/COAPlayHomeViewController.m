//
// Created by Stefan Walkner on 01.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAPlayHomeViewController.h"
#import "COAChartViewController.h"
#import "COATradeModeViewController.h"
#import "COAConstants.h"
#import "COAButton.h"
#import "COAButtonTitleImage.h"
#import "SAMGradientView.h"
#import "COACurrencyButton.h"
#import "COAFormatting.h"
#import "UIImage+ImageWithColor.h"
#import "COACurrencies.h"
#import "COADataHelper.h"
#import "COATutorialViewController.h"
#import "AppDelegate.h"
#import "COAShadowView.h"
#import "SVProgressHUD.h"
#import "COADataFetcher.h"
#import "NSDate+MTDates.h"
#import "COACurrencyChooserListViewController.h"

#define kCellWidth 180

@interface COAPlayHomeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) COAButtonTitleImage *minusButton;
@property (nonatomic, strong) UILabel *amountToTradeTextField;
@property (nonatomic, strong) COAButtonTitleImage *plusButton;
@property (nonatomic, strong) UIScrollView *currencyScrollView;
@property (nonatomic, strong) UIButton *viewChartButton;
@property (nonatomic, strong) COAButton *riseButton;
@property (nonatomic, strong) COAButton *fallButton;
@property (nonatomic, strong, readwrite) COAButton *tradeButton;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) COAShadowView *leftShadowView;
@property (nonatomic, strong) COAShadowView *rightShadowView;
@property (nonatomic, strong) NSMutableArray *currencyButtons;
@property (nonatomic, strong) NSMutableArray *customScrollViewConstraints;
@property (nonatomic, strong) UIView *grayLineBelowScrollView;
@property (nonatomic, strong) UIView *greenLineBelowScrollView;
@property (nonatomic, strong) COATutorialViewController *tutorialViewController;
@property (nonatomic) double moneyToBet;
@property (nonatomic) NSUInteger targetIndex;

@end

@implementation COAPlayHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [COAConstants darkBlueColor];

    self.moneyToBet = MIN(10000, [COADataHelper instance].money);

    _customConstraints = [[NSMutableArray alloc] init];
    _currencyButtons = [[NSMutableArray alloc] init];
    _customScrollViewConstraints = [[NSMutableArray alloc] init];

    self.minusButton = [[COAButtonTitleImage alloc] initWithImage:[UIImage imageNamed:@"minus"] title:@"($ 2.000)"];
    self.minusButton.backgroundColor = [COAConstants darkBlueColor];
    [self.minusButton addTarget:self action:@selector(changeMoneyToBet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.minusButton];

    self.amountToTradeTextField = [[UILabel alloc] initWithFrame:CGRectZero];
    self.amountToTradeTextField.backgroundColor = [COAConstants darkBlueColor];
    self.amountToTradeTextField.textColor = [UIColor whiteColor];
    self.amountToTradeTextField.text = [COAFormatting currencyStringFromValue:self.moneyToBet];
    self.amountToTradeTextField.font = [UIFont boldSystemFontOfSize:24];
    self.amountToTradeTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.amountToTradeTextField];

    self.plusButton = [[COAButtonTitleImage alloc] initWithImage:[UIImage imageNamed:@"plus"] title:@"($ 2.000)"];;
    self.plusButton.backgroundColor = [COAConstants darkBlueColor];
    [self.plusButton addTarget:self action:@selector(changeMoneyToBet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.plusButton];

    self.currencyScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.currencyScrollView.backgroundColor = [UIColor whiteColor];
    self.currencyScrollView.delegate = self;
    self.currencyScrollView.showsHorizontalScrollIndicator = NO;
    self.currencyScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.currencyScrollView];

    _grayLineBelowScrollView = [[UIView alloc] initWithFrame:CGRectZero];
    self.grayLineBelowScrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.grayLineBelowScrollView];

    _greenLineBelowScrollView = [[UIView alloc] initWithFrame:CGRectZero];
    self.greenLineBelowScrollView.backgroundColor = [COAConstants greenColor];
    [self.view addSubview:self.greenLineBelowScrollView];

    self.viewChartButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.viewChartButton.backgroundColor = [COAConstants darkBlueColor];
    [self.viewChartButton setTitle:[NSLocalizedString(@"view chart", @"") uppercaseString] forState:UIControlStateNormal];
    [self.viewChartButton setImage:[UIImage imageNamed:@"chart"] forState:UIControlStateNormal];
    self.viewChartButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.viewChartButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [self.viewChartButton addTarget:self action:@selector(gotoChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.viewChartButton];

    UIColor *shadowColor = [UIColor colorWithRed:100/255.f green:100/255.f blue:100/255.f alpha:0.3];
    _leftShadowView = [[COAShadowView alloc] initWithFrame:CGRectZero];
    [self.leftShadowView setGradientColors:@[shadowColor, [UIColor clearColor]]];
    self.leftShadowView.backgroundColor = [UIColor clearColor];
    [self.leftShadowView setGradientDirection:SAMGradientViewDirectionHorizontal];
    [self.view addSubview:self.leftShadowView];

    _rightShadowView = [[COAShadowView alloc] initWithFrame:CGRectZero];
    [self.rightShadowView setGradientColors:@[[UIColor clearColor], shadowColor]];
    self.rightShadowView.backgroundColor = [UIColor clearColor];
    [self.rightShadowView setGradientDirection:SAMGradientViewDirectionHorizontal];
    [self.view addSubview:self.rightShadowView];

    self.riseButton = [[COAButton alloc] initWithBorderColor:[COAConstants lightBlueColor] triangleColor:nil outterTriangleColor:nil];
    [self.riseButton setBackgroundImage:[UIImage imageWithColor:[COAConstants lightBlueColor]] forState:UIControlStateSelected];
    [self.riseButton setBackgroundImage:[UIImage imageWithColor:[COAConstants darkBlueColor]] forState:UIControlStateNormal];
    [self.riseButton setBackgroundImage:[UIImage imageWithColor:[COAConstants lightBlueColor]] forState:UIControlStateHighlighted];
    self.riseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.riseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [self.riseButton addTarget:self action:@selector(riseFallButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.riseButton setImage:[UIImage imageNamed:@"arrow-up"] forState:UIControlStateNormal];
    [self.riseButton setTitle:[NSLocalizedString(@"rise", @"") uppercaseString] forState:UIControlStateNormal];
    [self.view addSubview:self.riseButton];

    self.fallButton = [[COAButton alloc] initWithBorderColor:[COAConstants lightBlueColor] triangleColor:nil outterTriangleColor:nil];
    [self.fallButton setBackgroundImage:[UIImage imageWithColor:[COAConstants lightBlueColor]] forState:UIControlStateSelected];
    [self.fallButton setBackgroundImage:[UIImage imageWithColor:[COAConstants darkBlueColor]] forState:UIControlStateNormal];
    [self.fallButton setBackgroundImage:[UIImage imageWithColor:[COAConstants lightBlueColor]] forState:UIControlStateHighlighted];
    self.fallButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.fallButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [self.fallButton addTarget:self action:@selector(riseFallButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.fallButton setImage:[UIImage imageNamed:@"arrow-down"] forState:UIControlStateNormal];
    [self.fallButton setTitle:[NSLocalizedString(@"fall", @"") uppercaseString] forState:UIControlStateNormal];
    [self.view addSubview:self.fallButton];

    self.tradeButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:nil outterTriangleColor:[COAConstants lightBlueColor]];
    [self.tradeButton setTitle:[NSLocalizedString(@"choose fall or rise", @"") uppercaseString] forState:UIControlStateDisabled];
    [self.tradeButton setTitle:[NSLocalizedString(@"play", @"") uppercaseString] forState:UIControlStateNormal];
    [self.tradeButton addTarget:self action:@selector(gotoTrade) forControlEvents:UIControlEventTouchUpInside];
    [self.tradeButton setBackgroundImage:[UIImage imageWithColor:[COAConstants lightBlueColor]] forState:UIControlStateDisabled];
    [self.tradeButton setBackgroundImage:[UIImage imageWithColor:[COAConstants greenColor]] forState:UIControlStateNormal];
    self.tradeButton.enabled = NO;
    [self.view addSubview:self.tradeButton];

    if (![[COADataHelper instance] tutorialSeen]) {
        _tutorialViewController = [[COATutorialViewController alloc] initWithPlayHomeViewController:self];
        UIView *viewToAddTo = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;

        while (viewToAddTo.superview) {
            viewToAddTo = viewToAddTo.superview;
        }

        [viewToAddTo addSubview:self.tutorialViewController.view];
    }

    [self fillScrollViewWithCurrencyButtons];

    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = [NSLocalizedString(@"Specify Trade", @"") uppercaseString];
}

- (void)setCurrencySymbol:(NSString *)currencySymbol {
    // get buttonIndex to scroll to
    self.targetIndex = [[COACurrencies currencies] indexOfObject:currencySymbol];
    COACurrencyButton *currencyButton = self.currencyButtons[self.targetIndex];
    [self.currencyScrollView scrollRectToVisible:currencyButton.frame animated:NO];

    CGPoint contentOffset = CGPointMake((CGFloat) (self.targetIndex * kCellWidth), 0);
    self.currencyScrollView.contentOffset = contentOffset;
    [self scrollViewDidEndDecelerating:self.currencyScrollView];
}

- (void)riseFallButtonPressed:(UIButton *)sender {
    self.fallButton.selected = NO;
    self.riseButton.selected = NO;

    sender.selected = YES;
    self.tradeButton.enabled = YES;
}

- (void)changeMoneyToBet:(UIButton *)sender {
    if ([sender isEqual:self.minusButton]) {
        self.moneyToBet = MAX(0, self.moneyToBet - 2000);
    } else {
        self.moneyToBet = MIN([[NSUserDefaults standardUserDefaults] doubleForKey:MONEY_USER_SETTING], self.moneyToBet + 2000);
    }

    self.amountToTradeTextField.text = [COAFormatting currencyStringFromValue:self.moneyToBet];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    double targetX = scrollView.contentOffset.x + velocity.x * 100.0;

    if (velocity.x > 0) {
        self.targetIndex = (NSUInteger) ceil(targetX / kCellWidth);
    } else {
        self.targetIndex = (NSUInteger) floor(targetX / kCellWidth);
    }

    targetContentOffset->x = (CGFloat) (self.targetIndex * kCellWidth);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.targetIndex >= self.currencyButtons.count) {
        return;
    }

    for (COACurrencyButton *button in self.currencyButtons) {
        button.active = [self.currencyButtons[self.targetIndex] isEqual:button];
    }

    [UIView animateWithDuration:0.4f animations:^{
        self.greenLineBelowScrollView.alpha = 1.f;
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.2f animations:^{
        self.greenLineBelowScrollView.alpha = 0.f;
    }];
}

- (void)fillScrollViewWithCurrencyButtons {
    for (NSString *currency in [COACurrencies currencyDisplayStrings]) {
        NSUInteger index = [[COACurrencies currencyDisplayStrings] indexOfObject:currency];
        COACurrencyButton *currencyButton = [[COACurrencyButton alloc] initWithCurrencySymbol:[COACurrencies currencies][index]];
        [self.currencyScrollView addSubview:currencyButton];
        [self.currencyButtons addObject:currencyButton];
        currencyButton.active = [[self.currencyButtons firstObject] isEqual:currencyButton];
        [currencyButton addTarget:self action:@selector(currencyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)currencyButtonPressed:(COACurrencyButton *)senderButton {
    COACurrencyChooserListViewController *currencyChooserListViewController = [[COACurrencyChooserListViewController alloc] initWithPlayHomeViewController:self];
    [self.navigationController pushViewController:currencyChooserListViewController animated:YES];
}

- (void)gotoChart {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    NSDate *dayFromDate = [[COADataHelper instance] toDateDayScaleForSymbol:self.selectedCurrencySymbol];
    NSDate *hourFromDate = [[COADataHelper instance] toDateHourScaleForSymbol:self.selectedCurrencySymbol];
    NSDate *minuteFromDate = [[COADataHelper instance] toDateMinuteScaleForSymbol:self.selectedCurrencySymbol];

    NSLog(@"%@", dayFromDate);
    NSLog(@"%@", hourFromDate);
    NSLog(@"%@", minuteFromDate);

    [[COADataFetcher instance] fetchLiveDataForSymbol:self.selectedCurrencySymbol fromDate:dayFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
        [[COADataFetcher instance] fetchLiveDataForSymbol:self.selectedCurrencySymbol fromDate:hourFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
            [[COADataFetcher instance] fetchLiveDataForSymbol:self.selectedCurrencySymbol fromDate:minuteFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
                [SVProgressHUD dismiss];

                COAChartViewController *chartViewController = [[COAChartViewController alloc] initWithCurrencySymbol:[self selectedCurrencySymbol]];
                [self.navigationController pushViewController:chartViewController animated:YES];
            }];
        }];
    }];
}

- (void)gotoTrade {
    COATradeModeViewController *tradeModeViewController = [[COATradeModeViewController alloc] initWithCurrencySymbol:self.selectedCurrencySymbol moneySet:self.moneyToBet betOnRise:self.riseButton.selected];
    [self.navigationController pushViewController:tradeModeViewController animated:YES];
}

- (NSString *)selectedCurrencySymbol {
    return [COACurrencies currencies][self.targetIndex];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"minusButton" : self.minusButton,
            @"amountToTradeTextField" : self.amountToTradeTextField,
            @"plusButton" : self.plusButton,
            @"currencyScrollView" : self.currencyScrollView,
            @"greenLineBelowScrollView" : self.greenLineBelowScrollView,
            @"grayLineBelowScrollView" : self.grayLineBelowScrollView,
            @"viewChartButton" : self.viewChartButton,
            @"leftShadowView" : self.leftShadowView,
            @"rightShadowView" : self.rightShadowView,
            @"riseButton" : self.riseButton,
            @"fallButton" : self.fallButton,
            @"tradeButton" : self.tradeButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.currencyScrollView removeConstraints:self.customScrollViewConstraints];
    [self.customConstraints removeAllObjects];
    [self.customScrollViewConstraints removeAllObjects];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minusButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:-9]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeHeight multiplier:1 constant:-18]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[plusButton]-0-[amountToTradeTextField(140)]-0-[minusButton]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftShadowView(25)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightShadowView(25)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.leftShadowView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.rightShadowView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.leftShadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.rightShadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[currencyScrollView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minusButton]-0-[currencyScrollView(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.grayLineBelowScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.greenLineBelowScrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.grayLineBelowScrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.greenLineBelowScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.grayLineBelowScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.greenLineBelowScrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[grayLine(5)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"grayLine":self.grayLineBelowScrollView}]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[grayLine]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"grayLine":self.grayLineBelowScrollView}]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[greenLine(width)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"width":@(kCellWidth)} views:@{@"greenLine":self.greenLineBelowScrollView}]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewChartButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewChartButton(<=155)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.viewChartButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.fallButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.riseButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[riseButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[fallButton]-(-1)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[riseButton]-(-1)-[fallButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[riseButton(100)]-(>=0)-[tradeButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewChartButton]-20-[riseButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.fallButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.riseButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.fallButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.riseButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tradeButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tradeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    COACurrencyButton *previousCB;

    [self.view layoutSubviews];
    CGFloat width = self.view.frame.size.width;
    CGFloat padding = (width - kCellWidth) / 2;

    for (COACurrencyButton *cb in self.currencyButtons) {
        [self.customScrollViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cb(width)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"width":@(kCellWidth)} views:@{@"cb":cb}]];
        [self.customScrollViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cb]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"cb":cb}]];
        [self.customScrollViewConstraints addObject:[NSLayoutConstraint constraintWithItem:cb attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.currencyScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];


        if ([cb isEqual:self.currencyButtons.firstObject]) {
            [self.customScrollViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[cb]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"padding":@(padding)} views:@{@"cb":cb}]];
        }
        if (previousCB) {
            [self.customScrollViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousCB][cb]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"previousCB":previousCB,@"cb":cb}]];
        }
        if ([cb isEqual:self.currencyButtons.lastObject]) {
            [self.customScrollViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cb]-(padding)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"padding":@(padding)} views:@{@"cb":cb}]];
        }

        previousCB = cb;
    }

    [self.view addConstraints:self.customConstraints];
    [self.currencyScrollView addConstraints:self.customScrollViewConstraints];
}

- (CGFloat)lowerNavigationBar {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.view.superview convertRect:self.view.frame toView:view];
    return CGRectGetMinY(rect);
}

- (CGFloat)upperScrollView {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.currencyScrollView.superview convertRect:self.currencyScrollView.frame toView:view];
    return CGRectGetMinY(rect);
}

- (CGFloat)lowerScrollView {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.currencyScrollView.superview convertRect:self.currencyScrollView.frame toView:view];
    return CGRectGetMaxY(rect);
}

- (CGFloat)upperRiseButton {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.riseButton.superview convertRect:self.riseButton.frame toView:view];
    return CGRectGetMinY(rect);
}

- (CGFloat)lowerRiseButton {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.riseButton.superview convertRect:self.riseButton.frame toView:view];
    return CGRectGetMaxY(rect);
}

- (CGFloat)upperPlayButton {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.tradeButton.superview convertRect:self.tradeButton.frame toView:view];
    return CGRectGetMinY(rect);
}

- (CGFloat)lowerPlayButton {
    UIView *view = ((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController.view;
    CGRect rect = [self.tradeButton.superview convertRect:self.tradeButton.frame toView:view];
    return CGRectGetMaxY(rect);
}

@end
