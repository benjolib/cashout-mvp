//
// Created by Stefan Walkner on 13.05.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACountryDeterminator.h"
#import "LUKeychainAccess.h"
#import "COADataFetcher.h"
#import <CoreLocation/CoreLocation.h>

@interface COACountryDeterminator() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation COACountryDeterminator

+ (COACountryDeterminator *)instance {
    static COACountryDeterminator *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];

            if ([[self instance] country].length == 0) {
                _instance.locationManager = [[CLLocationManager alloc] init];
                _instance.geocoder = [[CLGeocoder alloc] init];
                _instance.locationManager.delegate = _instance;
                if ([_instance.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [_instance.locationManager requestWhenInUseAuthorization];
                }
                [_instance.locationManager startUpdatingLocation];
            }
        }
    }

    return _instance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations == nil) {
        return;
    }

    CLLocation *currentLocation = locations[0];
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks == nil)
            return;

        CLPlacemark *currentLocPlacemark = placemarks[0];
        [self setCountry:[currentLocPlacemark ISOcountryCode]];

        [manager stopUpdatingLocation];
    }];
}

- (NSString *)country {
    return [[LUKeychainAccess standardKeychainAccess] stringForKey:@"country"];
}

- (void)setCountry:(NSString *)country {
    [[LUKeychainAccess standardKeychainAccess] setString:country forKey:@"country"];
    [[COADataFetcher instance] createUser];

    if ([COADataFetcher userId] == 0) {
        [[COADataFetcher instance] createUser];
    }
}

@end