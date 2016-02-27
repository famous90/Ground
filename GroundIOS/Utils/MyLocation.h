//
//  MyLocation.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MyLocation : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

- (CLLocation *)getCurrentLocation;

@end
