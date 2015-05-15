//
// Created by Stefan Walkner on 12.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COANotificationHelper.h"
#import "COAConstants.h"
#import "COADataHelper.h"
#import <UIKit/UIKit.h>
#import <MTDates/NSDate+MTDates.h>


@implementation COANotificationHelper

+ (void)scheduleLocalNotificationWithKey:(NSString *)key onDate:(NSDate *)date message:(NSString *)message {
    [self removeAllLocalNotificationsForKey:key];

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];

    if (localNotif == nil) {
        return;
    }

    localNotif.fireDate = date;
    localNotif.userInfo = @{key:key};
    localNotif.alertBody = message;
    localNotif.alertTitle = @"Cash Out";
    localNotif.soundName = UILocalNotificationDefaultSoundName;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+ (void)removeAllLocalNotificationsForKey:(NSString *)key {
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//    for (int i = 0; i < [eventArray count]; i++) {
//        UILocalNotification *oneEvent = eventArray[i];
//
//        if (oneEvent.userInfo[key] != nil) {
//            [app cancelLocalNotification:oneEvent];
//        }
//    }
}

@end
