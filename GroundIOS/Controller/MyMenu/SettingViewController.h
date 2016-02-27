//
//  SettingViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface SettingViewController : UITableViewController

// view
@property (weak, nonatomic) IBOutlet UIButton *editMyInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *pushSettingButton;

// data
@property (nonatomic, strong) User *user;

- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
