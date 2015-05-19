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
#import "COACurrencies.h"
#import "NSDate+COAAdditions.h"

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
@property (nonatomic, strong) UIButton *minutes30Button;
@property (nonatomic, strong) COAChartView *chartView;
@property (nonatomic, strong) UIView *buttonTopLineView;
@property (nonatomic, strong) UIView *buttonBottomLineView;
@property (nonatomic, strong) UIView *separator1View;
@property (nonatomic, strong) UIView *separator2View;
@property (nonatomic, strong) UIView *separator3View;
@property (nonatomic, strong) UIView *separator4View;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSArray *datesToFetch;
@property (nonatomic) double yesterdayValue;

@end

@implementation COAChartViewController

- (instancetype)initWithCurrencySymbol:(NSString *)currencySymbol datesToFetch:(NSArray *)datesToFetch {
    self = [super init];
    if (self) {
        self.currencySymbol = currencySymbol;
        self.datesToFetch = datesToFetch;

        NSInteger index = [[COACurrencies currencies] indexOfObject:self.currencySymbol];
        NSString *text = [COACurrencies currencyDisplayStrings][index];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedString addAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                NSForegroundColorAttributeName:[COAConstants lightBlueColor]
        } range:NSMakeRange(0, text.length)];

        if ([text rangeOfString:@"/"].location != NSNotFound) {
            NSString *firstCurrencyString = [text substringToIndex:[text rangeOfString:@"/"].location - 1];
            NSString *secondCurrencyString = [text substringFromIndex:[text rangeOfString:@"/"].location + 2];
            NSArray *firstWords = [firstCurrencyString componentsSeparatedByString:@" "];
            NSArray *secondWords = [secondCurrencyString componentsSeparatedByString:@" "];

            if (firstWords.count == 2) {
                [attributedString addAttributes:@{
                        NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                        NSForegroundColorAttributeName:[COAConstants darkBlueColor]
                } range:NSMakeRange(0, [firstCurrencyString rangeOfString:@" "].location)];
            }
            [attributedString addAttributes:@{
                    NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                    NSForegroundColorAttributeName:[COAConstants darkBlueColor]
            } range:[text rangeOfString:@" / "]];
            if (secondWords.count == 2) {
                NSUInteger startSecondCurrency = [text rangeOfString:secondCurrencyString].location;

                [attributedString addAttributes:@{
                        NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                        NSForegroundColorAttributeName:[COAConstants darkBlueColor]
                } range:NSMakeRange(startSecondCurrency, [secondCurrencyString rangeOfString:@" "].location)];
            }

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:HISTORY_DATA_LOADED object:nil];
        } else {
            [attributedString addAttributes:@{
                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                                              NSForegroundColorAttributeName:[COAConstants darkBlueColor]
                                              } range:NSMakeRange(0, text.length)];
        }

        titleLabel.attributedText = attributedString;
        self.navigationItem.titleView = titleLabel;
    }

    return self;
}

- (void)updateData {
    NSDate *startYesterday = [[[NSDate date] mt_dateDaysBefore:1] mt_startOfCurrentDay];
    NSDate *endYesterday = [[[NSDate date] mt_dateDaysBefore:1] mt_endOfCurrentDay];
    RLMResults *yesterdayValues = [[COASymbolValue objectsWithPredicate:[NSPredicate predicateWithFormat:@"symbol = %@ AND timestamp >= %@ AND timestamp <= %@", self.currencySymbol, startYesterday, endYesterday]] sortedResultsUsingProperty:@"timestamp" ascending:NO];

    COASymbolValue *yesterdayCloseValue = yesterdayValues.firstObject;
    self.yesterdayValue = yesterdayCloseValue.value;

    double previousValue = self.yesterdayValue;
    double nowValue = [COASymbolValue latestValueForSymbol:self.currencySymbol];
    BOOL rised = previousValue < nowValue;
    self.changeValueLabel.textColor = rised ? [COAConstants greenColor] : [COAConstants fleshColor];
    self.percentValueChangeLabel.textColor = self.changeValueLabel.textColor;

    self.priceValueLabel.text = [NSString stringWithFormat:@"%.4f", [COASymbolValue latestValueForSymbol:self.currencySymbol]];
    self.percentValueChangeLabel.text = [NSString stringWithFormat:@"%.4f %%", nowValue * 100 / previousValue - 100];
    self.changeValueLabel.text = [NSString stringWithFormat:@"%.4f", nowValue - self.yesterdayValue];
    [self setMinMaxLabel];

    UIButton *currentlySelectedButton;

    if (self.minutes30Button.selected) {
        currentlySelectedButton = self.minutes30Button;
    } else if (self.day1Button.selected) {
        currentlySelectedButton = self.day1Button;
    } else if (self.day5Button.selected) {
        currentlySelectedButton = self.day5Button;
    } else if (self.month3Button.selected) {
        currentlySelectedButton = self.month3Button;
    } else if (self.month6Button.selected) {
        currentlySelectedButton = self.month6Button;
    } else if (self.year1Button.selected) {
        currentlySelectedButton = self.year1Button;
    }

    [self filterButtonPressed:currentlySelectedButton];
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
    self.priceValueLabel.textAlignment = NSTextAlignmentRight;
    self.priceValueLabel.textColor = [UIColor whiteColor];
    self.priceValueLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.priceValueLabel];

    _changeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.changeKeyLabel.text = [NSLocalizedString(@"change", @"") uppercaseString];
    self.changeKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.changeKeyLabel];

    _changeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.changeValueLabel.textAlignment = NSTextAlignmentRight;
    self.changeValueLabel.font = self.priceValueLabel.font;
    [self.view addSubview:self.changeValueLabel];

    _percentKeyChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentKeyChangeLabel.text = [NSLocalizedString(@"% change", @"") uppercaseString];
    self.percentKeyChangeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.percentKeyChangeLabel];

    _percentValueChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentValueChangeLabel.textAlignment = NSTextAlignmentRight;
    self.percentValueChangeLabel.font = self.priceValueLabel.font;
    [self.view addSubview:self.percentValueChangeLabel];

    _dayRangeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayRangeKeyLabel.text = [NSLocalizedString(@"day range", @"") uppercaseString];
    self.dayRangeKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.dayRangeKeyLabel];

    _dayRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayRangeValueLabel.textAlignment = NSTextAlignmentRight;
    self.dayRangeValueLabel.textColor = [UIColor whiteColor];
    self.dayRangeValueLabel.font = self.priceValueLabel.font;
    [self.view addSubview:self.dayRangeValueLabel];

    _weeksRangeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weeksRangeKeyLabel.text = [NSLocalizedString(@"52-weeks range", @"") uppercaseString];
    self.weeksRangeKeyLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.weeksRangeKeyLabel];

    _weeksRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weeksRangeValueLabel.textAlignment = NSTextAlignmentRight;
    self.weeksRangeValueLabel.textColor = [UIColor whiteColor];
    self.weeksRangeValueLabel.font = self.priceValueLabel.font;
    self.weeksRangeValueLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.weeksRangeValueLabel];

    _minutes30Button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.minutes30Button setTitle:[NSLocalizedString(@"30 minutes", @"") lowercaseString] forState:UIControlStateNormal];
    [self configureFilterButton:self.minutes30Button];
    [self.view addSubview:self.minutes30Button];

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

    [self updateData];

    [self filterButtonPressed:self.month6Button];

    [self.view setNeedsUpdateConstraints];
}

- (void)setMinMaxLabel {
    NSDate *fromDate = [[[NSDate date] mt_dateYearsBefore:1] mt_startOfCurrentMinute];
    CGFloat min = MAXFLOAT;
    CGFloat max = -MAXFLOAT;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp > %@ AND timestamp < %@ AND symbol = %@", fromDate, [NSDate date], self.currencySymbol];
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    RLMResults *result = [COASymbolValue objectsInRealm:defaultRealm withPredicate:predicate];

    for (COASymbolValue *value in result) {
        min = MIN(value.value, min);
        max = MAX(value.value, max);
    }

    self.weeksRangeValueLabel.text = [NSString stringWithFormat:@"%.4f - %.4f", min, max];

    // today range
    fromDate = [[NSDate date] mt_startOfCurrentDay];
    RLMResults *todayValues = [[COASymbolValue objectsWithPredicate:[NSPredicate predicateWithFormat:@"symbol = %@ AND timestamp >= %@ AND timestamp <= %@", self.currencySymbol, fromDate, [NSDate date]]] sortedResultsUsingProperty:@"timestamp" ascending:YES];
    
    min = MAXFLOAT;
    max = -MAXFLOAT;
    
    for (COASymbolValue *symbolValue in todayValues) {
        min = MIN(min, symbolValue.value);
        max = MAX(max, symbolValue.value);
    }
    
    self.dayRangeValueLabel.text = [NSString stringWithFormat:@"%.4f - %.4f", min, max];
}

- (void)configureFilterButton:(UIButton *)buttonToConfigure {
    [buttonToConfigure.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:9]];
    buttonToConfigure.backgroundColor = [COAConstants darkBlueColor];
    [buttonToConfigure setTitleColor:[COAConstants darkBlueColor] forState:UIControlStateSelected];
    [buttonToConfigure setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [buttonToConfigure addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)filterButtonPressed:(UIButton *)button {
    self.minutes30Button.selected = NO;
    self.day1Button.selected = NO;
    self.day5Button.selected = NO;
    self.month3Button.selected = NO;
    self.month6Button.selected = NO;
    self.year1Button.selected = NO;

    button.selected = YES;
    BOOL minuteScale;
    BOOL hourScale;
    BOOL dayScale;

    NSArray *datesToUse;

    if ([button isEqual:self.minutes30Button]) {
        datesToUse = self.datesToFetch[0];
        self.fromDate = [[NSDate date] mt_dateMinutesBefore:30];
        minuteScale = YES;
        hourScale = NO;
        dayScale = NO;
    } else if ([button isEqual:self.day1Button]) {
        datesToUse = self.datesToFetch[1];
        self.fromDate = [[NSDate date] mt_dateDaysBefore:1];
        minuteScale = NO;
        hourScale = YES;
        dayScale = NO;
    } else if ([button isEqual:self.day5Button]) {
        datesToUse = self.datesToFetch[2];
        self.fromDate = [[NSDate date] mt_dateDaysBefore:5];
        minuteScale = NO;
        hourScale = YES;
        dayScale = NO;
    } else if ([button isEqual:self.month3Button]) {
        datesToUse = self.datesToFetch[3];
        self.fromDate = [[NSDate date] mt_dateMonthsBefore:3];
        minuteScale = NO;
        hourScale = NO;
        dayScale = YES;
    } else if ([button isEqual:self.month6Button]) {
        datesToUse = self.datesToFetch[4];
        self.fromDate = [[NSDate date] mt_dateMonthsBefore:6];
        minuteScale = NO;
        hourScale = NO;
        dayScale = YES;
    } else if ([button isEqual:self.year1Button]) {
        datesToUse = self.datesToFetch[5];
        self.fromDate = [[NSDate date] mt_dateYearsBefore:1];
        minuteScale = NO;
        hourScale = NO;
        dayScale = YES;
    }

    NSArray *values = [self valuesForDates:datesToUse];
    [self updateChartWithValues:values];
}

- (NSArray *)valuesForDates:(NSArray *)datesToUse {
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:datesToUse.count];

    for (NSDate *date in datesToUse) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol = %@ and timestamp = %@", self.currencySymbol, date];
        COASymbolValue *symbolValue = [[COASymbolValue objectsInRealm:[RLMRealm defaultRealm] withPredicate:predicate] firstObject];
        [values addObject:@(symbolValue.value)];
    }

    return values;
}

- (NSDate *)dateFromDate:(NSDate *)date {
    return [date coa_modifiedDate];
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
            @"minutes30Button":self.minutes30Button,
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

    NSUInteger labelRowHeight = 40;
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceKeyLabel(labelRowHeight)]-5-[separator1View(1)]-5-[changeKeyLabel(labelRowHeight)]-5-[separator2View(1)]-5-[percentKeyChangeLabel(labelRowHeight)]-5-[separator3View(1)]-5-[dayRangeKeyLabel(labelRowHeight)]-5-[separator4View(1)]-5-[weeksRangeKeyLabel(labelRowHeight)]-5-[buttonTopLineView(1)]-0-[day1Button(40)]-0-[buttonBottomLineView(1)]-10-[chartView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"labelRowHeight":@(labelRowHeight)} views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceKeyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minutes30Button][day1Button][day5Button][month3Button][month6Button][year1Button]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.day5Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month3Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month6Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year1Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.minutes30Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.day5Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month3Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month6Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year1Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.minutes30Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.day5Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month3Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.month6Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.year1Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.minutes30Button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.day1Button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator2View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator1View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator3View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator4View]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonTopLineView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonBottomLineView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];

    [self.view addConstraints:self.customConstraints];
    [self.chartView setNeedsUpdateConstraints];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:HISTORY_DATA_LOADED];
}


@end
