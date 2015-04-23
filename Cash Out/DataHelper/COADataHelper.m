//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COADataHelper.h"
#import "COAConstants.h"


@implementation COADataHelper

+ (COADataHelper *)instance {
    static COADataHelper *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)saveMoney:(double)money {
    [[NSUserDefaults standardUserDefaults] setDouble:money forKey:MONEY_USER_SETTING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)money {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MONEY_USER_SETTING];
}

- (void)setTutorialSeen {
    [[NSUserDefaults standardUserDefaults] setDouble:YES forKey:TUTORIAL_SEEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)tutorialSeen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:TUTORIAL_SEEN];
}


@end