//
//  MyLocation.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MyLocation.h"

@interface MyLocation()
- (void)initailizeDefaultData;
@end

@implementation MyLocation

- (void)initailizeDefaultData
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.currentLocation = [[CLLocation alloc] init];
}

- (id)init
{
    self = [super init];
    if(self){
        [self initailizeDefaultData];
    }
    return self;
}

- (CLLocation *)getCurrentLocation
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    NSLog(@"START SEARCH LOCATION");
    //    NSLog(@"LOCATION IN MYLOCATION UTIL : %f, %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    return self.currentLocation;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"DID FAIL WITH ERROR: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"DID UPDATE LOCATION : %@", [locations lastObject]);
    self.currentLocation = [locations lastObject];
    
    // Stop Location Manager
//    [self.locationManager stopUpdatingLocation];
}

@end
