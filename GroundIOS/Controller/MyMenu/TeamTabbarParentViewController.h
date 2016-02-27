//
//  TeamTabbarParentViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 1..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PostsViewController.h"
//#import "MatchListParentViewController.h"
//#import "TeamMainInfoViewController.h"

@class User;
@class TeamHint;

@interface TeamTabbarParentViewController : UIViewController

// view
@property (weak, nonatomic) IBOutlet UIView *MenuView;
@property (weak, nonatomic) IBOutlet UIView *TeamTabbarView;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, assign) NSInteger tabbarSelectedIndex;

- (BOOL)slide;
- (BOOL)slideBack;

@end
