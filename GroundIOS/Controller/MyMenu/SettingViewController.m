//
//  SettingViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define GENERAL_INFO_SECTION    0
#define USER_INFO_SECTION       1
#define PUSH_SETTING_SECTION    2
#define SYSTEM_SETTING_SECTION  3

#define VERSION_INFO_ROW   0
#define ADVICE_ROW          1

#import "SettingViewController.h"
#import "LoginSelectViewController.h"
#import "MakeProfileViewController.h"
#import "PushSettingViewController.h"
#import "VersionInfoViewController.h"
#import "AdviceViewController.h"
#import "LocalUser.h"
#import "User.h"

#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewDidLayoutSubviews
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelPushSetting"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([[segue identifier] isEqualToString:@"ReturnPushSetting"]) {
    }
    if ([[segue identifier] isEqualToString:@"ReturnAdvice"]) {
    }
    if ([[segue identifier] isEqualToString:@"ReturnVersionInfo"]) {
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - IBAction
- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelMakeProfile"]) {
    }
}

#pragma mark - UI Table View Data Source 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == GENERAL_INFO_SECTION) {
        return 2;
    }else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    NSString *mainTitle = nil;
    NSString *subTitle = nil;
    
    if (indexPath.section == GENERAL_INFO_SECTION) {
        if (indexPath.row == VERSION_INFO_ROW) {
            CellIdentifier = @"VersionInfoCell";
            mainTitle = @"버전정보";
            subTitle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            
        }else if (indexPath.row == ADVICE_ROW){
            CellIdentifier = @"AdviceCell";
            mainTitle = @"도움말";
        }
        
    }else if (indexPath.section == USER_INFO_SECTION){
        CellIdentifier = @"EditMyInfoCell";
        mainTitle = @"내 계정";
        
    }else if (indexPath.section == PUSH_SETTING_SECTION){
        CellIdentifier = @"PushSettingCell";
        mainTitle = @"알림 설정";
        
    }else if (indexPath.section == SYSTEM_SETTING_SECTION){
        CellIdentifier = @"LogoutCell";
        mainTitle = @"로그아웃";
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = mainTitle;
//    [cell.textLabel setFont:UIFontHelveticaBoldWithSize(16)];
    if (indexPath.section == GENERAL_INFO_SECTION && indexPath.row == VERSION_INFO_ROW) {
        cell.detailTextLabel.text = subTitle;
//        [cell.detailTextLabel setFont:UIFontHelveticaBoldWithSize(16)];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - UI Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == GENERAL_INFO_SECTION) {
        if (indexPath.row == VERSION_INFO_ROW) {
            [self showVersionInfo];
            
        }else if (indexPath.row == ADVICE_ROW) {
            [self showAdvice];
            
        }
    }else if (indexPath.section == USER_INFO_SECTION) {
        [self showEditProfile];
        
    }else if (indexPath.section == PUSH_SETTING_SECTION) {
        [self showPushSetting];
        
    }else if (indexPath.section == SYSTEM_SETTING_SECTION){
        [self doLogout];
        
    }
}

#pragma mark - Implementation
- (void)showEditProfile
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    MakeProfileViewController *childViewController = (MakeProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MakeProfileView"];
    childViewController.user = self.user;
    childViewController.pageOriginType = VIEW_FROM_CHANGE_PROFILE;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)doLogout
{
    [[LocalUser getInstance] logout];
    
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    LoginSelectViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginSelectView"];
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (void)showVersionInfo
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    VersionInfoViewController *childViewController = (VersionInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"VersionInfoView"];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)showAdvice
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    AdviceViewController *childViewController = (AdviceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AdviceView"];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)showPushSetting
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    PushSettingViewController *childViewController = (PushSettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PushSettingView"];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
