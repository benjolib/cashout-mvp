//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COADataFetcher : NSObject

+ (COADataFetcher *)instance;

- (void)fetchDataForSymbol:(NSString *)symbol completionBlock:(void (^)(NSString *value))completionBlock;

- (void)fetchHistoricalDataForSymbol:(NSString *)symbol forDates:(NSArray *)dates completionBlock:(void (^)(void))completionBlock;

- (void)createUserWithCompletionBlock:(void (^)())completionBlock;

- (void)fetchPositionWithCompletionBlock:(void (^)())completionBlock;

- (void)updateBalance;

- (void)sendMailToServer:(NSString *)email completionBlock:(void (^)())completionBlock;

+ (NSInteger)globalPosition;
+ (NSInteger)position;

+ (NSInteger)userId;

+ (NSArray *)datesToFetch;

@end
