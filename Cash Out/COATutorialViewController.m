//
// Created by Stefan Walkner on 23.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COATutorialViewController.h"
#import "COAPlayHomeViewController.h"
#import "COADataHelper.h"
#import "COAConstants.h"

@interface COATutorialViewController()

@property (nonatomic, strong) UIView *upperGrayView;
@property (nonatomic, strong) UIView *lowerGrayView;
@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, assign) COAPlayHomeViewController *playHomeViewController;
@property (nonatomic) NSInteger pageIndex;

@end

@implementation COATutorialViewController

- (instancetype)initWithPlayHomeViewController:(COAPlayHomeViewController *)playHomeViewController {
    self = [super init];
    if (self) {
        self.playHomeViewController = playHomeViewController;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _customConstraints = [[NSMutableArray alloc] init];

    _upperGrayView = [[UIView alloc] initWithFrame:CGRectZero];
    self.upperGrayView.backgroundColor =[UIColor darkGrayColor];
    self.upperGrayView.alpha = 0.85f;
    [self.view addSubview:self.upperGrayView];

    _lowerGrayView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lowerGrayView.backgroundColor = self.upperGrayView.backgroundColor;
    self.lowerGrayView.alpha = self.upperGrayView.alpha;
    [self.view addSubview:self.lowerGrayView];

    _introductionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.introductionLabel.textColor = [UIColor whiteColor];
    self.introductionLabel.textAlignment = NSTextAlignmentCenter;
    self.introductionLabel.font = [COAConstants pageHeadlineTutorialBtnText];
    self.introductionLabel.numberOfLines = 0;
    [self.view addSubview:self.introductionLabel];

    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-down"]];
    [self.view addSubview:self.arrowImageView];

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"upperGrayView" : self.upperGrayView,
            @"introductionLabel" : self.introductionLabel,
            @"arrowImageView" : self.arrowImageView,
            @"lowerGrayView" : self.lowerGrayView
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.view layoutSubviews];
    [self.playHomeViewController.view layoutSubviews];

    CGFloat height = CGRectGetHeight(self.view.frame);

    CGFloat upperHeight = [self upperHeight];
    CGFloat lowerHeight = height - [self lowerHeight];

    switch (self.pageIndex) {
        case 0: {
            self.introductionLabel.text = NSLocalizedString(@"choose the amount of money you want to invest", @"").uppercaseString;
            self.arrowImageView.image = [UIImage imageNamed:@"arrow-up"];
            self.topConstraint = [NSLayoutConstraint constraintWithItem:self.introductionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lowerGrayView attribute:NSLayoutAttributeTop multiplier:1 constant:50];
            [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.introductionLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
            break;
        }
        case 1: {
            self.arrowImageView.image = [UIImage imageNamed:@"arrow-up"];
            self.introductionLabel.text = NSLocalizedString(@"take the right currency pair", @"").uppercaseString;
            self.topConstraint = [NSLayoutConstraint constraintWithItem:self.introductionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lowerGrayView attribute:NSLayoutAttributeTop multiplier:1 constant:50];
            [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.introductionLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
            break;
        }
        case 2: {
            self.arrowImageView.image = [UIImage imageNamed:@"arrow-down"];
            self.introductionLabel.text = NSLocalizedString(@"tap on your estimated exchange rate", @"").uppercaseString;
            self.topConstraint = [NSLayoutConstraint constraintWithItem:self.introductionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.upperGrayView attribute:NSLayoutAttributeBottom multiplier:1 constant:-50];
            [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.introductionLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
            break;
        }
        case 3: {
            self.arrowImageView.image = [UIImage imageNamed:@"arrow-down"];
            self.introductionLabel.text = NSLocalizedString(@"start your real time currency...", @"").uppercaseString;
            self.topConstraint = [NSLayoutConstraint constraintWithItem:self.introductionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.upperGrayView attribute:NSLayoutAttributeBottom multiplier:1 constant:-50];
            [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.introductionLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
            break;
        }
        default: {

        }
    }

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[upperGrayView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[introductionLabel]-50-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lowerGrayView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperGrayView(upperHeight)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"upperHeight":@(upperHeight), @"lowerHeight":@(lowerHeight)} views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lowerGrayView(lowerHeight)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"upperHeight":@(upperHeight), @"lowerHeight":@(lowerHeight)} views:views]];
    [self.customConstraints addObject:self.topConstraint];

    [self.view addConstraints:self.customConstraints];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    self.pageIndex++;

    if (self.pageIndex > 3) {
        [self.view removeFromSuperview];
        [[COADataHelper instance] setTutorialSeen];
    }

    [self.view setNeedsUpdateConstraints];
}

- (CGFloat)upperHeight {
    switch (self.pageIndex) {
        case 0:
            return [self.playHomeViewController lowerNavigationBar];
        case 1:
            return [self.playHomeViewController upperScrollView];
        case 2:
            return [self.playHomeViewController upperRiseButton];
        case 3:
            return [self.playHomeViewController upperPlayButton];
        default:
            return 0;

    }
}

- (CGFloat)lowerHeight {
    switch (self.pageIndex) {
        case 0:
            return [self.playHomeViewController upperScrollView];
        case 1:
            return [self.playHomeViewController lowerScrollView];
        case 2:
            return [self.playHomeViewController lowerRiseButton];
        case 3:
            return [self.playHomeViewController lowerPlayButton];
        default:
            return 0;

    }
}

@end
