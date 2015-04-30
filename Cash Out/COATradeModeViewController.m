//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COATradeModeViewController.h"
#import "COAConstants.h"
#import "COAButton.h"
#import "NSString+COAAdditions.h"
#import "COACongratsView.h"
#import "RLMRealm.h"
#import "COASymbolValue.h"
#import "RLMResults.h"
#import "COAFormatting.h"
#import "COADataHelper.h"
#import "COACurrencies.h"

#define firstLineFontSize 30
#define secondLineFontSize 16

@interface COATradeModeViewController()

@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) NSMutableArray *overlayCustomConstraints;
@property (nonatomic, strong) UILabel *firstCurrencyLabel;
@property (nonatomic, strong) UILabel *secondCurrencyLabel;
@property (nonatomic, strong) UILabel *priceValueLabel;
@property (nonatomic, strong) UILabel *winLossValueLabel;
@property (nonatomic, strong) UILabel *timeLeftValueLabel;
@property (nonatomic, strong) COAButton *cashOutButton;
@property (nonatomic, strong) COACongratsView *congratsView;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSMutableParagraphStyle *style;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic) double initialValue;
@property (nonatomic) NSInteger winLoss;
@property (nonatomic) NSInteger seconds;
@property (nonatomic) double moneySet;
@property (nonatomic) BOOL betOnRise;

@end

@implementation COATradeModeViewController

- (instancetype)initWithCurrencySymbol:(NSString *)currencySymbol moneySet:(double)moneySet betOnRise:(BOOL)rise {
    self = [super init];
    if (self) {
        self.betOnRise = rise;
        self.currencySymbol = currencySymbol;
        self.moneySet = moneySet;
        self.seconds = 600;
        self.navigationItem.hidesBackButton = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdated) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)timerUpdated {
    self.seconds = MAX(0, self.seconds - 1);

    NSInteger minutes = self.seconds / 60;
    NSInteger seconds = self.seconds % 60;

    NSString *text = [NSString stringWithFormat:@"%02ld:%02ld\n(%@)", (long)minutes, (long)seconds, NSLocalizedString(@"time left", @"").uppercaseString];
    self.timeLeftValueLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLeftValueLabel.attributedText = [text coa_firstLineAttributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:firstLineFontSize],
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSParagraphStyleAttributeName:self.style
    } secondLineAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:secondLineFontSize],
            NSForegroundColorAttributeName:[COAConstants lightBlueColor]
    }];

    [self currencyValueUpdated];

    if (self.seconds == 0) {
        [self gotoCashOut];
        return;
    }
}

- (void)currencyValueUpdated {
    double latestSymbolValue = [COASymbolValue latestValueForSymbol:self.currencySymbol];
    
    self.winLoss = (NSInteger) ((latestSymbolValue - self.initialValue) * _moneySet);

    if (!self.betOnRise) {
        self.winLoss *= -1;
    }

    [self setWinLossValueLabelText:@(self.winLoss)];
    [self setPriceValueLabelText:[NSString stringWithFormat:@"%f", latestSymbolValue]];
    self.priceValueLabel.textColor = self.initialValue > latestSymbolValue ? [COAConstants fleshColor] : [COAConstants greenColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSLocalizedString(@"trade mode", @"") uppercaseString];
    self.view.backgroundColor = [COAConstants darkBlueColor];

    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    RLMResults *results = [[COASymbolValue objectsInRealm:defaultRealm withPredicate:[NSPredicate predicateWithFormat:@"symbol = %@", self.currencySymbol]] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    COASymbolValue *latestSymbolValue = results.firstObject;
    self.initialValue = latestSymbolValue.value;

    _customConstraints = [[NSMutableArray alloc] init];
    _overlayCustomConstraints = [[NSMutableArray alloc] init];

    self.style = [[NSMutableParagraphStyle alloc] init];
    self.style.alignment = NSTextAlignmentCenter;
    [self.style setLineSpacing:4];

    NSString *longCurrencyString = [self longCurrencyString];
    NSArray *strings = [longCurrencyString componentsSeparatedByString:@" / "];
    _firstCurrencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.firstCurrencyLabel.textAlignment = NSTextAlignmentCenter;
    self.firstCurrencyLabel.backgroundColor = [COAConstants darkBlueColor];
    NSString *firstCurrencyText = [strings[0] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    if ([firstCurrencyText rangeOfString:@"\n"].location == NSNotFound) {
        firstCurrencyText = [NSString stringWithFormat:@"\n%@", firstCurrencyText];
    }

    self.firstCurrencyLabel.attributedText = [firstCurrencyText coa_firstLineAttributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:firstLineFontSize],
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSParagraphStyleAttributeName:self.style
    } secondLineAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:secondLineFontSize],
            NSForegroundColorAttributeName:[COAConstants lightBlueColor]
    }];
    self.firstCurrencyLabel.numberOfLines = 2;
    [self.view addSubview:self.firstCurrencyLabel];

    _secondCurrencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.secondCurrencyLabel.textAlignment = NSTextAlignmentCenter;
    self.secondCurrencyLabel.backgroundColor = [COAConstants darkBlueColor];
    NSString *secondCurrencyText = [strings[1] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    if ([secondCurrencyText rangeOfString:@"\n"].location == NSNotFound) {
        secondCurrencyText = [NSString stringWithFormat:@"\n%@", secondCurrencyText];
    }
    self.secondCurrencyLabel.attributedText = [secondCurrencyText coa_firstLineAttributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:firstLineFontSize],
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSParagraphStyleAttributeName:self.style
    } secondLineAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:secondLineFontSize],
            NSForegroundColorAttributeName:[COAConstants lightBlueColor]
    }];
    self.secondCurrencyLabel.numberOfLines = 2;
    [self.view addSubview:self.secondCurrencyLabel];

    _priceValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *priceText = [NSString stringWithFormat:@"%f\n(%@)", self.initialValue, NSLocalizedString(@"price live", @"").uppercaseString];
    [self setPriceValueLabelText:priceText];
    self.priceValueLabel.backgroundColor = [COAConstants darkBlueColor];
    self.priceValueLabel.numberOfLines = 2;
    [self addBorderToView:self.priceValueLabel];
    [self.view addSubview:self.priceValueLabel];

    _winLossValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self setWinLossValueLabelText:@(0)];
    self.winLossValueLabel.backgroundColor = [COAConstants darkBlueColor];
    self.winLossValueLabel.numberOfLines = 2;
    [self addBorderToView:self.winLossValueLabel];
    [self.view addSubview:self.winLossValueLabel];

    _timeLeftValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLeftValueLabel.backgroundColor = [COAConstants darkBlueColor];
    self.timeLeftValueLabel.numberOfLines = 2;
    [self.view addSubview:self.timeLeftValueLabel];

    _cashOutButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:[COAConstants darkBlueColor] outterTriangleColor:nil];
    [self.cashOutButton setTitle:[NSLocalizedString(@"cash out", @"") uppercaseString] forState:UIControlStateNormal];
    [self.cashOutButton addTarget:self action:@selector(gotoCashOut) forControlEvents:UIControlEventTouchUpInside];
    self.cashOutButton.backgroundColor = [COAConstants greenColor];
    [self.view addSubview:self.cashOutButton];

    _separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.separatorView];

    [self.view setNeedsUpdateConstraints];
}

- (NSString *)longCurrencyString {
    NSInteger index = [[COACurrencies currencies] indexOfObject:self.currencySymbol];
    return [COACurrencies currencyDisplayStrings][(NSUInteger) index];
}

- (void)setWinLossValueLabelText:(NSNumber *)number {
    NSString *winLoss = number.doubleValue >= 0 ? NSLocalizedString(@"win", @"") : NSLocalizedString(@"loss", @"");
    NSString *winLossText = [NSString stringWithFormat:@"%@\n(%@ %@)", [COAFormatting currencyStringFromValue:number.doubleValue], winLoss, NSLocalizedString(@"live", @"")];
    self.winLossValueLabel.textAlignment = NSTextAlignmentCenter;
    self.winLossValueLabel.attributedText = [winLossText.uppercaseString coa_firstLineAttributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:firstLineFontSize],
            NSForegroundColorAttributeName:self.winLoss >= 0 ? [COAConstants greenColor] : [COAConstants fleshColor],
            NSParagraphStyleAttributeName:self.style
    } secondLineAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:secondLineFontSize],
            NSForegroundColorAttributeName:[COAConstants lightBlueColor]
    }];
}

- (void)setPriceValueLabelText:(NSString *)text {
    NSString *priceText = [NSString stringWithFormat:@"%@\n(%@)", text, NSLocalizedString(@"price live", @"").uppercaseString];
    self.priceValueLabel.textAlignment = NSTextAlignmentCenter;
    self.priceValueLabel.attributedText = [priceText coa_firstLineAttributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:firstLineFontSize],
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSParagraphStyleAttributeName:self.style
    } secondLineAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:secondLineFontSize],
            NSForegroundColorAttributeName:[COAConstants lightBlueColor]
    }];
}

- (void)addBorderToView:(UIView *)viewToAddBorderTo {
    viewToAddBorderTo.layer.borderColor = [COAConstants lightBlueColor].CGColor;
    viewToAddBorderTo.layer.borderWidth = 1;
}

- (void)gotoCashOut {
    [self.timer invalidate];
    double newBalance = [COADataHelper instance].money + self.winLoss;
    [[COADataHelper instance] saveMoney:newBalance];
    self.congratsView = [[COACongratsView alloc] initWithCompletionBlock:^(BOOL onlyClose) {
        if (!onlyClose) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    } winLoss:self.winLoss];
    self.congratsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.congratsView];

    [self.view setNeedsUpdateConstraints];
    self.winLoss = 0;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:@{
            @"firstCurrencyLabel":self.firstCurrencyLabel,
            @"secondCurrencyLabel":self.secondCurrencyLabel,
            @"priceValueLabel":self.priceValueLabel,
            @"winLossValueLabel":self.winLossValueLabel,
            @"timeLeftValueLabel":self.timeLeftValueLabel,
            @"separatorView":self.separatorView,
            @"cashOutButton":self.cashOutButton
    }];

    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];

    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstCurrencyLabel]-[secondCurrencyLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.secondCurrencyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.firstCurrencyLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.secondCurrencyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.firstCurrencyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[priceValueLabel]-(-1)-[winLossValueLabel]-(-1)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.winLossValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.priceValueLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.winLossValueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.priceValueLabel attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.winLossValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.priceValueLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorView(40)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.separatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.firstCurrencyLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.separatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[timeLeftValueLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cashOutButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cashOutButton(buttonHeight)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"buttonHeight":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"buttonHeight":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.cashOutButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstCurrencyLabel(135)]-0-[priceValueLabel(130)]-0-[timeLeftValueLabel]-[cashOutButton]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.firstCurrencyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    if (self.congratsView.superview) {
        [self.overlayCustomConstraints removeAllObjects];
        UIView *viewToAddOverlay = self.view;

        while (viewToAddOverlay.superview) {
            viewToAddOverlay = viewToAddOverlay.superview;
        }

        [viewToAddOverlay addSubview:self.congratsView];

        [viewToAddOverlay removeConstraints:self.overlayCustomConstraints];

        [self.overlayCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"cv":self.congratsView}]];
        [self.overlayCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"cv":self.congratsView}]];
        [viewToAddOverlay addConstraints:self.overlayCustomConstraints];
    }

    [self.view addConstraints:self.customConstraints];
}

@end