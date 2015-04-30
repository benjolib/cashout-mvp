//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACongratsView.h"
#import "COAButton.h"
#import "COAConstants.h"
#import "NSString+COAAdditions.h"
#import "COAFormatting.h"
#import "COADataHelper.h"

@interface COACongratsView()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) COAButton *button;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic) double winLoss;

@end

@implementation COACongratsView

- (instancetype)initWithCompletionBlock:(void (^) (BOOL onlyClose))completionBlock winLoss:(double)winLoss {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.winLoss = winLoss;
        self.completionBlock = completionBlock;
        self.backgroundColor = [UIColor clearColor];

        _customConstraints = [[NSMutableArray alloc] init];

        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [UIColor darkGrayColor];
        self.backgroundView.alpha = 0.6f;
        [self addSubview:self.backgroundView];

        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.numberOfLines = 3;
        self.topLabel.backgroundColor = self.winLoss >= 0 ? [COAConstants darkBlueColor] : [COAConstants fleshColor];
        self.topLabel.textColor = [UIColor whiteColor];
        NSString *titleString = self.winLoss >= 0 ? NSLocalizedString(@"congrats", @"") : NSLocalizedString(@"bad trade", @"");
        NSString *youWonLostString = self.winLoss >= 0 ? NSLocalizedString(@"you won", @"") : NSLocalizedString(@"you lost", @"");
        NSString *topText = [NSString stringWithFormat:@"%@\n\n%@ %@", titleString, youWonLostString, [COAFormatting currencyStringFromValue:self.winLoss]].uppercaseString;
        self.topLabel.attributedText = [topText coa_firstLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:30]
        } secondLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
        }];
        [self addSubview:self.topLabel];

        _centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.centerLabel.backgroundColor = [UIColor whiteColor];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.numberOfLines = 2;
        NSString *centerText = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"your balance is", @""), [COAFormatting currencyStringFromValue:[COADataHelper instance].money]].uppercaseString;
        self.centerLabel.attributedText = [centerText coa_firstLineAttributes:@{
                NSFontAttributeName:[UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName:[UIColor grayColor]
        } secondLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:50],
                NSForegroundColorAttributeName:[COAConstants darkBlueColor]
        }];
        [self addSubview:self.centerLabel];

        _button = [[COAButton alloc] initWithBorderColor:nil triangleColor:[UIColor whiteColor] outterTriangleColor:nil];
        [self.button setTitle:NSLocalizedString(@"play again", @"").uppercaseString forState:UIControlStateNormal];
        self.button.backgroundColor = [COAConstants greenColor];
        [self.button addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];

        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{
            @"backgroundView" : self.backgroundView,
            @"topLabel" : self.topLabel,
            @"centerLabel" : self.centerLabel,
            @"button" : self.button
    };

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[topLabel]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[centerLabel]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[button]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[topLabel(200)][centerLabel][button(buttonHeight)]-30-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"buttonHeight":@(BUTTON_HEIGHT)} views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self addConstraints:self.customConstraints];
}

- (void)removeSelf:(id)sender {
    [self removeFromSuperview];

    self.completionBlock(NO);
}

@end