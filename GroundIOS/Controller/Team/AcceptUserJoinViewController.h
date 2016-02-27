//
//  AcceptUserJoinViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class User;
@class TeamHint;
@class UserInfo;

@interface AcceptUserJoinViewController : GAITrackedViewController<UIAlertViewDelegate>

// view
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBirthYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *userWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMainFootLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOccupationLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptPendingUserButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectPendingUserButton;
@property (weak, nonatomic) IBOutlet UIButton *dropOutTeamButton;

// data
@property (nonatomic, assign) NSInteger pageType;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) User *showingUser;
@property (nonatomic, strong) UserInfo *showingUserInfo;
@property (nonatomic, strong) UIImage *showingUserImage;

// method
- (IBAction)acceptPendingMemberButtonTapped:(id)sender;
- (IBAction)rejectPendingMemberButtonTapped:(id)sender;
- (IBAction)dropOurTeamButtonTapped:(id)sender;

@end
