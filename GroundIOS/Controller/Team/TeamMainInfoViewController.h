//
//  TeamMainInfoViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamTabbarParentViewController.h"

@class User;
@class TeamHint;
@class TeamInfo;
@class LoadingView;

@interface TeamMainInfoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

// parent View
@property (weak) TeamTabbarParentViewController *teamTabbarParentViewController;

// view
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamInfoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *myMemberCollectionView;
@property (nonatomic, strong) UIView *coverView;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) TeamInfo *teamInfo;
@property (nonatomic, strong) UIImage *teamImage;

// method
- (IBAction)slide:(id)sender;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
- (IBAction)accept:(UIStoryboardSegue *)segue;
- (IBAction)reject:(UIStoryboardSegue *)segue;

@end
