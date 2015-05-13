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
#import "COACountryDeterminator.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *startNavigationController;
@property (nonatomic, strong) COACountryDeterminator *countryDeterminator;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

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

    
    [self.window makeKeyAndVisible];

    [Fabric with:@[CrashlyticsKit]];

    UILocalNotification *localNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self application:application didReceiveLocalNotification:localNotification];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_GAME_OVER_NOTIFICATION object:nil];

    if ([notification.userInfo.allKeys containsObject:TRADE_END_NOTIFICATION]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_GAME_OVER_NOTIFICATION object:nil];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_GAME_OVER_NOTIFICATION object:nil];

    if ([notification.userInfo.allKeys containsObject:TRADE_END_NOTIFICATION]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_GAME_OVER_NOTIFICATION object:nil];
    }
    
    completionHandler();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([COADataFetcher userId] == 0) {
        [[COADataFetcher instance] createUser];
    }

    self.countryDeterminator = [COACountryDeterminator instance];
}


- (void)initializeUserDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
            MONEY_USER_SETTING : @(100000),
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

@end
