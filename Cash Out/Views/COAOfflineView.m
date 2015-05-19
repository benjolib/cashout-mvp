//
// Created by Stefan Walkner on 15.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAOfflineView.h"
#import "NSString+COAAdditions.h"


@implementation COAOfflineView

- (instancetype)initWithCompletionBlock:(void (^) (BOOL onlyClose))completionBlock {
    self = [super initWithCompletionBlock:completionBlock];
    if (self) {
        NSString *topText = [NSString stringWithFormat:@"%@\n\n%@", NSLocalizedString(@"You appear to be offline!", @""), NSLocalizedString(@"please go online!", @"")].uppercaseString;
        self.topLabel.attributedText = [topText coa_firstLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:30]
        } secondLineAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
        }];
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }

    return self;
}


@end