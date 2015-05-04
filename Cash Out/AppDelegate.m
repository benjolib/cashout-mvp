//
//  AppDelegate.m
//  Cash Out
//
//  Created by Stefan Walkner on 01.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <UIImage+ImageWithColor/UIImage+ImageWithColor.h>
#import <MTDates/NSDate+MTDates.h>
#import "AppDelegate.h"
#import "COStartViewController.h"
#import "COAConstants.h"
#import "COADataFetcher.h"
#import "COACurrencies.h"
#import "COADataHelper.h"

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
    
    [[COADataFetcher instance] initialImport];

    [self.window makeKeyAndVisible];

    return YES;
}

+ (NSString *) applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

- (void)initializeUserDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
            MONEY_USER_SETTING : @(100000),
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    for (NSString *currencySymbol in [COACurrencies currencies]) {
        NSDate *dayFromDate = [[COADataHelper instance] toDateDayScaleForSymbol:currencySymbol];
        NSDate *hourFromDate = [[COADataHelper instance] toDateHourScaleForSymbol:currencySymbol];
        NSDate *minuteFromDate = [[COADataHelper instance] toDateMinuteScaleForSymbol:currencySymbol];

        BOOL loadInBackground = [[NSDate date] mt_daysSinceDate:dayFromDate] < 7;

        if (!loadInBackground) {
            [[COADataFetcher instance] fetchLiveDataForSymbol:currencySymbol fromDate:dayFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
                [[COADataFetcher instance] fetchLiveDataForSymbol:currencySymbol fromDate:hourFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
                    [[COADataFetcher instance] fetchLiveDataForSymbol:currencySymbol fromDate:minuteFromDate toDate:[NSDate date] completionBlock:^(NSString *value) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:HISTORY_DATA_LOADED object:nil];
                    }];
                }];
            }];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
