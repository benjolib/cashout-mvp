//
// Created by Stefan Walkner on 13.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COACountryDeterminator : NSObject

+ (COACountryDeterminator *)instance;

- (NSString *)country;

@end