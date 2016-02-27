//
//  MapViewController_backup.h
//  GroundIOS_JET
//
//  Created by Jet on 13. 7. 30..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import <DaumMap/MTMapReverseGeoCoder.h>
#import "DaumMapViewController.h"

@class PopUpView;
@class Ground;

//@protocol MapViewDelegate
//- (void)setMapPOI:(MTMapPOIItem*)poiItem;
//@end

@interface MapViewController_backup : UIViewController<MTMapViewDelegate, MTMapReverseGeoCoderDelegate, UIAlertViewDelegate>

//@property (strong,nonatomic) PopUpView *popUpView;
@property (strong,nonatomic) DaumMapViewController* mapViewController;
@property (strong,nonatomic) MTMapPOIItem* poiItem;
@property (strong,nonatomic) MTMapReverseGeoCoder* reverseGeoCoder;
@property (strong,nonatomic) Ground *ground;
@property (assign,nonatomic) NSInteger registerTag;

- (void)loadDaumMapView:(MTMapPOIItem*)poiItem;
- (void)done;
- (void)cancel;

@end
