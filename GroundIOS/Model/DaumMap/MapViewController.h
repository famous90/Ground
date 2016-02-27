//
//  MapViewController.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 10. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import <DaumMap/MTMapReverseGeoCoder.h>

@class Ground;

@protocol MapViewDelegate
- (void)setMapPOI:(MTMapPOIItem*)poiItem;
@end

@interface MapViewController : UIViewController<MTMapViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) MTMapView* mapView;
@property (strong, nonatomic) MTMapPOIItem* poiItem;
@property (strong, nonatomic) MTMapPoint *currentLocation;

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (strong,nonatomic) Ground *ground;
@property (assign,nonatomic) NSInteger groundTag;

// PopUp View Controller Actions
- (void)doRegisterGround:(NSString*)groundName;

@end
