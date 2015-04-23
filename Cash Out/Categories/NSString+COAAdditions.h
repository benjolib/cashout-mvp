//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (COAAdditions)

- (NSAttributedString *)coa_firstLineAttributes:(NSDictionary *)firstLineAttributes secondLineAttributes:(NSDictionary *)secondLineAttributes;

@end