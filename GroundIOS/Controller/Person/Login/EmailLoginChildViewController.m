//
//  EmailLoginChildViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 21..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "EmailLoginChildViewController.h"
#import "MyNewsParentViewController.h"
#import "LoadingView.h"

#import "User.h"

#import "LocalUser.h"
#import "GroundClient.h"
#import "ServerResponseError.h"

#import "Util.h"
#import "StringUtils.h"
#import "ViewUtil.h"
#import "UITextField+Util.h"

@implementation EmailLoginChildViewController{
    BOOL emailTextFieldTapped;
    BOOL passwordTextFieldTapped;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [UITextField setVerticalPaddingWithTextField:self.emailTextField];
    [UITextField setVerticalPaddingWithTextField:self.passwordTextField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    emailTextFieldTapped = NO;
    passwordTextFieldTapped = NO;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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

- (IBAction)emailLoginButtonTapped:(id)sender
{
    if([self isEmailLoginTextFieldAllFilled]){
        LoadingView *loadingView = [LoadingView startLoading:@"로그인 정보를 보내고 있습니다" parentView:self.emailLoginViewController.view];
        
        [[GroundClient getInstance] login:self.email withPw:self.password callback:^(BOOL result, NSDictionary *data){
            if(result){
                NSString* session = [data valueForKey:@"sessionKey"];
                
                if(session != nil){
                    [[LocalUser getInstance] setLoginToken:data];
                    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
                    MyNewsParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
                    [self presentViewController:childViewController animated:YES completion:nil];
                    
                }else{
                    [Util showErrorAlertView:nil message:@"로그인에 문제가 발생했습니다"];
                }
                
            }else{
                NSInteger code = [[data valueForKey:@"code"] integerValue];
                
                if (code == ERROR_EMAIL_NOT_EXIST) {
                    [Util showAlertView:Nil message:@"이메일이 존재하지 않습니다"];
                    
                }else if (code == ERROR_WRONG_PASSWORD){
                    [Util showAlertView:nil message:@"비밀번호가 틀렸습니다"];
                    
                }else{
                    NSLog(@"error to login in email login child");
                    [Util showErrorAlertView:nil message:@"로그인에 문제가 발생했습니다"];
                }
            }
            
            [loadingView stopLoading];
        }];
    }
}

- (IBAction)passwordForgotButtonTapped:(id)sender
{
    
}

- (BOOL)isEmailLoginTextFieldAllFilled
{
    NSString* message = nil;
    
    if([[StringUtils getInstance] IsStringNull:self.emailTextField.text] || [[StringUtils getInstance] stringIsEmpty:self.emailTextField.text]){
        message = @"이메일을 입력해주세요.";
        [self.emailTextField becomeFirstResponder];
        [self emailTextFieldTapped:self.emailTextField];
    }
    else if([[StringUtils getInstance] IsStringNull:self.passwordTextField.text] || [[StringUtils getInstance] stringIsEmpty:self.passwordTextField.text]){
        message = @"비밀번호를 입력해주세요.";
        [self.passwordTextField becomeFirstResponder];
        [self passwordTextFieldTapped:self.passwordTextField];
    }else{
        self.email = self.emailTextField.text;
        self.password = [self encryptPasswordWithPassword:self.passwordTextField.text];
    }
    
    if(message){
        [Util showAlertView:nil message:message title:@"확인"];
        return NO;
    }
    return YES;
}

#pragma mark - Text Field Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *message = nil;
    
    if(textField.tag == 10){
        if([[StringUtils getInstance] IsStringNull:textField.text] || [[StringUtils getInstance] stringIsEmpty:textField.text]){
            message = @"이메일을 입력해주세요.";
            [self.emailTextField becomeFirstResponder];
        }else{
            [self.emailTextField endEditing:YES];
            [self.passwordTextField becomeFirstResponder];
            [self passwordTextFieldTapped:self.passwordTextField];
        }
    }else if(textField.tag == 11){
        if([[StringUtils getInstance] IsStringNull:textField.text] || [[StringUtils getInstance] stringIsEmpty:textField.text]){
            message = @"비밀번호를 입력해주세요.";
            [self.passwordTextField becomeFirstResponder];
        }else{
            [self.passwordTextField endEditing:YES];
            [self emailLoginButtonTapped:self.loginButton];
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
}

#pragma Implementation Methods
- (NSString *)encryptPasswordWithPassword:(NSString *)password
{
    const char *str = [password UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH ; i++){
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

@end
