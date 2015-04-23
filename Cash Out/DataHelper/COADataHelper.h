//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface COADataHelper : NSObject

+ (COADataHelper *)instance;

- (void)saveMoney:(double)money;

- (double)money;

- (void)setTutorialSeen;

- (BOOL)tutorialSeen;

@end