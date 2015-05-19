//
//  NSDate+COAAdditions.m
//  Cash Out
//
//  Created by Stefan Walkner on 18.05.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "NSDate+COAAdditions.h"
#import "NSDate+MTDates.h"

@implementation NSDate (COAAdditions)

- (NSDate *)coa_modifiedDate {
    if ([self mt_minutesUntilDate:[NSDate date]] < 50) {
        return [self mt_startOfCurrentMinute];
    } else if ([self mt_hoursUntilDate:[NSDate date]] < 100) {
        return [self mt_startOfCurrentHour];
    } else {
        return [self mt_startOfCurrentDay];
    }
}

@end
