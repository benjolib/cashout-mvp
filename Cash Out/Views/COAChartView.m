//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAChartView.h"
#import "COAConstants.h"
#import "NSDate+MTDates.h"

@interface COAChartView()

@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *xAxisLabel1;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *xAxisLabel2;
@property (nonatomic, strong) UIView *lineView3;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *xAxisLabel3;
@property (nonatomic, strong) UIView *lineView4;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *xAxisLabel4;
@property (nonatomic, strong) UIView *lineView5;
@property (nonatomic, strong) UILabel *label5;
@property (nonatomic, strong) UILabel *xAxisLabel5;
@property (nonatomic, strong) UIView *lineView6;
@property (nonatomic, strong) UILabel *label6;
@property (nonatomic, strong) UILabel *xAxisLabel6;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) NSArray *values;

@end

@implementation COAChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.backgroundColor = [UIColor clearColor];

        _customConstraints = [[NSMutableArray alloc] init];

        _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
        _label3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineView4 = [[UIView alloc] initWithFrame:CGRectZero];
        _label4 = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel4 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineView5 = [[UIView alloc] initWithFrame:CGRectZero];
        _label5 = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel5 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineView6 = [[UIView alloc] initWithFrame:CGRectZero];
        _label6 = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel6 = [[UILabel alloc] initWithFrame:CGRectZero];

        self.lineView1.backgroundColor = [COAConstants lightBlueColor];
        self.lineView2.backgroundColor = self.lineView1.backgroundColor;
        self.lineView3.backgroundColor = self.lineView1.backgroundColor;
        self.lineView4.backgroundColor = self.lineView1.backgroundColor;
        self.lineView5.backgroundColor = self.lineView1.backgroundColor;
        self.lineView6.backgroundColor = self.lineView1.backgroundColor;

        self.label1.textColor = [UIColor whiteColor];
        self.label2.textColor = self.label1.textColor;
        self.label3.textColor = self.label1.textColor;
        self.label4.textColor = self.label1.textColor;
        self.label5.textColor = self.label1.textColor;
        self.label6.textColor = self.label1.textColor;
        self.xAxisLabel1.textColor = self.label1.textColor;
        self.xAxisLabel2.textColor = self.label1.textColor;
        self.xAxisLabel3.textColor = self.label1.textColor;
        self.xAxisLabel4.textColor = self.label1.textColor;
        self.xAxisLabel5.textColor = self.label1.textColor;
        self.xAxisLabel6.textColor = self.label1.textColor;

        self.label1.font = [UIFont systemFontOfSize:9];
        self.label2.font = self.label1.font;
        self.label3.font = self.label1.font;
        self.label4.font = self.label1.font;
        self.label5.font = self.label1.font;
        self.label6.font = self.label1.font;
        self.xAxisLabel1.font = self.label1.font;
        self.xAxisLabel2.font = self.label1.font;
        self.xAxisLabel3.font = self.label1.font;
        self.xAxisLabel4.font = self.label1.font;
        self.xAxisLabel5.font = self.label1.font;
        self.xAxisLabel6.font = self.label1.font;

        self.label1.textAlignment = NSTextAlignmentRight;
        self.label2.textAlignment = self.label1.textAlignment;
        self.label3.textAlignment = self.label1.textAlignment;
        self.label4.textAlignment = self.label1.textAlignment;
        self.label5.textAlignment = self.label1.textAlignment;
        self.label6.textAlignment = self.label1.textAlignment;
        self.xAxisLabel1.textAlignment = NSTextAlignmentCenter;
        self.xAxisLabel2.textAlignment = self.xAxisLabel1.textAlignment;
        self.xAxisLabel3.textAlignment = self.xAxisLabel1.textAlignment;
        self.xAxisLabel4.textAlignment = self.xAxisLabel1.textAlignment;
        self.xAxisLabel5.textAlignment = self.xAxisLabel1.textAlignment;
        self.xAxisLabel6.textAlignment = self.xAxisLabel1.textAlignment;

        self.label1.text = @"500";
        self.label2.text = @"400";
        self.label3.text = @"300";
        self.label4.text = @"200";
        self.label5.text = @"100";
        self.label6.text = @"0";
        self.xAxisLabel1.text = @"2/18";
        self.xAxisLabel2.text = @"2/20";
        self.xAxisLabel3.text = @"2/22";
        self.xAxisLabel4.text = @"2/24";
        self.xAxisLabel5.text = @"2/26";
        self.xAxisLabel6.text = @"2/28";

        [self addSubview:self.lineView1];
        [self addSubview:self.label1];
        [self addSubview:self.xAxisLabel1];
        [self addSubview:self.lineView2];
        [self addSubview:self.label2];
        [self addSubview:self.xAxisLabel2];
        [self addSubview:self.lineView3];
        [self addSubview:self.label3];
        [self addSubview:self.xAxisLabel3];
        [self addSubview:self.lineView4];
        [self addSubview:self.label4];
        [self addSubview:self.xAxisLabel4];
        [self addSubview:self.lineView5];
        [self addSubview:self.label5];
        [self addSubview:self.xAxisLabel5];
        [self addSubview:self.lineView6];
        [self addSubview:self.label6];
        [self addSubview:self.xAxisLabel6];

        [self updateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{
            @"lineView1":self.lineView1,
            @"lineView2":self.lineView2,
            @"lineView3":self.lineView3,
            @"lineView4":self.lineView4,
            @"lineView5":self.lineView5,
            @"lineView6":self.lineView6,
            @"label1":self.label1,
            @"label2":self.label2,
            @"label3":self.label3,
            @"label4":self.label4,
            @"label5":self.label5,
            @"label6":self.label6,
            @"xAxisLabel1":self.xAxisLabel1,
            @"xAxisLabel2":self.xAxisLabel2,
            @"xAxisLabel3":self.xAxisLabel3,
            @"xAxisLabel4":self.xAxisLabel4,
            @"xAxisLabel5":self.xAxisLabel5,
            @"xAxisLabel6":self.xAxisLabel6
    };

    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[lineView1]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[lineView2]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[lineView3]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[lineView4]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[lineView5]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[lineView6]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.lineView1 attribute:NSLayoutAttributeLeft multiplier:1 constant:-15]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lineView1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.label1 attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lineView2 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label3 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.label1 attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lineView3 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label4 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.label1 attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label4 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lineView4 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label5 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.label1 attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label5 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lineView5 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label6 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.label1 attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label6 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lineView6 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self layoutSubviews];
    CGFloat height = CGRectGetHeight(self.frame);

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:(CGFloat) (height * 0.10)]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:(CGFloat) (height * 0.25)]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:(CGFloat) (height * 0.40)]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:(CGFloat) (height * 0.55)]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:(CGFloat) (height * 0.70)]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:(CGFloat) (height * 0.85)]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView1(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView2(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView3(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView4(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView5(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView6(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lineView6 attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel4 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel5 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel6 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[xAxisLabel1][xAxisLabel2][xAxisLabel3][xAxisLabel4][xAxisLabel5][xAxisLabel6]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.xAxisLabel6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.xAxisLabel1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [self addConstraints:self.customConstraints];
}

- (void)updateChartWithValues:(NSArray *)values fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    self.values = values;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    if ([toDate mt_daysSinceDate:fromDate] > 3) {
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    } else {
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }

    NSInteger secondsBetween = [toDate mt_secondsSinceDate:fromDate];
    NSInteger secondsBetweenDates = secondsBetween / 5;

    self.xAxisLabel1.text = [dateFormatter stringFromDate:fromDate];
    self.xAxisLabel2.text = [dateFormatter stringFromDate:[fromDate mt_dateSecondsAfter:secondsBetweenDates]];
    self.xAxisLabel3.text = [dateFormatter stringFromDate:[fromDate mt_dateSecondsAfter:secondsBetweenDates * 2]];
    self.xAxisLabel4.text = [dateFormatter stringFromDate:[fromDate mt_dateSecondsAfter:secondsBetweenDates * 3]];
    self.xAxisLabel5.text = [dateFormatter stringFromDate:[fromDate mt_dateSecondsAfter:secondsBetweenDates * 4]];
    self.xAxisLabel6.text = [dateFormatter stringFromDate:[fromDate mt_dateSecondsAfter:secondsBetweenDates * 5]];
    
    CGFloat minValue = [self minValue];
    CGFloat maxValue = [self maxValue];
    CGFloat diff = maxValue - minValue;
    CGFloat diffBetweenValues = diff / 5;

    self.label1.text = [NSString stringWithFormat:@"%.2f", minValue + diffBetweenValues * 5];
    self.label2.text = [NSString stringWithFormat:@"%.2f", minValue + diffBetweenValues * 4];
    self.label3.text = [NSString stringWithFormat:@"%.2f", minValue + diffBetweenValues * 3];
    self.label4.text = [NSString stringWithFormat:@"%.2f", minValue + diffBetweenValues * 2];
    self.label5.text = [NSString stringWithFormat:@"%.2f", minValue + diffBetweenValues];
    self.label6.text = [NSString stringWithFormat:@"%.2f", minValue];

    [self setNeedsUpdateConstraints];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    NSUInteger dotSize = 6;

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat chartWidth = width - 40 - dotSize;
    CGFloat chartHeight = height * 0.85;
    NSUInteger numberOfValues = self.values.count;
    CGFloat maxValue = [self maxValue];
    CGFloat minValue = [self minValue];

    NSMutableArray *xValues = [[NSMutableArray alloc] initWithCapacity:numberOfValues];

    // line
    for (NSUInteger index = 0; index < numberOfValues; index++) {
        xValues[index] = @(40 + index * chartWidth / (numberOfValues - 1));

        NSInteger xValue = [xValues[index] integerValue] - 1;
        NSNumber *value = self.values[index];

        NSInteger innerIndex = index - 1;
        while (value.floatValue == 0.0f && innerIndex >= 0) {
            value = self.values[innerIndex];
            innerIndex--;
        }

        NSInteger yValue = (NSInteger) (chartHeight - [self yForValue:value.floatValue chartHeight:chartHeight maxValue:maxValue minValue:minValue]);

        if (index > 0) {
            NSNumber *previousValue = self.values[index - 1];
            NSInteger innerIndex = index - 1;
            while (previousValue.floatValue == 0.0f && innerIndex >= 0) {
                previousValue = self.values[innerIndex];
                innerIndex--;
            }
            
            if (previousValue.floatValue == 0.0f) {
                continue;
            }
            
            NSInteger previousX = [xValues[index - 1] integerValue] - 1;
            NSInteger previousY = (NSInteger) (chartHeight + (dotSize / 2) - [self yForValue:previousValue.floatValue chartHeight:chartHeight maxValue:maxValue minValue:minValue]);

            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(xValue, yValue + dotSize / 2)];
            [bezierPath addLineToPoint: CGPointMake(previousX, previousY)];
            [[COAConstants lightBlueColor] setStroke];
            bezierPath.lineWidth = 1;
            [bezierPath stroke];
        }
    }

    // dot
    for (NSUInteger index = 0; index < numberOfValues; index++) {
        xValues[index] = @(40 + index * chartWidth / (numberOfValues - 1));

        NSInteger xValue = [xValues[index] integerValue] - 4;
        NSNumber *value = self.values[index];

        NSInteger innerIndex = index - 1;
        while (value.floatValue == 0.0f && innerIndex >= 0) {
            value = self.values[innerIndex];
            innerIndex--;
        }

        NSInteger yValue = (NSInteger) (chartHeight - [self yForValue:value.floatValue chartHeight:chartHeight maxValue:maxValue minValue:minValue]);

        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(xValue, yValue, dotSize, dotSize)];
        [[COAConstants greenColor] setFill];
        [ovalPath fill];
    }
}

- (CGFloat)yForValue:(CGFloat)value chartHeight:(CGFloat)chartHeight maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
    CGFloat diff = maxValue - minValue;
    CGFloat pixelPerValue = chartHeight / diff;
    
    return (value - minValue) * pixelPerValue;
}

- (CGFloat)maxValue {
    CGFloat currentMaxValue = -MAXFLOAT;

    for (NSNumber *value in self.values) {
        currentMaxValue = MAX(currentMaxValue, value.floatValue);
    }

    return currentMaxValue;
}

- (CGFloat)minValue {
    CGFloat currentMinValue = MAXFLOAT;

    for (NSNumber *value in self.values) {
        if (value.floatValue > 0) {
            currentMinValue = MIN(currentMinValue, value.floatValue);
        }
    }

    return currentMinValue;
}

@end