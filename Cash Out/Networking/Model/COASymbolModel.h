//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"

@class COAQueryModel;


@interface COASymbolModel : RLMObject

@property (nonatomic, strong) COAQueryModel *query;

@end