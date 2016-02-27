//
//  MenuParentViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface MyNewsParentViewController : UIViewController

// view
@property (weak, nonatomic) IBOutlet UIView *MyNewsView;
@property (weak, nonatomic) IBOutlet UIView *MenuView;

// data
@property (nonatomic, strong) User *user;

- (BOOL)slide;
- (BOOL)slideBack;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
@end
