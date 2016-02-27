//
//  MyNewsViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MyNewsParentViewController.h"

@class FeedDataController;

@interface MyNewsViewController : UITableViewController<UITableViewDataSource,  UITableViewDelegate>

// view
@property (weak) MyNewsParentViewController *myNewsParentViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myMenuBarButton;
@property (nonatomic, strong) UIView *coverView;

// data
@property (nonatomic, strong) User *user;
@property (strong, nonatomic) FeedDataController *newsDataController;
@property (nonatomic, assign) NSInteger lastFeedId;

- (IBAction)slide:(id)sender;

@end
