//
//  ChatViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class TeamHint;

@interface ChatViewController : UITableViewController<NSStreamDelegate>

// view
@property (strong, nonatomic) IBOutlet UITableView *chattingTableView;
@property (weak, nonatomic) IBOutlet UITextField *chattingMessageTextField;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) TeamHint *competitiveTeamHint;
@property (nonatomic, strong) UIImage *myTeamImage;
@property (nonatomic, strong) UIImage *competitiveTeamImage;
@property (nonatomic, assign) NSInteger matchId;

- (IBAction)chattingMessageSendButtonTapped:(id)sender;

@end
