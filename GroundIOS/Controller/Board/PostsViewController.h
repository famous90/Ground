//
//  PostsViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TeamTabbarParentViewController.h"

@class User;
@class TeamHint;
@class TeamPostDataController;
@class ImageDataController;

@interface PostsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

// view
@property (weak) TeamTabbarParentViewController *teamTabbarParentViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myMenuBarButton;
@property (strong, nonatomic) IBOutlet UITableView *teamBoardTableView;
@property (nonatomic, strong) UIView *coverView;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (strong, nonatomic) TeamPostDataController *postDataController;
@property (nonatomic, strong) ImageDataController *postImageDataController;
@property (nonatomic, strong) ImageDataController *userImageDataController;
@property (nonatomic, assign) NSInteger bottomPostId;

- (IBAction)slide:(id)sender;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
