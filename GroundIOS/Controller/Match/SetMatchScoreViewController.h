//
//  SetMatchScoreViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "MapViewController.h"
#import "GAITrackedViewController.h"

@class User;
@class TeamHint;
@class Match;
@class MatchInfo;
@class AbstractActionSheetPicker;

@interface SetMatchScoreViewController : GAITrackedViewController

// view
@property (weak, nonatomic) IBOutlet UITextField *myScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *competitorScoreTextField;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *setResultButton;
@property (weak, nonatomic) IBOutlet UIButton *editResultButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptResultButton;
@property (weak, nonatomic) IBOutlet UIButton *editMyResultInputButton;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *matchLocationMapView;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) MatchInfo *matchInfo;
@property (nonatomic, strong) NSArray *number;
@property (nonatomic, assign) NSInteger selectedMyScore;
@property (nonatomic, assign) NSInteger selectedCompetitorScore;

@property (nonatomic, strong) MTMapView *mapView;
//@property (nonatomic, assign) MTMapPOIItem *poiItem;

- (IBAction)selectMyScore:(id)sender;
- (IBAction)myScoreButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)selectAwayScore:(id)sender;
- (IBAction)awayScoreButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)setResultButtonTapped:(id)sender;
- (IBAction)editResultButtonTapped:(id)sender;
- (IBAction)acceptResultButtonTapped:(id)sender;
- (IBAction)editMyResultInputButtonTapped:(id)sender;

@end
