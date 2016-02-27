//
//  EditManagerViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class TeamHint;
@class UserDataController;

@interface EditManagerViewController : UITableViewController

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) UserDataController *managerUserList;
@property (nonatomic, strong) UserDataController *normarUserList;

- (IBAction)editManagerButtonTapped:(id)sender;
@end
