//
//  COAMarketHelper.m
//  Cash Out
//
//  Created by Stefan Walkner on 12.05.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAMarketHelper.h"
#import <NSDate+MTDates.h>

@implementation COAMarketHelper

+ (BOOL)checkIfMarketIsOpen {
    // Freitag 4pm EST - Sonntag 5pm EST

    NSDate *estDate = [NSDate date];
    
    NSInteger weekday = estDate.mt_weekdayOfWeek;
    NSInteger hour = estDate.mt_hourOfDay;
    
    switch (weekday) {
        case 0: // saturday
            return NO;
        case 1: // sunday
            return hour > 21;
        case 2: // monday
            return YES;
        case 3: // tuesday
            return YES;
        case 4: // wednesday
            return YES;
        case 5: // thursay
            return YES;
        case 6: // friday
            return hour < 20;
    }

    return NO;
}

+ (void)scheduleLocalNotificationWhenMarketOpens {

}

@end
