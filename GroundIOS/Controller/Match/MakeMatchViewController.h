//
//  MakeMatchViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetDatePicker.h"
#import "AbstractActionSheetPicker.h"
#import "MapViewController.h"
#import "MatchsViewController.h"

@class User;
@class TeamHint;
@class AbstractActionSheetPicker;
@class MatchInfo;
@class Ground;

@interface MakeMatchViewController : UIViewController

// View
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIView *matchLocationView;
@property (weak, nonatomic) IBOutlet UITextField *awayTeamTextField;
@property (weak, nonatomic) IBOutlet UIButton *competitiveTeamNameButton;
@property (weak, nonatomic) IBOutlet UILabel *competitiveTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *matchOpenCheckbox;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (weak) MatchsViewController *matchsViewController;

// Data to show and save
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) MatchInfo *matchInfo;
@property (nonatomic, strong) Ground *ground;
@property (nonatomic, assign) NSInteger competitiveTeamId;
@property (nonatomic, strong) NSDate *selectedTime;
@property (nonatomic, assign) NSTimeInterval selectedStartTime;
@property (nonatomic, assign) NSTimeInterval selectedEndTime;
@property (nonatomic, strong) MTMapView *mapView;
@property (nonatomic, retain) MTMapPOIItem *poiItem;
@property (nonatomic, assign) NSInteger groundTag;

// Picker Methods
- (IBAction)selectedStartTime:(id)sender;
- (IBAction)startTimeButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)selectedEndTime:(id)sender;
- (IBAction)endTimeButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)locationTextFieldTapped:(id)sender;
- (IBAction)desciptionTextViewTapped:(id)sender;
- (IBAction)matchOpenCheckboxSelected:(id)sender;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
