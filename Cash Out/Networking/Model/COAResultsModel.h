//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"

@class COARowModel;
@class RLMArray;

RLM_ARRAY_TYPE(COARowModel)


@interface COAResultsModel : RLMObject

@property (nonatomic, strong) RLMArray<COARowModel> *row;

@end