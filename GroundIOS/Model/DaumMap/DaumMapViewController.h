//
//  DaumMapViewController.h
//  GroundIOS_JET
//
//  Created by Jet on 13. 7. 25..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import <DaumMap/MTMapReverseGeoCoder.h>

@interface DaumMapViewController : UIViewController

@property (nonatomic, retain) MTMapView* mapView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;


@end
