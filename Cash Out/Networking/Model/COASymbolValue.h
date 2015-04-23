//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"


@interface COASymbolValue : RLMObject

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic) double value;

+ (double)latestValueForSymbol:(NSString *)symbol;

@end