//
//  MenuParentViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MyNewsParentViewController.h"
#import "MyNewsViewController.h"
#import "MyMenuViewController.h"
#import "User.h"
#import "UserInfo.h"
#import "GroundClient.h"
#import "LocalUser.h"

@interface MyNewsParentViewController ()

@end

@implementation MyNewsParentViewController
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    
    [self.user setUserId:[LocalUser getInstance].userId];
    [self.user setName:[LocalUser getInstance].userName];
    [self.user setImageUrl:[LocalUser getInstance].userImageUrl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = segue.identifier;
    if([segueName isEqualToString:@"MyNews"]){
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MyNewsViewController *childViewController = (MyNewsViewController *)[navController topViewController];
        childViewController.myNewsParentViewController = self;
        childViewController.user = self.user;
    }
    if([segueName isEqualToString:@"MyMenuWithNews"]){
        MyMenuViewController *childViewController = (MyMenuViewController *)[segue destinationViewController];
        childViewController.myNewsParentViewController = self;
        childViewController.user = self.user;
    }
}

- (BOOL) slide{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    CGRect frame = _MyNewsView.frame;
    frame.origin.x = _MenuView.frame.size.width;
    _MyNewsView.frame = frame;
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)slideBack
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    CGRect frame = _MyNewsView.frame;
    frame.origin.x = _MenuView.frame.origin.x;
    _MyNewsView.frame = frame;
    
    [UIView commitAnimations];
    
    return NO;
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"CancelMakeNewTeam"]){
        
    }
}

@end
