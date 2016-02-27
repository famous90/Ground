//
//  MyMenuViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNewsParentViewController.h"
#import "TeamTabbarParentViewController.h"

@class User;
@class TeamHint;

@interface MyMenuViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

// view
@property (strong, nonatomic) IBOutlet UITableView *myTeamListView;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) UIImage *userImage;

// use slide menu bar button
@property (weak) MyNewsParentViewController *myNewsParentViewController;
@property (weak) TeamTabbarParentViewController *teamTabbarParentViewController;

//- (void)scrollToTopRow;

@end
