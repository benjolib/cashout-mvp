//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"


@interface COAQueryModel : RLMObject

@property (nonatomic) NSInteger count;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSArray *results;

@end