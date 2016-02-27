//
//  LoginSelectViewController.h
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class User;

@interface LoginSelectViewController : UIViewController<UIAlertViewDelegate>

@property User *loginUser;

- (IBAction)FacebookLoginButtonPressed:(id)sender;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
