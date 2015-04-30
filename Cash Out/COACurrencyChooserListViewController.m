//
// Created by Stefan Walkner on 30.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACurrencyChooserListViewController.h"
#import "COACurrencies.h"
#import "COAPlayHomeViewController.h"
#import "COAButton.h"
#import "COAConstants.h"
#import "UIImage+ImageWithColor.h"
#import "COATriangleView.h"
#import "NSString+COAAdditions.h"

@interface COACurrencyChooserListViewController()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) COAPlayHomeViewController *playHomeViewController;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) COAButton *chooseButton;

@end

@implementation COACurrencyChooserListViewController

- (instancetype)initWithPlayHomeViewController:(COAPlayHomeViewController *)playHomeViewController currencySymbol:(NSString *)currencySymbol {
    self = [super init];
    if (self) {
        self.playHomeViewController = playHomeViewController;
        self.currencySymbol = currencySymbol;

        _buttons = [[NSMutableArray alloc] init];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.alwaysBounceVertical = NO;
        [self.view addSubview:self.scrollView];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [COAConstants darkBlueColor];

    _chooseButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:[COAConstants darkBlueColor] outterTriangleColor:nil];
    [self.chooseButton setTitle:NSLocalizedString(@"choose", @"").uppercaseString forState:UIControlStateNormal];
    [self.chooseButton setBackgroundImage:[UIImage imageWithColor:[COAConstants greenColor]] forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(chooseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseButton];

    for (NSString *currencyString in [COACurrencies currencyDisplayStrings]) {
        UIColor *borderColor = [currencyString isEqualToString:[COACurrencies currencyDisplayStrings].lastObject] ? [UIColor clearColor] : [COAConstants lightBlueColor];
        COAButton *currencyButton = [[COAButton alloc] initWithBorderColor:borderColor triangleColor:nil outterTriangleColor:nil];
        [currencyButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [currencyButton setTitle:currencyString forState:UIControlStateNormal];
        [currencyButton setBackgroundImage:[UIImage imageWithColor:[COAConstants darkBlueColor]] forState:UIControlStateNormal];
        [currencyButton setBackgroundImage:[UIImage imageWithColor:[COAConstants lightBlueColor]] forState:UIControlStateSelected];

        currencyButton.selected = [currencyString isEqualToString:[COACurrencies displayStringForSymbol:self.currencySymbol]];

        [self.buttons addObject:currencyButton];
        [self.scrollView addSubview:currencyButton];
    }

    NSInteger selectedButtonIndex = [self indexOfSelectedButton];
    [self buttonPressed:self.buttons[selectedButtonIndex]];

    [self.view setNeedsUpdateConstraints];
}

- (void)chooseButtonPressed:(COAButton *)chooseButton {
    NSInteger index = [self indexOfSelectedButton];
    [self.playHomeViewController setCurrencySymbol:[COACurrencies currencies][index]];

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (NSInteger)indexOfSelectedButton {
    NSInteger index = 0;
    for (COAButton *button in self.buttons) {
        if (button.isSelected) {
            return index;
        }

        index++;
    }

    return 0;
}

- (void)buttonPressed:(COAButton *)pressedButton {
    for (COAButton *button in self.buttons) {
        button.selected = [button isEqual:pressedButton];

        NSInteger index = [self.buttons indexOfObject:button];
        NSString *currencyString = [COACurrencies currencyDisplayStrings][index];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:currencyString];
        [attributedString addAttributes:@{
                NSFontAttributeName:[COAConstants currencyOverviewChartDataCurrencyInBracketsChartView],
                NSForegroundColorAttributeName:[UIColor whiteColor]
        } range:NSMakeRange(0, currencyString.length)];

        if (!button.selected && [currencyString rangeOfString:@" / "].location != NSNotFound) {
            [attributedString setAttributes:@{
                    NSFontAttributeName:[COAConstants currencyOverviewChartDataCurrencyInBracketsChartView],
                    NSForegroundColorAttributeName:[COAConstants lightBlueColor]
            } range:NSMakeRange(0, currencyString.length)];

            NSString *firstCurrencyString = [currencyString substringToIndex:[currencyString rangeOfString:@"/"].location - 1];
            NSString *secondCurrencyString = [currencyString substringFromIndex:[currencyString rangeOfString:@"/"].location + 2];
            NSArray *firstWords = [firstCurrencyString componentsSeparatedByString:@" "];
            NSArray *secondWords = [secondCurrencyString componentsSeparatedByString:@" "];

            if (firstWords.count == 2) {
                [attributedString addAttributes:@{
                        NSFontAttributeName:[COAConstants currencyOverviewChartDataCurrencyInBracketsChartView],
                        NSForegroundColorAttributeName:[UIColor whiteColor]
                } range:NSMakeRange(0, [firstCurrencyString rangeOfString:@" "].location)];
            }
            [attributedString addAttributes:@{
                    NSFontAttributeName:[COAConstants currencyOverviewChartDataCurrencyInBracketsChartView],
                    NSForegroundColorAttributeName:[UIColor whiteColor]
            } range:[currencyString rangeOfString:@" / "]];
            if (secondWords.count == 2) {
                NSUInteger startSecondCurrency = [currencyString rangeOfString:secondCurrencyString].location;

                [attributedString addAttributes:@{
                        NSFontAttributeName:[COAConstants currencyOverviewChartDataCurrencyInBracketsChartView],
                        NSForegroundColorAttributeName:[UIColor whiteColor]
                } range:NSMakeRange(startSecondCurrency, [secondCurrencyString rangeOfString:@" "].location)];
            }
        }

        [button setAttributedTitle:attributedString forState:UIControlStateNormal];

    }

    [self.chooseButton.triangleView setTriangleColor:[COAConstants darkBlueColor]];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"scrollView" : self.scrollView,
            @"chooseButton" : self.chooseButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    COAButton *previousButton;

    [self.view layoutSubviews];
    CGFloat width = self.view.frame.size.width + 2;

    for (COAButton *button in self.buttons) {
        button.translatesAutoresizingMaskIntoConstraints = NO;

        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[button(width)]-(-1)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"width":@(width)} views:@{@"button":button}]];

        BOOL isLastButton = [button isEqual:self.buttons.lastObject];

        if (previousButton) {
            int padding = isLastButton ? 0 : -1;
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousButton]-(padding)-[button]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"padding":@(padding)} views:@{@"previousButton":previousButton, @"button":button}]];
        } else {
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"button":button}]];
        }

        if (isLastButton) {
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"button":button}]];
        }

        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(buttonHeight)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"buttonHeight":@(40)} views:@{@"button":button}]];

        previousButton = button;
    }

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView][chooseButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chooseButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chooseButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}

@end
