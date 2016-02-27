//
//  MyTeamInfoInMatchViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class TeamHint;
@class TeamInfo;
@class Match;
@class JoinUserDataController;

@interface MyTeamInfoInMatchViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

// view
@property (weak, nonatomic) IBOutlet UILabel *myTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTeamInfoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *myMemberCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *pressReplyButton;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) TeamInfo *teamInfo;
@property (nonatomic, strong) UIImage *myTeamImage;
@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) JoinUserDataController *memberDataController;

- (IBAction)cancel:(UIStoryboardSegue *)sender;

@end
