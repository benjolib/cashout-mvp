//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACurrencyButton.h"
#import "COAConstants.h"
#import "COADataFetcher.h"
#import "RLMRealm.h"
#import "COASymbolValue.h"
#import "RLMResults.h"
#import "COACurrencies.h"

@interface COACurrencyButton()

@property (nonatomic, strong, readwrite) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation COACurrencyButton

- (instancetype)initWithCurrencySymbol:(NSString *)currencyString {
    self = [super init];
    if (self) {
        self.currencySymbol = currencyString;
        self.translatesAutoresizingMaskIntoConstraints = NO;

        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        NSUInteger index = [[COACurrencies currencies] indexOfObject:currencyString];
        self.topLabel.text = [COACurrencies currencyDisplayStrings][index];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topLabel];

        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.bottomLabel.textColor = [COAConstants greenColor];
        self.bottomLabel.font = [UIFont boldSystemFontOfSize:22];
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.bottomLabel];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:) name:currencyString object:nil];

        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateCurrency:) userInfo:nil repeats:YES];

        [self updateText:nil];

        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{
            @"topLabel" : self.topLabel,
            @"bottomLabel" : self.bottomLabel
    };

    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLabel attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
}

- (void)setActive:(BOOL)active {
    _active = active;

    NSString *text = self.topLabel.text ? self.topLabel.text : self.topLabel.attributedText.string;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    [attributedString addAttributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
            NSForegroundColorAttributeName:[UIColor lightGrayColor]
    } range:NSMakeRange(0, text.length)];

    if (active && [text rangeOfString:@"/"].location != NSNotFound) {
        NSString *firstCurrencyString = [text substringToIndex:[text rangeOfString:@"/"].location - 1];
        NSString *secondCurrencyString = [text substringFromIndex:[text rangeOfString:@"/"].location + 2];
        NSArray *firstWords = [firstCurrencyString componentsSeparatedByString:@" "];
        NSArray *secondWords = [secondCurrencyString componentsSeparatedByString:@" "];

        if (firstWords.count == 2) {
            [attributedString addAttributes:@{
                    NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                    NSForegroundColorAttributeName:[COAConstants greenColor]
            } range:NSMakeRange(0, [firstCurrencyString rangeOfString:@" "].location)];
        }
        [attributedString addAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                NSForegroundColorAttributeName:[COAConstants greenColor]
        } range:[text rangeOfString:@" / "]];
        if (secondWords.count == 2) {
            NSUInteger startSecondCurrency = [text rangeOfString:secondCurrencyString].location;

            [attributedString addAttributes:@{
                    NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                    NSForegroundColorAttributeName:[COAConstants greenColor]
            } range:NSMakeRange(startSecondCurrency, [secondCurrencyString rangeOfString:@" "].location)];
        }
    }
    self.topLabel.attributedText = attributedString;
}

- (void)updateText:(id)sender {
    self.bottomLabel.text = [NSString stringWithFormat:@"%f", [COASymbolValue latestValueForSymbol:self.currencySymbol]];
}

- (void)updateCurrency:(id)sender {
    [[COADataFetcher instance] fetchDataForSymbol:self.currencySymbol completionBlock:^(NSString *value) {
        self.bottomLabel.text = value;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
