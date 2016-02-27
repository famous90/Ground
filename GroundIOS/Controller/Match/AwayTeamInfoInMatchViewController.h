//
//  AwayTeamInfoInMatchViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "MakeMatchViewController.h"

@class User;
@class TeamHint;
@class TeamInfo;
@class Match;

@interface AwayTeamInfoInMatchViewController : GAITrackedViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

// view
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamMainInfoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *competitorMemberCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *joinTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteTeamButton;
@property (weak) MakeMatchViewController *makeMatchViewController;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, assign) NSInteger competitorTeamId;
@property (nonatomic, strong) TeamInfo *competitorTeamInfo;
@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) UIImage *teamImage;
@property (nonatomic, assign) NSInteger pageoOriginType;

- (IBAction)cancel:(UIStoryboardSegue *)sender;
- (IBAction)joinTeamButtonTapped:(id)sender;
- (IBAction)inviteTeamButtonTapped:(id)sender;

@end
