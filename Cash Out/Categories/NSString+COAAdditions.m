//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "NSString+COAAdditions.h"

@implementation NSString (COAAdditions)

- (NSAttributedString *)coa_firstLineAttributes:(NSDictionary *)firstLineAttributes secondLineAttributes:(NSDictionary *)secondLineAttributes {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:@"\n"];

    if (range.location != NSNotFound) {
        [attributedString addAttributes:firstLineAttributes range:NSMakeRange(0, range.location)];
        [attributedString addAttributes:secondLineAttributes range:NSMakeRange(range.location, self.length - range.location)];
    } else {
        [attributedString addAttributes:firstLineAttributes range:NSMakeRange(0, self.length)];
    }

    return attributedString;
}

@end
