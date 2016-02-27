//
//  DetailMatchViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 5..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@class User;
@class TeamHint;
@class Match;
@class MatchInfo;

@interface DetailMatchViewController : UIViewController

// view
@property (weak, nonatomic) IBOutlet UIImageView *teamInfoBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myTeamImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *myTeamImageGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *competitorTeamImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *competitorTeamImageGestureRecognizer;
//@property (weak, nonatomic) IBOutlet UIImageView *chattingImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTeamJoinedMembersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorJoinedMembersCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *requestMatchButton;
@property (weak, nonatomic) IBOutlet UIButton *chattingButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptMatchButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectMatchButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelMatchRequestButton;

@property (weak, nonatomic) IBOutlet UILabel *matchDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *matchTimeBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *matchLocationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *matchLocationBgImageView;
@property (weak, nonatomic) IBOutlet UIView *matchLocationMapView;

@property (weak, nonatomic) IBOutlet UIButton *surveyMemberParticipating;
@property (weak, nonatomic) IBOutlet UIButton *joinMatchButton;
@property (weak, nonatomic) IBOutlet UIButton *notJoinMatchButton;

@property (weak, nonatomic) IBOutlet UILabel *matchDescriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *matchDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *matchInfoFirstRowTitleBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *matchInfoBgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *matchInfoSectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *matchDetailInfoSectionImageView;
@property (weak, nonatomic) IBOutlet UIButton *matchInfoTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *matchDetailInfoTitleButton;


// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) TeamHint *competitorTeamHint;
@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) MatchInfo *matchInfo;
@property (nonatomic, strong) UIImage *myTeamImage;
@property (nonatomic, strong) UIImage *competitorTeamImage;
@property (nonatomic, assign) NSInteger pageOriginType;

@property (nonatomic, strong) MTMapView *mapView;
//@property (nonatomic, assign) MTMapPOIItem *poiItem;

- (IBAction)myTeamViewTapped:(UIGestureRecognizer *)sender;
- (IBAction)competitorTeamTapped:(UIGestureRecognizer *)sender;
//- (IBAction)chattingViewTapped:(UIGestureRecognizer *)sender;

- (IBAction)acceptMatchButtonTapped:(id)sender;
- (IBAction)rejectMatchButtonTapped:(id)sender;
- (IBAction)cancelMatchRequestButtonTapped:(id)sender;
- (IBAction)requestMatchButtonTapped:(id)sender;

- (IBAction)matchInfoButtonTapped:(id)sender;
- (IBAction)matchDetailInfoButtonTapped:(id)sender;

- (IBAction)surveyMemberParticipatingButtonTapped:(id)sender;
- (IBAction)joinMatchButtonTapped:(id)sender;
- (IBAction)notJoinMatchButtonTapped:(id)sender;

- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
