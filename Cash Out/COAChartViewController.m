//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAChartViewController.h"

@interface COAChartViewController()

@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) UILabel *priceKeyLabel;
@property (nonatomic, strong) UILabel *priceValueLabel;
@property (nonatomic, strong) UILabel *changeKeyLabel;
@property (nonatomic, strong) UIImageView *changeImageView;
@property (nonatomic, strong) UILabel *changeValueLabel;
@property (nonatomic, strong) UILabel *percentKeyChangeLabel;
@property (nonatomic, strong) UIImageView *percentImageView;
@property (nonatomic, strong) UILabel *percentValueChangeLabel;
@property (nonatomic, strong) UILabel *dayRangeKeyLabel;
@property (nonatomic, strong) UILabel *dayRangeValueLabel;
@property (nonatomic, strong) UILabel *weeksRangeKeyLabel;
@property (nonatomic, strong) UILabel *weeksRangeValueLabel;
@property (nonatomic, strong) UISegmentedControl *rangeSegmentedControl;
@property (nonatomic, strong) UIView *chartView;

@end

@implementation COAChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _customConstraints = [[NSMutableArray alloc] init];

    _priceKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceKeyLabel.text = [NSLocalizedString(@"price", @"") uppercaseString];
    [self.view addSubview:self.priceKeyLabel];

    _priceValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceValueLabel.text = @"1.0870";
    self.priceValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.priceValueLabel];

    _changeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.changeKeyLabel.text = [NSLocalizedString(@"change", @"") uppercaseString];
    [self.view addSubview:self.changeKeyLabel];

    _changeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.changeImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.changeImageView];

    _changeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.changeValueLabel.text = @"0.0004";
    self.changeValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.changeValueLabel];

    _percentKeyChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentKeyChangeLabel.text = [NSLocalizedString(@"% change", @"") uppercaseString];
    [self.view addSubview:self.percentKeyChangeLabel];

    _percentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.percentImageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.percentImageView];

    _percentValueChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentValueChangeLabel.text = @"0.0350 %";
    self.percentValueChangeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.percentValueChangeLabel];

    _dayRangeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayRangeKeyLabel.text = [NSLocalizedString(@"day range", @"") uppercaseString];
    [self.view addSubview:self.dayRangeKeyLabel];

    _dayRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayRangeValueLabel.text = @"1.0801 - 1.0896";
    self.dayRangeValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.dayRangeValueLabel];

    _weeksRangeKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weeksRangeKeyLabel.text = [NSLocalizedString(@"52-weeks range", @"") uppercaseString];
    [self.view addSubview:self.weeksRangeKeyLabel];

    _weeksRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weeksRangeValueLabel.text = @"1.0458 - 1.3990";
    self.weeksRangeValueLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.weeksRangeValueLabel];

    _rangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[
            [NSLocalizedString(@"1 day", @"") uppercaseString],
            [NSLocalizedString(@"5 days", @"") uppercaseString],
            [NSLocalizedString(@"3 months", @"") uppercaseString],
            [NSLocalizedString(@"6 months", @"") uppercaseString],
            [NSLocalizedString(@"1 year", @"") uppercaseString],
            [NSLocalizedString(@"2 years", @"") uppercaseString]
    ]];
    [self.view addSubview:self.rangeSegmentedControl];

    _chartView = [[UIView alloc] initWithFrame:CGRectZero];
    self.chartView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.chartView];

    [self.view setNeedsUpdateConstraints];
}

- (NSDictionary *)allViews {
    return @{
            @"priceKeyLabel":self.priceKeyLabel,
            @"priceValueLabel":self.priceValueLabel,
            @"changeKeyLabel":self.changeKeyLabel,
            @"changeImageView":self.changeImageView,
            @"changeValueLabel":self.changeValueLabel,
            @"percentKeyChangeLabel":self.percentKeyChangeLabel,
            @"percentImageView":self.percentImageView,
            @"percentValueChangeLabel":self.percentValueChangeLabel,
            @"dayRangeKeyLabel":self.dayRangeKeyLabel,
            @"dayRangeValueLabel":self.dayRangeValueLabel,
            @"weeksRangeKeyLabel":self.weeksRangeKeyLabel,
            @"weeksRangeValueLabel":self.weeksRangeValueLabel,
            @"rangeSegmentedControl":self.rangeSegmentedControl,
            @"chartView":self.chartView
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

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[changeKeyLabel][changeImageView][changeValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.changeValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.changeKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.changeValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.changeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[changeImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[changeImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.changeImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.changeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[percentKeyChangeLabel][percentImageView][percentValueChangeLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.percentValueChangeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.percentKeyChangeLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.percentValueChangeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.percentKeyChangeLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[percentImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[percentImageView(20)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.percentImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.percentKeyChangeLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[dayRangeKeyLabel][dayRangeValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.dayRangeValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.dayRangeKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.dayRangeValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dayRangeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[weeksRangeKeyLabel][weeksRangeValueLabel]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.weeksRangeValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.weeksRangeKeyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.weeksRangeValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.weeksRangeKeyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[rangeSegmentedControl]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[chartView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceKeyLabel]-10-[changeKeyLabel]-10-[percentKeyChangeLabel]-10-[dayRangeKeyLabel]-10-[weeksRangeKeyLabel]-10-[rangeSegmentedControl]-10-[chartView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:[self allViews]]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.priceKeyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];

    [self.view addConstraints:self.customConstraints];
}

@end
