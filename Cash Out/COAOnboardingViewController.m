//
//  COAOnboardingViewController.m
//  Cash Out
//
//  Created by Stefan Walkner on 06.05.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAOnboardingViewController.h"
#import "COAButton.h"
#import "COAConstants.h"

@interface COAOnboardingViewController ()

@property (nonatomic, strong) COAButton *continueButton;

@end

@implementation COAOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.continueButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:[UIColor whiteColor] outterTriangleColor:nil];
    [self.continueButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.continueButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.continueButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continueButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:@{@"continueButton":self.continueButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[continueButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"continueButton":self.continueButton}]];
}

@end
