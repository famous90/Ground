//
//  EmailLoginViewController.m
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "MyNewsParentViewController.h"
#import "MakeProfileViewController.h"
#import "EmailLoginChildViewController.h"
#import "RegisterChildViewController.h"

#import "User.h"
#import "GroundClient.h"
#import "LocalUser.h"
#import "Util.h"
#import "StringUtils.h"

#define MAX_CANMAKEMYPROFILE    0

@implementation EmailLoginViewController

- (void)viewDidLayoutSubviews
{
    [self setSegmentedControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SelectEmailLogin"]) {
        EmailLoginChildViewController *childViewController = (EmailLoginChildViewController *)[segue destinationViewController];
        childViewController.emailLoginViewController = self;
    }
    if ([[segue identifier] isEqualToString:@"SelectRegister"]) {
        RegisterChildViewController *childViewController = (RegisterChildViewController *)[segue destinationViewController];
        childViewController.emailLoginViewController = self;
    }
    if ([[segue identifier] isEqualToString:@"CancelEmailLogin"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 
#pragma mark - IBAction Methods

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0){
        [self.view bringSubviewToFront:self.EmailLoginView];
        [self.RegisterView endEditing:YES];
        [self setTitle:@"로그인"];

    }else if(sender.selectedSegmentIndex == 1){
        [self.view bringSubviewToFront:self.RegisterView];
        [self.EmailLoginView endEditing:YES];
        [self setTitle:@"선수등록"];
    }
    [self.view bringSubviewToFront:self.loginOrRegisterSelectSegment];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelToShowPolicy"]) {
    }
}

#pragma mark - Implementation Methods
- (void)setSegmentedControl
{
    CGRect frame = self.loginOrRegisterSelectSegment.frame;
    [self.loginOrRegisterSelectSegment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 62)];
    
    UIImage *segmentedControlSelected = [UIImage imageNamed:@"segControl_selected"];
    [self.loginOrRegisterSelectSegment setBackgroundImage:segmentedControlSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    UIImage *segmentedControlUnselected = [UIImage imageNamed:@"segControl_unselected"];
    [self.loginOrRegisterSelectSegment setBackgroundImage:segmentedControlUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *segmentedControlDivider = [UIImage imageNamed:@"segControl_divider_black"];
    [self.loginOrRegisterSelectSegment setDividerImage:segmentedControlDivider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.loginOrRegisterSelectSegment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x12171A), UITextAttributeTextColor, UIFontFixedFontWithSize(16), UITextAttributeFont, nil] forState:UIControlStateSelected];
    
    [self.loginOrRegisterSelectSegment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xdcdbdc), UITextAttributeTextColor, UIFontFixedFontWithSize(16), UITextAttributeFont, nil] forState:UIControlStateNormal];
}

@end
