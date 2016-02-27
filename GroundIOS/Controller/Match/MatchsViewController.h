//
//  MatchsViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamTabbarParentViewController.h"

@class User;
@class TeamHint;

@interface MatchsViewController : UITableViewController

// view
@property (nonatomic, strong) UIView *coverView;
@property (weak) TeamTabbarParentViewController *teamTabbarParentViewController;
@property (weak, nonatomic) IBOutlet UIButton *completeMatchListButton;
@property (weak, nonatomic) IBOutlet UIButton *makingMatchListButton;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;

- (IBAction)slide:(id)sender;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)matchListSelectButtonTapped:(id)sender;
- (IBAction)makeNewMatchButtonTapped:(id)sender;

@end
