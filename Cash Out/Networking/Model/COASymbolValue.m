//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Realm/realm/RLMResults.h>
#import <Realm/realm/RLMRealm.h>
#import "COASymbolValue.h"


@implementation COASymbolValue

+ (double)latestValueForSymbol:(NSString *)symbol {
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"symbol = %@", symbol];
    RLMResults *results = [[COASymbolValue objectsInRealm:defaultRealm withPredicate:pred] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    COASymbolValue *symbolValue = results.firstObject;
    return symbolValue.value;
}

@end