//
// Created by Stefan Walkner on 23.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COATutorialViewController.h"
#import "COAPlayHomeViewController.h"
#import "COADataHelper.h"

@interface COATutorialViewController()

@property (nonatomic, strong) UIView *upperGrayView;
@property (nonatomic, strong) UIView *lowerGrayView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
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

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"upperGrayView" : self.upperGrayView,
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

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[upperGrayView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lowerGrayView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperGrayView(upperHeight)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"upperHeight":@(upperHeight), @"lowerHeight":@(lowerHeight)} views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lowerGrayView(lowerHeight)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"upperHeight":@(upperHeight), @"lowerHeight":@(lowerHeight)} views:views]];

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
