//
//  LoginSelectViewController.m
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "LoginSelectViewController.h"
#import "MyNewsParentViewController.h"
#import "MakeProfileViewController.h"
#import "LoadingView.h"

#import "User.h"

#import "LocalUser.h"
#import "GroundClient.h"

#import "FacebookUtil.h"
#import "StringUtils.h"
#import "ViewUtil.h"

@interface LoginSelectViewController ()

@end

@implementation LoginSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // APNS에 디바이스를 등록한다. - Push Notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeSound];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FacebookLoginButtonPressed:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"페이스북으로 로그인중.." parentView:self.view];
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    
    [[FacebookUtil getInstance] openSessionWithCallback:^(BOOL facebookResult, NSDictionary* facebookInfo) {
        
        if(facebookResult){
            
            NSLog(@"facebook name = %@, email = %@, imageUrl = %@", [facebookInfo valueForKey:@"name"], [facebookInfo valueForKey:@"email"], [facebookInfo valueForKey:@"imageUrl"]);
            
            [[GroundClient getInstance] facebookLogin:facebookInfo callback:^(BOOL result, NSDictionary *data) {
                
               if(result){
                   
                   // 페이스북으로 처음 로그인시 등록화면으로..
                   // 아니면 뉴스피드화면으로..
                   if([[data valueForKey:@"firstLogin"] integerValue] != 0){
                       [loadingView stopLoading];
                       
                       UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MakeProfileNavigationController"];
                       MakeProfileViewController *viewController = (MakeProfileViewController *)[navController topViewController];
                       viewController.profile.userId = [[data valueForKey:@"userId"] integerValue];
                       
                       [self presentViewController:viewController animated:YES completion:nil];
                   }else{
                       NSMutableDictionary *loginToken = [[NSMutableDictionary alloc] initWithDictionary:data];
                       [loginToken setValue:[facebookInfo valueForKey:@"name"] forKey:@"name"];
                       [loginToken setValue:[facebookInfo valueForKey:@"imageurl"] forKey:@"imageUrl"];
                       
                       [self receivedFacebookLoginResponse:loginToken];
                       [loadingView stopLoading];
                       
                       UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
                       MyNewsParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
                       
                       [self presentViewController:childViewController animated:YES completion:nil];
                   }
                   
               }
               else{
                   
                   [loadingView stopLoading];
               }
            }];
        }
        else{
            
            NSLog(@"facebook login failed or already logged in with facebook.");
        }
    }];
}

- (void)receivedFacebookLoginResponse:(NSDictionary*)data
{
    self.loginUser = [[User alloc] init];
    self.loginUser.userId = [[data valueForKey:@"userId"] integerValue];
    self.loginUser.name = [data valueForKey:@"name"];
//    self.loginUser.email = [data valueForKey:@"email"];
    self.loginUser.imageUrl = [data valueForKey:@"imageUrl"];
    
    [[LocalUser getInstance] setLoginToken:data];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelEmailLogin"]) {
        
    }
}

@end
