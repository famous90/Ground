//
//  PushSettingViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define PUSH_POP_SECTION    0
#define PUSH_SOUND_SECTION  1
#define PUSH_VIB_SECTION    2

#define PUSH_STATE_ROW      0
#define PUSH_STATE_SUB_ROW  1
#define PUSH_POP_ROW        2
#define PUSH_POP_SUB_ROW    3

#define PUSH_SOUND_ROW      0
#define PUSH_SOUND_SUB_ROW  1

#define PUSH_VIB_ROW        0
#define PUSH_VIB_SUB_ROW    1

#import "PushSettingViewController.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation PushSettingViewController{
    UIRemoteNotificationType status;
    BOOL pushEnabled;
    BOOL pushPopEnabled;
    BOOL pushSoundEnabled;
    BOOL pushVibrateEnabled;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getPushNotificationStatus];
}

- (void)getPushNotificationStatus
{
    status = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (status == UIRemoteNotificationTypeNone) {
        pushEnabled = NO;
        
    }else{
        pushEnabled = YES;
        
        if ((status & UIRemoteNotificationTypeAlert) == UIRemoteNotificationTypeAlert) {
            pushPopEnabled = YES;
        
        }else pushPopEnabled = NO;
        
        if ((status & UIRemoteNotificationTypeSound) == UIRemoteNotificationTypeSound) {
            pushSoundEnabled = YES;
        
        }else pushSoundEnabled = NO;
    }
    
//    NSLog(@"PUSH %d POP %d SOUND %d", pushEnabled, pushPopEnabled, pushSoundEnabled);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - UI Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == PUSH_POP_SECTION) {
        return 4;
        
    }else if (section == PUSH_SOUND_SECTION){
        return 2;
        
//    }else if (section == PUSH_VIB_SECTION){
//        return 2;
        
    }else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    NSString *mainTitle = nil;
    NSString *subTitle = nil;
    UITableViewCell *cell;
    
    if (indexPath.section == PUSH_POP_SECTION) {
        if (indexPath.row == PUSH_STATE_ROW) {
            CellIdentifier = @"PushStateCell";
            mainTitle = @"푸시알림";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            if (pushEnabled) {
                subTitle = @"켜짐";
            }else{
                subTitle = @"꺼짐";
            }
            [cell.detailTextLabel setText:subTitle];
            
        }else if (indexPath.row == PUSH_STATE_SUB_ROW){
            CellIdentifier = @"PushStateSubCell";
            mainTitle = @"푸시알림 설정은 아이폰>설정>알림에서 확인해주세요";
            [cell.textLabel setFont:UIFontHelveticaWithSize(13)];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.textLabel setFont:UIFontHelveticaWithSize(13)];
            
        }else if (indexPath.row == PUSH_POP_ROW){
            CellIdentifier = @"PopCell";
            mainTitle = @"미리보기";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

                UISwitch *pushPopSettingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                [pushPopSettingSwitch addTarget:self action:@selector(pushPopSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                
                if (pushEnabled && pushPopEnabled) {
                    [pushPopSettingSwitch setOn:YES animated:YES];
                    
                }else{
                    [pushPopSettingSwitch setOn:NO animated:YES];
                    
                }
                
                cell.accessoryView = pushPopSettingSwitch;
            }
            
        }else if (indexPath.row == PUSH_POP_SUB_ROW){
            CellIdentifier = @"PopSubCell";
            mainTitle = @"푸시알림이 왔을 때 메시지의 일부를 보여줍니다.";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.textLabel setFont:UIFontHelveticaWithSize(13)];
        }
        
    }else if (indexPath.section == PUSH_SOUND_SECTION){
        if (indexPath.row == PUSH_SOUND_ROW) {
            CellIdentifier = @"SoundCell";
            mainTitle = @"앱 실행 중 사운드";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                UISwitch *pushSoundSettingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                [pushSoundSettingSwitch addTarget:self action:@selector(pushSoundSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                
                if (pushEnabled && pushSoundEnabled) {
                    [pushSoundSettingSwitch setOn:YES animated:YES];
                }else [pushSoundSettingSwitch setOn:NO animated:YES];
                
                cell.accessoryView = pushSoundSettingSwitch;
            }
            
        }else if (indexPath.row == PUSH_SOUND_SUB_ROW){
            CellIdentifier = @"SoundSubCell";
            mainTitle = @"앱 실행 중 푸시 알람이 왔을 때 사운드를 통해서 알려줍니다";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.textLabel setFont:UIFontHelveticaWithSize(13)];
        }
        
//    }else if (indexPath.section == PUSH_VIB_SECTION){
//        if (indexPath.row == PUSH_VIB_ROW) {
//            CellIdentifier = @"VibCell";
//            mainTitle = @"앱 실행 중 진동";
//            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                
//                UISwitch *pushVibrateSettingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
//                cell.accessoryView = pushVibrateSettingSwitch;
//            }
//            
//        }else if (indexPath.row == PUSH_VIB_SUB_ROW){
//            CellIdentifier = @"VibSubCell";
//            mainTitle = @"앱 실행 중 푸시 알람이 왔을 때 진동을 통해서 알려줍니다";
//            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            [cell.textLabel setFont:UIFontHelveticaWithSize(13)];
//        }
        
    }
    
    [cell.textLabel setNumberOfLines:2];
    cell.textLabel.text = mainTitle;
    
    return cell;
}

- (void)pushPopSwitchChanged:(id)sender
{
    UISwitch *switchControl = sender;
    
    if (pushPopEnabled) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:!(status & UIRemoteNotificationTypeAlert)];
        pushPopEnabled = NO;
        [switchControl setSelected:NO];
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(status | UIRemoteNotificationTypeAlert)];
        pushPopEnabled = YES;
        [switchControl setSelected:YES];
    }
}

- (void)pushSoundSwitchChanged:(id)sender
{
    UISwitch *switchControl = sender;
    
    if (pushSoundEnabled) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:!(status & UIRemoteNotificationTypeSound)];
        pushSoundEnabled = NO;
        [switchControl setSelected:NO];
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(status | UIRemoteNotificationTypeSound)];
        pushSoundEnabled = YES;
        [switchControl setSelected:YES];
    }
}

#pragma mark - UI Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
