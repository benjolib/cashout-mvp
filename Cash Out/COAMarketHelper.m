//
//  COAMarketHelper.m
//  Cash Out
//
//  Created by Stefan Walkner on 12.05.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COAMarketHelper.h"
#import "COANotificationHelper.h"
#import "COAConstants.h"
#import <NSDate+MTDates.h>

#define IS_DEBUG NO // TODO swalkner

@implementation COAMarketHelper

+ (BOOL)checkIfMarketIsOpen {
    // Freitag 4pm EST - Sonntag 5pm EST

    NSDate *nextClosingDate = [self getNextClosingDate];
    NSDate *nextOpeningDate = [self getNextOpeningDate];
    
    return [nextClosingDate mt_isBefore:nextOpeningDate];
}

+ (NSDate *)getNextClosingDate {
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];

    NSDate *current = [[NSDate date] mt_startOfPreviousHour];

    BOOL isFriday;
    BOOL isClosingTime;
    
    do {
        current = [current mt_startOfNextHour];
        isFriday = [current mt_weekdayOfWeek] == 5;
        isClosingTime = [current mt_hourOfDay] == 16;
    } while (!isFriday || !isClosingTime);
    
    [NSDate mt_setTimeZone:[NSTimeZone localTimeZone]];
    
    return current;
}

+ (NSDate *)getNextOpeningDate {
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    
    NSDate *current = [[NSDate date] mt_startOfPreviousHour];
    
    BOOL isSunday;
    BOOL isOpeningTime;

    do {
        current = [current mt_startOfNextHour];
        
        isSunday = IS_DEBUG ? [[NSDate date] mt_weekdayOfWeek] == [current mt_weekdayOfWeek] : [current mt_weekdayOfWeek] == 7;
        isOpeningTime = IS_DEBUG ? [[NSDate date] mt_hourOfDay] + 1 == [current mt_hourOfDay] : [current mt_hourOfDay] == 17;
    } while (!isSunday || !isOpeningTime);
    
    [NSDate mt_setTimeZone:[NSTimeZone localTimeZone]];
    
    return current;
}

+ (void)scheduleLocalNotificationWhenMarketOpens {
    [COANotificationHelper scheduleLocalNotificationWithKey:MARKET_NOTIFICATION onDate:[self getNextOpeningDate] message:@"markt hat jetzt offen"]; // TODO swalkner
}

@end
