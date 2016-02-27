//
//  TeamTabbarParentViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 1..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamTabbarParentViewController.h"
#import "MyMenuViewController.h"
#import "PostsViewController.h"
#import "MatchsViewController.h"
#import "SearchMatchResultViewController.h"
#import "TeamMainInfoViewController.h"

#import "User.h"
#import "TeamHint.h"

#import "GroundClient.h"
#import "LocalUser.h"

#import "Util.h"

@interface TeamTabbarParentViewController ()

@end

@implementation TeamTabbarParentViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGSize viewSize = [self.view bounds].size;
    
    if ((viewSize.height < iOSDeviceScreenSize.height) && ([LocalUser getInstance].deviceOSVer >= 7)) {
        CGRect tabbarViewNewFrame = self.TeamTabbarView.frame;
        tabbarViewNewFrame.size.height = self.view.frame.size.height - 20;
        self.TeamTabbarView.frame = tabbarViewNewFrame;
    }
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
    if([[segue identifier] isEqualToString:@"TeamTabbarController"]){
        UITabBarController *tabController = (UITabBarController *)[segue destinationViewController];
        
        UINavigationController *firstChildNavController = (UINavigationController *)[[tabController customizableViewControllers] objectAtIndex:0];
        PostsViewController *firstChildViewController = (PostsViewController *)[firstChildNavController topViewController];
        firstChildViewController.teamTabbarParentViewController = self;
        firstChildViewController.user = self.user;
        firstChildViewController.teamHint = self.teamHint;
        
        UINavigationController *secondChildNavController = (UINavigationController *)[[tabController customizableViewControllers] objectAtIndex:1];
        MatchsViewController *secondChildViewController = (MatchsViewController *)[secondChildNavController topViewController];
        secondChildViewController.teamTabbarParentViewController = self;
        secondChildViewController.user = self.user;
        secondChildViewController.teamHint = self.teamHint;
        
        UINavigationController *thirdChildNavController = (UINavigationController *)[[tabController customizableViewControllers] objectAtIndex:2];
        SearchMatchResultViewController *thirdChildViewController = (SearchMatchResultViewController *)[thirdChildNavController topViewController];
        thirdChildViewController.teamTabbarParentViewController = self;
        thirdChildViewController.user = self.user;
        thirdChildViewController.teamHint = self.teamHint;
        
        UINavigationController *fourthChildNavController = (UINavigationController *)[[tabController customizableViewControllers] objectAtIndex:3];
        TeamMainInfoViewController *fourthChildViewController = (TeamMainInfoViewController *)[fourthChildNavController topViewController];
        fourthChildViewController.teamTabbarParentViewController = self;
        fourthChildViewController.user = self.user;
        fourthChildViewController.teamHint = self.teamHint;
        
        UITabBar *tabBar = tabController.tabBar;
        UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
        UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
        UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
        UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
        
        tabBarItem1.title = @"게시판";
        tabBarItem2.title = @"경기";
        tabBarItem3.title = @"주변경기";
        tabBarItem4.title = @"팀";
        
        tabBarItem1.image = [UIImage imageNamed:@"boardTab_tabIcon_unselected"];
        tabBarItem1.selectedImage = [UIImage imageNamed:@"boardTab_tabIcon_selected"];
        tabBarItem2.image = [UIImage imageNamed:@"matchTab_tabIcon_unselected.png"];
        tabBarItem2.selectedImage = [UIImage imageNamed:@"matchTab_tabIcon_selected.png"];
        tabBarItem3.image = [UIImage imageNamed:@"matchNearbyTab_tabIcon_unselected.png"];
        tabBarItem3.selectedImage = [UIImage imageNamed:@"matchNearbyTab_tabIcon_selected.png"];
        tabBarItem4.image = [UIImage imageNamed:@"teamTab_tabIcon_unselected.png"];
        tabBarItem4.selectedImage = [UIImage imageNamed:@"teamTab_tabIcon_selected.png"];
        
        [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabBar_bg_selected"]];
        [tabBar setBackgroundColor:UIColorFromRGB(0xdef0db)];
        [tabBar setSelectedImageTintColor:UIColorFromRGB(0xf5f5f5)];
        
        if([LocalUser getInstance].deviceOSVer < 7){
            [tabBar setTintColor:UIColorFromRGB(0x000000)];
        }
            
//        [[UITabBar appearance] setBackgroundColor:UIColorFromRGB(0xDEF0DB)];
//        [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xF5F5F5)];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x4E575E), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xF5F5F5), UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
        
        [tabController setSelectedIndex:self.tabbarSelectedIndex];
    }
    if([[segue identifier] isEqualToString:@"MyMenuWithTeam"]){
        MyMenuViewController *childViewController = (MyMenuViewController *)[segue destinationViewController];
        childViewController.teamTabbarParentViewController = self;
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
    }
}

- (BOOL)slide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    CGRect frame = _TeamTabbarView.frame;
    frame.origin.x = _MenuView.frame.size.width;
    _TeamTabbarView.frame = frame;
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)slideBack
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    CGRect frame = _TeamTabbarView.frame;
    frame.origin.x = _MenuView.frame.origin.x;
    _TeamTabbarView.frame = frame;
    
    [UIView commitAnimations];
    
    return NO;
}
@end
