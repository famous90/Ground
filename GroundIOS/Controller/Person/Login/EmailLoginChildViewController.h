//
//  EmailLoginChildViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 21..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "EmailLoginViewController.h"
#import "GAITrackedViewController.h"

@class User;

@interface EmailLoginChildViewController : GAITrackedViewController <UITextFieldDelegate, UIAlertViewDelegate>

// view
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

// data
@property (weak) EmailLoginViewController *emailLoginViewController;
@property (nonatomic, strong) User  *user;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

- (IBAction)emailTextFieldTapped:(id)sender;
- (IBAction)emailTextFieldResignRespond:(id)sender;
- (IBAction)passwordTextFieldTapped:(id)sender;
- (IBAction)passwordTextFieldResignRespond:(id)sender;

- (IBAction)emailLoginButtonTapped:(id)sender;
- (IBAction)passwordForgotButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
@end
