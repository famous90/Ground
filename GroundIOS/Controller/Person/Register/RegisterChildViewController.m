//
//  RegisterChildViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 21..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#import "RegisterChildViewController.h"
#import "MakeProfileViewController.h"
#import "PolicyViewController.h"
#import "LoadingView.h"

#import "User.h"

#import "GroundClient.h"
#import "ServerResponseError.h"
#import "LocalUser.h"

#import "Util.h"
#import "StringUtils.h"
#import "ViewUtil.h"
#import "UITextField+Util.h"

@implementation RegisterChildViewController{
    BOOL emailTextFieldTapped;
    BOOL passwordTextFieldTapped;
    BOOL passwordCheckTextFieldTapped;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [UITextField setVerticalPaddingWithTextField:self.emailTextField];
    [UITextField setVerticalPaddingWithTextField:self.passwordTextField];
    [UITextField setVerticalPaddingWithTextField:self.passwordCheckTextField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
    
    emailTextFieldTapped = NO;
    passwordTextFieldTapped = NO;
    passwordCheckTextFieldTapped = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordCheckTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - IBAction Methods
- (IBAction)emailTextFieldTapped:(id)sender
{
    if (!emailTextFieldTapped) {
        emailTextFieldTapped = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [ViewUtil adjustViewHeightForEditingWithView:self.view toFrame:self.emailTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)emailTextFieldResignRespond:(id)sender
{
    if (emailTextFieldTapped) {
        emailTextFieldTapped = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [ViewUtil adjustViewHeightForEndEdtingWithView:self.view toFrame:self.emailTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)passwordTextFieldTapped:(id)sender
{
    if (!passwordTextFieldTapped) {
        passwordTextFieldTapped = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [ViewUtil adjustViewHeightForEditingWithView:self.view toFrame:self.passwordTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)passwordTextFieldResignRespond:(id)sender
{
    if (passwordTextFieldTapped) {
        passwordTextFieldTapped = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [ViewUtil adjustViewHeightForEndEdtingWithView:self.view toFrame:self.passwordTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)passwordCheckTextFieldTapped:(id)sender
{
    if (!passwordCheckTextFieldTapped) {
        passwordCheckTextFieldTapped = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [ViewUtil adjustViewHeightForEditingWithView:self.view toFrame:self.passwordCheckTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)passwordCheckTextFieldResignRespond:(id)sender
{
    if (passwordCheckTextFieldTapped) {
        passwordCheckTextFieldTapped = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [ViewUtil adjustViewHeightForEndEdtingWithView:self.view toFrame:self.passwordCheckTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)registerButtonTapped:(id)sender
{
    if([self isRegisterTextFieldAllFilled])
    {
        LoadingView *loadingView = [LoadingView startLoading:@"잠시만 기다려주세요." parentView:self.emailLoginViewController.view];
        
        [[GroundClient getInstance] validateEmail:self.email callback:^(BOOL result, NSDictionary *data)
         {
             if(result){
                 UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
                 MakeProfileViewController *childViewController = (MakeProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MakeProfileView"];
                 
                 childViewController.registerEmail = self.email;
                 childViewController.registerPassword = self.password;
                 childViewController.pageOriginType = VIEW_FROM_REGISTER;
                 
                 [self.passwordTextField setText:nil];
                 [self.passwordCheckTextField setText:nil];
                 
                 [self.emailLoginViewController.navigationController pushViewController:childViewController animated:YES];

             }else{
                 
                 NSInteger code = [[data valueForKey:@"code"] integerValue];
                 
                 // ERROR ABOUT DUPLICATED EMAIL
                 if (code == ERROR_DUPLICATED_EMAIL) {
                    [Util showAlertView:nil message:@"이미 존재하는 이메일입니다"];
                    [self.emailLoginViewController.loginOrRegisterSelectSegment setSelectedSegmentIndex:0];

                 // OTHER ERROR
                 }else{
                     NSLog(@"Server Error");
                     [Util showErrorAlertView:nil message:@"회원가입에 실패했습니다"];
                 }
             }
             
             [loadingView stopLoading];
         }];
    }
}

- (BOOL)isRegisterTextFieldAllFilled
{
    NSString* message = nil;
    
    if([[StringUtils getInstance] IsStringNull:self.emailTextField.text] || [[StringUtils getInstance] stringIsEmpty:self.emailTextField.text]){
        message = @"이메일을 입력해주세요.";
        [self.emailTextField becomeFirstResponder];
        [self emailTextFieldTapped:self.emailTextField];
        
    }else if([[StringUtils getInstance] IsStringNull:self.passwordTextField.text] || [[StringUtils getInstance] stringIsEmpty:self.passwordTextField.text]){
        message = @"패스워드를 입력해주세요.";
        [self.passwordTextField becomeFirstResponder];
        [self passwordTextFieldTapped:self.passwordTextField];
        
    }else if([[StringUtils getInstance] IsStringNull:self.passwordCheckTextField.text] || [[StringUtils getInstance] stringIsEmpty:self.passwordCheckTextField.text]){
        message = @"확인 패스워드를 입력해주세요.";
        [self.passwordCheckTextField becomeFirstResponder];
        [self passwordCheckTextFieldTapped:self.passwordCheckTextField];
        
    }else if(![self.passwordTextField.text isEqualToString:self.passwordCheckTextField.text]){
        message = @"비밀번호를 다시 확인해주세요.";
        [self.passwordCheckTextField becomeFirstResponder];
        [self passwordCheckTextFieldTapped:self.passwordCheckTextField];
        
    }else if (!self.policyAgreementButton.isSelected){
        message = @"약관에 동의해주세요";
        
    }else{
        self.email = self.emailTextField.text;
        self.password = [self encryptPasswordWithPassword:self.passwordTextField.text];
        
        return YES;
    }
    
    if(message){
        [Util showAlertView:nil message:message title:@"확인"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *message = nil;
    
    if(textField.tag == 20){
        if([[StringUtils getInstance] IsStringNull:textField.text] || [[StringUtils getInstance] stringIsEmpty:textField.text]){
            message = @"이메일을 입력해주세요";
            [self.emailTextField becomeFirstResponder];
        }else{
            [self.passwordTextField becomeFirstResponder];
            [self passwordTextFieldTapped:self.passwordTextField];
        }
    }else if(textField.tag == 21){
        if([[StringUtils getInstance] IsStringNull:textField.text] || [[StringUtils getInstance] stringIsEmpty:textField.text]){
            message = @"비밀번호를 입력해주세요";
            [self.passwordTextField becomeFirstResponder];
        }else{
            [self.passwordCheckTextField becomeFirstResponder];
            [self passwordCheckTextFieldTapped:self.passwordCheckTextField];
        }
    }else if(textField.tag == 22){
        if([[StringUtils getInstance] IsStringNull:textField.text] || [[StringUtils getInstance] stringIsEmpty:textField.text]){
            message = @"확인 비밀번호를 입력해주세요";
            [self.passwordCheckTextField becomeFirstResponder];
            
        }else if (![self.passwordTextField.text isEqualToString:self.passwordCheckTextField.text]){
            message = @"비밀번호를 확인해주세요";
            [self.passwordCheckTextField becomeFirstResponder];
            
        }else if (!self.policyAgreementButton.isSelected){
            message = @"약관에 동의해주세요";
            
        }else{
            [self.passwordCheckTextField endEditing:YES];
            [self registerButtonTapped:self.registerButton];
        }

    }
    
    if(message){
        [Util showAlertView:nil message:message title:@"확인"];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordCheckTextField resignFirstResponder];
}

- (IBAction)servicePolicyButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    PolicyViewController *childViewController = (PolicyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PolicyView"];
    childViewController.pageType = VIEW_WITH_SERVICE_POLICY;
    childViewController.pageOriginType = VIEW_FROM_REGISTER;
    
    [self.emailLoginViewController.navigationController pushViewController:childViewController animated:YES];
}

- (IBAction)privacyPolicyButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    PolicyViewController *childViewController = (PolicyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PolicyView"];
    childViewController.pageType = VIEW_WITH_PRIVACY_POLICY;
    childViewController.pageOriginType = VIEW_FROM_REGISTER;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (IBAction)policyAgreementButtonTapped:(id)sender
{
    if (self.policyAgreementButton.isSelected) {
        [self.policyAgreementButton setSelected:NO];
        
    }else{
        [self.policyAgreementButton setSelected:YES];
    }
}

#pragma mark - Implementation Methods
- (NSString *)encryptPasswordWithPassword:(NSString *)password
{
    const char *str = [password UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *encryptedPassword = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH ; i++){
        [encryptedPassword appendFormat:@"%02x", result[i]];
    }
    return encryptedPassword;
}

@end
