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
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    
    [[COADataFetcher instance] initialImport];

    [self.window makeKeyAndVisible];

    [Fabric with:@[CrashlyticsKit]];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"test");
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
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];

    //
//    //and create new timer with async call:
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //run function methodRunAfterBackground
//        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
//    });
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
    
}

@end
