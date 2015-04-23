//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAChartViewController.h"
#import "COAConstants.h"
#import "UIImage+ImageWithColor.h"
#import "COAChartView.h"
#import "COASymbolValue.h"
#import "NSDate+MTDates.h"
#import "RLMRealm.h"
#import "RLMResults.h"

@interface COAChartViewController()

@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) UILabel *priceKeyLabel;
@property (nonatomic, strong) UILabel *priceValueLabel;
@property (nonatomic, strong) UILabel *changeKeyLabel;
@property (nonatomic, strong) UILabel *changeValueLabel;
@property (nonatomic, strong) UILabel *percentKeyChangeLabel;
@property (nonatomic, strong) UILabel *percentValueChangeLabel;
@property (nonatomic, strong) UILabel *dayRangeKeyLabel;
@property (nonatomic, strong) UILabel *dayRangeValueLabel;
@property (nonatomic, strong) UILabel *weeksRangeKeyLabel;
@property (nonatomic, strong) UILabel *weeksRangeValueLabel;
@property (nonatomic, strong) UIButton *day1Button;
@property (nonatomic, strong) UIButton *day5Button;
@property (nonatomic, strong) UIButton *month3Button;
@property (nonatomic, strong) UIButton *month6Button;
@property (nonatomic, strong) UIButton *year1Button;
@property (nonatomic, strong) UIButton *year2Button;
@property (nonatomic, strong) COAChartView *chartView;
@property (nonatomic, strong) UIView *buttonTopLineView;
@property (nonatomic, strong) UIView *buttonBottomLineView;
@property (nonatomic, strong) UIView *separator1View;
@property (nonatomic, strong) UIView *separator2View;
@property (nonatomic, strong) UIView *separator3View;
@property (nonatomic, strong) UIView *separator4View;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSDate *fromDate;

@end

@implementation COAChartViewController

- (instancetype)initWithCurrencySymbol:(NSString *)currencySymbol {
    self = [super init];
    if (self) {
        self.currencySymbol = currencySymbol;
        self.title = currencySymbol;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [COAConstants darkBlueColor];

    _customConstraints = [[NSMutableArray alloc] init];

    _priceKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceKeyLabel.text = [NSLocalizedString(@"price", @"") uppercaseString];
    self.priceKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.priceKeyLabel];

    _priceValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceValueLabel.text = [NSString stringWithFormat:@"%f", [COASymbolValue latestValueForSymbol:self.currencySymbol]];
    self.priceValueLabel.textAlignment = NSTextAlignmentRight;
    self.priceValueLabel.textColor = [UIColor whiteColor];
    self.priceValueLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.priceValueLabel];

    _changeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.changeKeyLabel.text = [NSLocalizedString(@"change", @"") uppercaseString];
    self.changeKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.changeKeyLabel];

    _changeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.changeValueLabel.text = @"0.0004";
    self.changeValueLabel.textAlignment = NSTextAlignmentRight;
    self.changeValueLabel.textColor = [COAConstants greenColor];
    self.changeValueLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.changeValueLabel];

    _percentKeyChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentKeyChangeLabel.text = [NSLocalizedString(@"% change", @"") uppercaseString];
    self.percentKeyChangeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.percentKeyChangeLabel];

    _percentValueChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentValueChangeLabel.textAlignment = NSTextAlignmentRight;
    self.percentValueChangeLabel.textColor = [COAConstants fleshColor];
    self.percentValueChangeLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.percentValueChangeLabel];

    _dayRangeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayRangeKeyLabel.text = [NSLocalizedString(@"day range", @"") uppercaseString];
    self.dayRangeKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.dayRangeKeyLabel];

    _dayRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayRangeValueLabel.textAlignment = NSTextAlignmentRight;
    self.dayRangeValueLabel.textColor = [UIColor whiteColor];
    self.dayRangeValueLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.dayRangeValueLabel];

    _weeksRangeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weeksRangeKeyLabel.text = [NSLocalizedString(@"52-weeks range", @"") uppercaseString];
    self.weeksRangeKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.weeksRangeKeyLabel];

    _weeksRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weeksRangeValueLabel.textAlignment = NSTextAlignmentRight;
    self.weeksRangeValueLabel.textColor = [UIColor whiteColor];
    self.weeksRangeValueLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.weeksRangeValueLabel];

    _day1Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.day1Button setTitle:[NSLocalizedString(@"1 day", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.day1Button];
    [self.view addSubview:self.day1Button];

    _day5Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.day5Button setTitle:[NSLocalizedString(@"5 days", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.day5Button];
    [self.view addSubview:self.day5Button];

    _month3Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.month3Button setTitle:[NSLocalizedString(@"3 months", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.month3Button];
    [self.view addSubview:self.month3Button];

    _month6Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.month6Button setTitle:[NSLocalizedString(@"6 months", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.month6Button];
    self.month6Button.selected = YES;
    [self.view addSubview:self.month6Button];

    _year1Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.year1Button setTitle:[NSLocalizedString(@"1 year", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.year1Button];
    [self.view addSubview:self.year1Button];

    _year2Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.year2Button setTitle:[NSLocalizedString(@"2 years", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.year2Button];
    [self.view addSubview:self.year2Button];

    _chartView = [[COAChartView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.chartView];

    _buttonTopLineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.buttonTopLineView.backgroundColor = [COAConstants lightBlueColor];
    [self.view addSubview:self.buttonTopLineView];

    _buttonBottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.buttonBottomLineView.backgroundColor = self.buttonTopLineView.backgroundColor;
    [self.view addSubview:self.buttonBottomLineView];

    _separator1View = [[UIView alloc] initWithFrame:CGRectZero];
    self.separator1View.backgroundColor = [COAConstants lightBlueColor];
    _separator2View = [[UIView alloc] initWithFrame:CGRectZero];
    self.separator2View.backgroundColor = self.separator1View.backgroundColor;
    _separator3View = [[UIView alloc] initWithFrame:CGRectZero];
    self.separator3View.backgroundColor = self.separator1View.backgroundColor;
    _separator4View = [[UIView alloc] initWithFrame:CGRectZero];
    self.separator4View.backgroundColor = self.separator1View.backgroundColor;

    [self.view addSubview:self.separator1View];
    [self.view addSubview:self.separator2View];
    [self.view addSubview:self.separator3View];
    [self.view addSubview:self.separator4View];

    [self setMinMaxLabel];

    [self filterButtonPressed:self.month6Button];

    [self.view setNeedsUpdateConstraints];
}

- (void)setMinMaxLabel {
    NSDate *fromDate = [[[NSDate date] mt_dateYearsBefore:1] mt_startOfCurrentDay];
    CGFloat min = MAXFLOAT;
    CGFloat max = -MAXFLOAT;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp > %@ AND timestamp < %@ AND symbol = %@", fromDate, [NSDate date], self.currencySymbol];
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    RLMResults *result = [COASymbolValue objectsInRealm:defaultRealm withPredicate:predicate];

    for (COASymbolValue *value in result) {
        min = MIN(value.value, min);
        max = MAX(value.value, max);
    }

    self.weeksRangeValueLabel.text = [NSString stringWithFormat:@"%f - %f", min, max];
}

- (void)configureFilterButton:(UIButton *)buttonToConfigure {
    [buttonToConfigure.titleLabel setFont:[UIFont systemFontOfSize:10]];
    buttonToConfigure.backgroundColor = [COAConstants darkBlueColor];
    [buttonToConfigure setTitleColor:[COAConstants darkBlueColor] forState:UIControlStateSelected];
    [buttonToConfigure setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [buttonToConfigure addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)filterButtonPressed:(UIButton *)button {
    self.day1Button.selected = NO;
    self.day5Button.selected = NO;
    self.month3Button.selected = NO;
    self.month6Button.selected = NO;
    self.year1Button.selected = NO;
    self.year2Button.selected = NO;

    button.selected = YES;

    if ([button isEqual:self.day1Button]) {
        self.fromDate = [[NSDate date] mt_dateDaysBefore:1];
    } else if ([button isEqual:self.day5Button]) {
        self.fromDate = [[NSDate date] mt_dateDaysBefore:5];
    } else if ([button isEqual:self.month3Button]) {
        self.fromDate = [[NSDate date] mt_dateMonthsBefore:3];
    } else if ([button isEqual:self.month6Button]) {
        self.fromDate = [[NSDate date] mt_dateMonthsBefore:6];
    } else if ([button isEqual:self.year1Button]) {
        self.fromDate = [[NSDate date] mt_dateYearsBefore:1];
    } else if ([button isEqual:self.year2Button]) {
        self.fromDate = [[NSDate date] mt_dateYearsBefore:2];
    }

    NSArray *values = [self valuesFromDate:self.fromDate toDate:[NSDate date]];
    [self updateChartWithValues:values];
}

- (NSArray *)valuesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSUInteger numberOfValues = 15;
    NSInteger numberOfSecondsBetweenDates = [toDate mt_secondsSinceDate:fromDate];
    NSInteger secondsBetweenValues = numberOfSecondsBetweenDates / numberOfValues;

    RLMRealm *realm = [RLMRealm defaultRealm];

    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:numberOfValues];

    NSDate *valueDate = [[fromDate mt_startOfCurrentDay] mt_startOfCurrentDay];

    for (int i = 0; i < numberOfValues; i++) {
        valueDate = [[valueDate mt_dateSecondsAfter:secondsBetweenValues] mt_startOfCurrentDay];

        if ([valueDate mt_isAfter:[NSDate date]]) {
            valueDate = [[NSDate date] mt_startOfCurrentDay];
        }

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol = %@ and timestamp = %@", self.currencySymbol, valueDate];
        COASymbolValue *symbolValue = [[COASymbolValue objectsInRealm:realm withPredicate:predicate] firstObject];

        int tries = 0;
        NSDate *innerValueDate = valueDate;
        while (symbolValue == nil) {
            innerValueDate = [[innerValueDate mt_dateSecondsAfter:tries * 60 * 60 * 24] mt_startOfCurrentDay];
            predicate = [NSPredicate predicateWithFormat:@"symbol = %@ and timestamp = %@", self.currencySymbol, innerValueDate];
            symbolValue = [[COASymbolValue objectsInRealm:realm withPredicate:predicate] firstObject];
            if (symbolValue == nil) {
                innerValueDate = [[innerValueDate mt_dateSecondsBefore:tries * 2 * 60 * 60 * 24] mt_startOfCurrentDay];
                predicate = [NSPredicate predicateWithFormat:@"symbol = %@ and timestamp = %@", self.currencySymbol, innerValueDate];
                symbolValue = [[COASymbolValue objectsInRealm:realm withPredicate:predicate] firstObject];
            }
            if (++tries > 120 || symbolValue) {
                break;
            }
        }

        [values addObject:symbolValue ? @(symbolValue.value) : @(0)];
    }

    return values;
}

- (void)updateChartWithValues:(NSArray *)values {
    [self.chartView updateChartWithValues:values fromDate:self.fromDate toDate:[NSDate date]];
}

- (NSDictionary *)allViews {
    return @{
            @"priceKeyLabel":self.priceKeyLabel,
            @"priceValueLabel":self.priceValueLabel,
            @"changeKeyLabel":self.changeKeyLabel,
            @"changeValueLabel":self.changeValueLabel,
            @"percentKeyChangeLabel":self.percentKeyChangeLabel,
            @"percentValueChangeLabel":self.percentValueChangeLabel,
            @"dayRangeKeyLabel":self.dayRangeKeyLabel,
            @"dayRangeValueLabel":self.dayRangeValueLabel,
            @"weeksRangeKeyLabel":self.weeksRangeKeyLabel,
            @"weeksRangeValueLabel":self.weeksRangeValueLabel,
            @"chartView":self.chartView,
            @"day1Button":self.day1Button,
            @"day5Button":self.day5Button,
            @"month3Button":self.month3Button,
            @"month6Button":self.month6Button,
            @"year1Button":self.year1Button,
            @"year2Button":self.year2Button,
            @"buttonTopLineView":self.buttonTopLineView,
            @"buttonBottomLineView":self.buttonBottomLineView,
            @"separator1View":self.separator1View,
            @"separator2View":self.separator2View,
            @"separator3View":self.separator3View,
            @"separator4View":self.separator4View
    };
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    for (UIView *view in [[self allViews] allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[priceKeyLabel][priceValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.priceKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.priceKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[changeKeyLabel][changeValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.changeValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.changeKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.changeValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.changeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[percentKeyChangeLabel][percentValueChangeLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.percentValueChangeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.percentKeyChangeLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.percentValueChangeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.percentKeyChangeLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[dayRangeKeyLabel][dayRangeValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.dayRangeValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.dayRangeKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.dayRangeValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dayRangeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[weeksRangeKeyLabel][weeksRangeValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.weeksRangeValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.weeksRangeKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.weeksRangeValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.weeksRangeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[chartView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];

    NSUInteger labelRowHeight = 50;
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceKeyLabel(labelRowHeight)]-5-[separator1View(1)]-5-[changeKeyLabel(labelRowHeight)]-5-[separator2View(1)]-5-[percentKeyChangeLabel(labelRowHeight)]-5-[separator3View(1)]-5-[dayRangeKeyLabel(labelRowHeight)]-5-[separator4View(1)]-5-[weeksRangeKeyLabel(labelRowHeight)]-5-[buttonTopLineView(1)]-0-[day1Button(40)]-0-[buttonBottomLineView(1)]-10-[chartView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"labelRowHeight":@(labelRowHeight)} views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceKeyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[day1Button][day5Button][month3Button][month6Button][year1Button][year2Button]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.day5Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month3Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month6Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year1Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year2Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.day5Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month3Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month6Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year1Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year2Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.day5Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month3Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month6Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year1Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year2Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator2View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator1View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator3View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator4View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonTopLineView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonBottomLineView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];

    [self.view addConstraints:self.customConstraints];
    [self.chartView setNeedsUpdateConstraints];
}

@end
