//
//  COAMarketClosedView.h
//  Cash Out
//
//  Created by Stefan Walkner on 12.05.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COAMarketClosedView : UIView

- (instancetype)initWithCompletionBlock:(void (^) (BOOL onlyClose))completionBlock;

@end
