//
// Created by Stefan Walkner on 01.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAPlayHomeViewController.h"
#import "COACurrencyChooserViewController.h"
#import "COAChartViewController.h"

@interface COAPlayHomeViewController ()

@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UITextField *amountToTradeTextField;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *currencyButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *viewChartButton;
@property (nonatomic, strong) UIButton *riseButton;
@property (nonatomic, strong) UIButton *fallButton;
@property (nonatomic, strong) UIButton *tradeButton;
@property (nonatomic, strong) NSMutableArray *customConstraints;

@end

@implementation COAPlayHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSLocalizedString(@"Specify Trade", @"") uppercaseString];

    self.view.backgroundColor = [UIColor whiteColor];

    self.customConstraints = [[NSMutableArray alloc] init];

    self.minusButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.minusButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.minusButton];

    self.amountToTradeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.amountToTradeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountToTradeTextField.backgroundColor = [UIColor darkGrayColor];
    self.amountToTradeTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.amountToTradeTextField];

    self.plusButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.plusButton.backgroundColor = self.minusButton.backgroundColor;
    [self.view addSubview:self.plusButton];

    self.previousButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.previousButton.backgroundColor = self.minusButton.backgroundColor;
    [self.view addSubview:self.previousButton];

    self.currencyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.currencyButton.backgroundColor = self.amountToTradeTextField.backgroundColor;
    [self.currencyButton addTarget:self action:@selector(gotoCurrencyChooser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.currencyButton];

    self.nextButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.nextButton.backgroundColor = self.minusButton.backgroundColor;
    [self.view addSubview:self.nextButton];

    self.viewChartButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.viewChartButton.backgroundColor = self.minusButton.backgroundColor;
    [self.viewChartButton addTarget:self action:@selector(gotoChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.viewChartButton];

    self.riseButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.riseButton.backgroundColor = self.minusButton.backgroundColor;
    [self.view addSubview:self.riseButton];

    self.fallButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.fallButton.backgroundColor = self.minusButton.backgroundColor;
    [self.view addSubview:self.fallButton];

    self.tradeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.tradeButton setTitle:[NSLocalizedString(@"trade", @"") uppercaseString] forState:UIControlStateNormal];
    self.tradeButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tradeButton];

    [self.view setNeedsUpdateConstraints];
}

- (void)gotoCurrencyChooser {
    COACurrencyChooserViewController *currencyChooserViewController = [[COACurrencyChooserViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:currencyChooserViewController animated:YES];
}

- (void)gotoChart {
    COAChartViewController *chartViewController = [[COAChartViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:chartViewController animated:YES];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"minusButton" : self.minusButton,
            @"amountToTradeTextField" : self.amountToTradeTextField,
            @"plusButton" : self.plusButton,
            @"previousButton" : self.previousButton,
            @"currencyButton" : self.currencyButton,
            @"nextButton" : self.nextButton,
            @"viewChartButton" : self.viewChartButton,
            @"riseButton" : self.riseButton,
            @"fallButton" : self.fallButton,
            @"tradeButton" : self.tradeButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.amountToTradeTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[minusButton]-10-[amountToTradeTextField(200)]-10-[plusButton]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[previousButton]-10-[currencyButton(200)]-10-[nextButton]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.previousButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.currencyButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.previousButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.nextButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.previousButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.nextButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.previousButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.viewChartButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.viewChartButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.currencyButton attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.fallButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.riseButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[riseButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[fallButton]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[riseButton]-10-[fallButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[riseButton]-40-[tradeButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.fallButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.riseButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tradeButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tradeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    [self.view addConstraints:self.customConstraints];
}

@end