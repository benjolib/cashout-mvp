//
// Created by Stefan Walkner on 12.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COANotificationHelper : NSObject

+ (void)scheduleLocalNotificationWithKey:(NSString *)key onDate:(NSDate *)date message:(NSString *)message;

+ (void)removeAllLocalNotificationsForKey:(NSString *)key;

@end
