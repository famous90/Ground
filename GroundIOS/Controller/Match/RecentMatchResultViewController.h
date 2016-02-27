//
//  RecentMatchResultViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class TeamHint;
@class Match;

@interface RecentMatchResultViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) TeamHint *competitorTeamHint;
@property (nonatomic, strong) Match *match;

@end
