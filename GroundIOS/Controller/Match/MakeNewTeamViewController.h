//
//  MakeNewTeamViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import <CoreLocation/CoreLocation.h>
#import "PhotoSelectViewController.h"
#import "MapViewController.h"
#import "GAITrackedViewController.h"

@class User;
@class TeamInfo;

@interface MakeNewTeamViewController : GAITrackedViewController<UITextFieldDelegate, UIActionSheetDelegate, PhotoSelectViewDelegate, MapViewDelegate, CLLocationManagerDelegate>

// view
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UIView *teamMapView;
@property (weak, nonatomic) IBOutlet UITextField *teamLocationTextfield;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamInfo *myTeamInfo;
@property (nonatomic, strong) MTMapView *mapView;
@property (nonatomic, retain) MTMapPOIItem *poiItem;
@property (nonatomic, strong) UIImage *teamImage;

// method
- (IBAction)teamImageViewSelected:(UITapGestureRecognizer *)sender;
- (IBAction)teamLocationSelected:(UITapGestureRecognizer *)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)makeTeamButtonTapped:(id)sender;
- (IBAction)teamNameTextFieldTapped:(id)sender;
- (IBAction)teamNameTextFieldResignResponder:(id)sender;
- (IBAction)teamLocationTextFieldTapped:(id)sender;

@end
