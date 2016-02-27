//
//  EditTeamInfoViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import "MapViewController.h"
#import "PhotoSelectViewController.h"
#import "GAITrackedViewController.h"

@class User;
@class TeamHint;
@class TeamInfo;

@interface EditTeamInfoViewController : GAITrackedViewController<UIAlertViewDelegate, MapViewDelegate, PhotoSelectViewDelegate, UIActionSheetDelegate>

// view
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamDetailInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *teamLocationTextField;
@property (weak, nonatomic) IBOutlet UIView *teamLocationMapView;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) TeamInfo *myTeamInfo;
@property (nonatomic, strong) UIImage *teamImage;
@property (nonatomic, strong) MTMapView *mapView;
@property (nonatomic, retain) MTMapPOIItem *poiItem;

- (IBAction)editTeamProfileButtonPressed:(id)sender;
- (IBAction)teamLocationTextFieldTapped:(id)sender;
- (IBAction)teamLocationMapViewTapped:(UITapGestureRecognizer *)sender;
- (IBAction)teamImageViewTapped:(UITapGestureRecognizer *)sender;

@end
