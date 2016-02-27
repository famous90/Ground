//
//  RegisterChildViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 21..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "EmailLoginViewController.h"
#import "GAITrackedViewController.h"

@interface RegisterChildViewController : GAITrackedViewController <UITextFieldDelegate, UIAlertViewDelegate>

// view
@property (weak, nonatomic) IBOutlet UIImageView *registerImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordCheckTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *ServicePolicyButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;
@property (weak, nonatomic) IBOutlet UIButton *policyAgreementButton;

// data
@property (weak) EmailLoginViewController *emailLoginViewController;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

- (IBAction)emailTextFieldTapped:(id)sender;
- (IBAction)emailTextFieldResignRespond:(id)sender;
- (IBAction)passwordTextFieldTapped:(id)sender;
- (IBAction)passwordTextFieldResignRespond:(id)sender;
- (IBAction)passwordCheckTextFieldTapped:(id)sender;
- (IBAction)passwordCheckTextFieldResignRespond:(id)sender;

- (IBAction)registerButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

- (IBAction)servicePolicyButtonTapped:(id)sender;
- (IBAction)privacyPolicyButtonTapped:(id)sender;
- (IBAction)policyAgreementButtonTapped:(id)sender;

@end
