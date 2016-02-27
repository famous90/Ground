//
//  PressingReplyViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class TeamHint;
@class JoinUserDataController;

@interface PressingReplyViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, strong) JoinUserDataController *noAnswerUserDataController;

- (IBAction)pressReplyButtonTapped:(id)sender;
@end
