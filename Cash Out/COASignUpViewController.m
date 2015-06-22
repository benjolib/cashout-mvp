//
// Created by Stefan Walkner on 22.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <UIImage+ImageWithColor/UIImage+ImageWithColor.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import "COASignUpViewController.h"
#import "COAButton.h"
#import "COAConstants.h"
#import "COAFormatting.h"
#import "COADataFetcher.h"
#import "GAIDictionaryBuilder.h"
#import "Adjust.h"

@interface COASignUpViewController() <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *signUpLabel;
@property (nonatomic, strong) UILabel *getNewCashLabel;
@property (nonatomic, strong) UIImageView *arrowDownImageView;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) COAButton *receiveCashButton;

@end

@implementation COASignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];

    _signUpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.signUpLabel.text = NSLocalizedString(@"sign up", @"").uppercaseString;
    self.signUpLabel.textColor = [COAConstants darkBlueColor];
    self.signUpLabel.textAlignment = NSTextAlignmentCenter;
    self.signUpLabel.font = [COAConstants tradeModeCurrencyProfitLoss];
    [self.scrollView addSubview:self.signUpLabel];

    _getNewCashLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.getNewCashLabel.text = NSLocalizedString(@"get new cash", @"").uppercaseString;
    self.getNewCashLabel.textColor = [COAConstants grayColor];
    self.getNewCashLabel.font = [COAConstants currencyOverviewChartDataCurrencyInBracketsChartView];
    self.getNewCashLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.getNewCashLabel];

    _arrowDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-down"]];
    self.arrowDownImageView.tintColor = [UIColor grayColor];
    [self.scrollView addSubview:self.arrowDownImageView];

    _amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.text = [COAFormatting currencyStringFromValue:100000];
    self.amountLabel.textColor = [COAConstants darkBlueColor];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.font = [COAConstants tradeModeCurrencyProfitLoss];
    [self.scrollView addSubview:self.amountLabel];

    _emailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.textColor = [UIColor whiteColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.emailTextField.leftView = paddingView;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.font = [COAConstants pageHeadlineTutorialBtnText];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.placeholder = NSLocalizedString(@"enter your e-mail", @"").uppercaseString;
    self.emailTextField.backgroundColor = [COAConstants grayColor];
    self.emailTextField.delegate = self;
    [self.scrollView addSubview:self.emailTextField];

    _receiveCashButton = [[COAButton alloc] initWithBorderColor:nil triangleColor:self.emailTextField.backgroundColor outterTriangleColor:nil];
    self.receiveCashButton.backgroundColor = [COAConstants greenColor];
    [self.receiveCashButton addTarget:self action:@selector(sendEmailToServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveCashButton setTitle:NSLocalizedString(@"receive cash", @"").uppercaseString forState:UIControlStateNormal];
    [self.scrollView addSubview:self.receiveCashButton];

    [self addKeyboardNotifications];

    [self.view setNeedsUpdateConstraints];
}

- (void)sendEmailToServer:(id)sender {
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"App" action:@"requestMail" label:self.emailTextField.text value:0] build]];
    ADJEvent *event = [ADJEvent eventWithEventToken:@"a9b0oc"];
    [Adjust trackEvent:event];

    [[COADataFetcher instance] sendMailToServer:self.emailTextField.text completionBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect scrollViewFrame = self.scrollView.frame;
//    CGRect viewFrame = self.view.frame;
//    CGFloat keyboardTopY = CGRectGetMaxY(viewFrame) - CGRectGetHeight(keyboardFrame);
//    CGFloat hiddenScrollViewHeight = CGRectGetMaxY(scrollViewFrame) - keyboardTopY + 10;
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, hiddenScrollViewHeight, 0);
//
//    CGRect responderFrame = self.emailTextField.frame;
//    CGRect rect = self.emailTextField.inputAccessoryView.frame;
//    CGFloat toolbarHeight = CGRectGetHeight(rect);
//
//    if (CGRectGetMinY(keyboardFrame) - toolbarHeight <= CGRectGetMaxY(responderFrame)) {
//        CGPoint scrollPoint = CGPointMake(0, responderFrame.origin.y - (keyboardFrame.size.height - responderFrame.size.height));
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
//    }
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height + 10, 0);
    [self.scrollView setContentOffset:CGPointMake(0, keyboardFrame.size.height + 10) animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{
            @"scrollView":self.scrollView,
            @"signUpLabel":self.signUpLabel,
            @"getNewCashLabel":self.getNewCashLabel,
            @"arrowDownImageView":self.arrowDownImageView,
            @"amountLabel":self.amountLabel,
            @"emailTextField":self.emailTextField,
            @"receiveCashButton":self.receiveCashButton
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.view layoutSubviews];

    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;

    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[signUpLabel(width)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"width":@(width)} views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[getNewCashLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[arrowDownImageView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[amountLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emailTextField]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[receiveCashButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.receiveCashButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:height]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.emailTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.receiveCashButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[signUpLabel]-50-[getNewCashLabel]-10-[arrowDownImageView]-5-[amountLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[receiveCashButton(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailTextField(height)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[receiveCashButton]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height":@(BUTTON_HEIGHT)} views:views]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end