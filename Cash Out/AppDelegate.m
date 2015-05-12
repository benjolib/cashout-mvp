//
//  AppDelegate.m
//  Cash Out
//
//  Created by Stefan Walkner on 01.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <UIImage+ImageWithColor/UIImage+ImageWithColor.h>
#import "AppDelegate.h"
#import "COStartViewController.h"
#import "COAConstants.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *startNavigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    COStartViewController *startViewController = [[COStartViewController alloc] initWithNibName:nil bundle:nil];
    self.startNavigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];

    self.window.rootViewController = self.startNavigationController;

    [self.startNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.startNavigationController.navigationBar.shadowImage = [UIImage new];
    self.startNavigationController.navigationBar.translucent = NO;
    self.startNavigationController.view.backgroundColor = [UIColor clearColor];
    self.startNavigationController.navigationBar.backgroundColor = [UIColor clearColor];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[COAConstants darkBlueColor]}];

    [self initializeUserDefaults];
    
    [self.window makeKeyAndVisible];

    [Fabric with:@[CrashlyticsKit]];
    return YES;
}

- (void)initializeUserDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
            MONEY_USER_SETTING : @(100000),
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    for (NSString *currencySymbol in [COACurrencies currencies]) {
//        NSDate *dayFromDate = [[COADataHelper instance] toDateDayScaleForSymbol:currencySymbol];
//        NSDate *hourFromDate = [[COADataHelper instance] toDateHourScaleForSymbol:currencySymbol];
//        NSDate *minuteFromDate = [[COADataHelper instance] toDateMinuteScaleForSymbol:currencySymbol];
//
//        [[COADataFetcher instance] fetchHistoricalDataForSymbol:currencySymbol fromDate:dayFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
//            [[COADataFetcher instance] fetchHistoricalDataForSymbol:currencySymbol fromDate:hourFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
//                [[COADataFetcher instance] fetchHistoricalDataForSymbol:currencySymbol fromDate:minuteFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:HISTORY_DATA_LOADED object:nil];
//                }];
//            }];
//        }];
//    }
}

@end
