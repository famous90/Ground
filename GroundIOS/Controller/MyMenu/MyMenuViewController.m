//
//  MyMenuViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define TEAM_ID         0
#define TEAM_NAME       1
#define TEAM_IMAGE_URL  2

#define MY_INFO_SECTION     0
#define MY_TEAM_SECTION     1
#define ADDITIONAL_SECTION  2

#define MY_NAME_ROW 0
#define MY_NEWS_ROW 1

#define SEARCH_TEAM_ROW     0
#define INVITE_USER_ROW     1
#define SETTING_ROW         2

#define ALERT_FOR_LOGOUT    10

#define PADDING 9

#import "MyMenuViewController.h"
#import "TeamTabbarParentViewController.h"
#import "MakeNewTeamViewController.h"
#import "SearchTeamForNewMatchViewController.h"
#import "SettingViewController.h"
#import "LoginSelectViewController.h"
#import "MyNewsParentViewController.h"
#import "MakeProfileViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "TeamHintDataController.h"
#import "ImageDataController.h"

#import "GroundClient.h"
#import "LocalUser.h"

#import "StringUtils.h"
#import "Util.h"
#import "ViewUtil.h"
#import "KakaotalkUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation MyMenuViewController
{
    ImageDataController *teamImageDataController;
    TeamHintDataController *teamHintDataController;
    NSInteger alertType;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.userImage = [[UIImage alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    alertType = 0;
    teamHintDataController = [[TeamHintDataController alloc] init];
    teamImageDataController = [[ImageDataController alloc] init];
    
    [self getMyImage];
    [self getMyTeamList];
}

- (void)getMyImage
{
    if ([self.user.imageUrl isEqual:[NSNull null]]) {
        self.userImage = [UIImage imageNamed:@"profile_noImage"];
        
    }else{
        [[GroundClient getInstance] downloadProfileImage:self.user.imageUrl thumbnail:YES callback:^(BOOL result, NSDictionary *data){
            if (result) {
                self.userImage = [data objectForKey:@"image"];
                [self.tableView reloadData];
            }else{
                NSLog(@"error to load my profile image in my menu");
                self.userImage = [UIImage imageNamed:@"profile_noImage"];
            }
        }];
    }
}

- (void)getMyTeamList
{
    [[GroundClient getInstance] getTeamList:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *teamHintList = [data objectForKey:@"teamList"];
            for(id object in teamHintList){
                TeamHint *theTeam = [[TeamHint alloc] initWithTeamData:object];
                [teamHintDataController addmyTeamsWithTeam:theTeam];
                if (![theTeam.imageUrl isEqual:[NSNull null]]) {
                    [self getTeamImageWithTeamId:theTeam.teamId teamImageUrl:theTeam.imageUrl];
                }
            }
            [self.myTeamListView reloadData];
            
        }else{
            NSLog(@"load my team list error");
            
            NSInteger code = [[data valueForKey:@"code"] integerValue];
            if (code == ERROR_INVALID_SESSTION_KEY) {
                [Util showAlertView:nil message:@"앱이 정상적으로 종료되지 못했습니다\n자동 로그아웃됩니다\n다시 로그인해주시기 바랍니다"];
                alertType = ALERT_FOR_LOGOUT;
            }else{
                [Util showErrorAlertView:nil message:@"나의 팀을 불러오는데 실패했습니다"];
            }
        }
    }];
}

- (void)getTeamImageWithTeamId:(NSInteger)teamId teamImageUrl:(NSString *)imageUrl
{
    [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
        if(result){
            [teamImageDataController addObjectWithImage:[data objectForKey:@"image"] withId:teamId];
            [self.myTeamListView reloadData];
            
        }else{
            NSLog(@"load team image error in team list of my menu");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == MY_INFO_SECTION) {
        return 2;
    }
    if(section == MY_TEAM_SECTION){
        return [teamHintDataController countOfList]+1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == MY_INFO_SECTION) {
        
        // MY NAME ROW
        if (indexPath.row == MY_NAME_ROW) {
            
            static NSString *CellIdentifier = @"MyNameCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UIImageView *userImageView = (UIImageView *)[cell viewWithTag:1100];
            UILabel *userNameLabel = (UILabel *)[cell viewWithTag:1101];
            
            userImageView.image = self.userImage;
            if ([self.user.name isEqual:[NSNull null]]) {
                userNameLabel.text = @"이름없음";
            }else{
                userNameLabel.text = self.user.name;
            }

            // MY NEWS ROW
        }else if (indexPath.row == MY_NEWS_ROW){
            
            static NSString *CellIdentifier = @"MyNewsCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

        }
    }else if(indexPath.section == MY_TEAM_SECTION){
        
        // MAKE NEW TEAM ROW
        if (indexPath.row == [teamHintDataController countOfList]) {
            
            static NSString *CellIdentifier = @"MakeTeamCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
        // TEAM LIST ROW
        }else{
            
            static NSString *CellIdentifier = @"MyTeamsCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if( cell == nil ){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            TeamHint *teamAtIndex = [teamHintDataController objectInListAtIndex:indexPath.row];
            
            UIImageView *teamImageView = (UIImageView *)[cell viewWithTag:100];
            UILabel *teamNameLabel = (UILabel *)[cell viewWithTag:101];
            UIImage *theTeamImage;
            if ([teamImageDataController isIdInListWithId:teamAtIndex.teamId]) {
                theTeamImage = [teamImageDataController imageWithId:teamAtIndex.teamId];
            }else{
                theTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
            }
            teamImageView.image = [ViewUtil circleMaskImageWithImage:theTeamImage];
//            if (theTeamImage) {
//                [teamImageView setContentMode:UIViewContentModeScaleAspectFit];
//                [teamImageView setClipsToBounds:YES];
//            }else{
//                teamImageView.image = [ViewUtil circleMaskImageWithImage:[UIImage imageNamed:@"profile_noImage"]];
//                [teamImageView setContentMode:UIViewContentModeScaleToFill];
//                [teamImageView setClipsToBounds:YES];
//            }
            teamImageView.contentMode = UIViewContentModeScaleAspectFill;
            teamImageView.clipsToBounds = YES;
            teamNameLabel.text = teamAtIndex.name;
            if ((self.teamHint.teamId != 0)&&(teamAtIndex.teamId == self.teamHint.teamId)) {
                [teamNameLabel setTextColor:UIColorFromRGB(0x0e6f49)];
                [teamNameLabel setFont:UIFontHelveticaBoldWithSize(20)];
            }
        }

    }else{
        NSArray *addtionalTableCell = [[NSArray alloc] initWithObjects:@"SearchTeamCell", @"InviteFriendCell", @"SettingCell", nil];
        cell = [tableView dequeueReusableCellWithIdentifier:[addtionalTableCell objectAtIndex:indexPath.row]];
        if(cell == nil) {
            cell = [[ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[addtionalTableCell objectAtIndex:indexPath.row]];
        }
    }
    
    return cell;
}


#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];

//    [_teamTabbarParentViewController slideBack];
//    [_myNewsParentViewController slideBack];
    
    if (indexPath.section == MY_INFO_SECTION) {
        
        // SELECT MY NAME
        if (indexPath.row == MY_NAME_ROW) {
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MakeProfileNavigationController"];
            MakeProfileViewController *childViewController = (MakeProfileViewController *)[navController topViewController];
            childViewController.user = self.user;
            childViewController.pageOriginType = VIEW_FROM_CHANGE_PROFILE;
            
            [self presentViewController:navController animated:YES completion:nil];
            
        // SELECT MY NEWS
        }else if(indexPath.row == MY_NEWS_ROW){
            MyNewsParentViewController *childViewController = (MyNewsParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
            childViewController.user = self.user;
            
            [self presentViewController:childViewController animated:YES completion:nil];
        }
        
    }else if (indexPath.section == MY_TEAM_SECTION) {
        
        // SELECT MAKE NEW TEAM
        if (indexPath.row == [teamHintDataController countOfList]) {
        
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MakeNewTeamNavigationViewController"];
            MakeNewTeamViewController *childViewController = (MakeNewTeamViewController *)[navController topViewController];
            childViewController.user = self.user;

            [self presentViewController:navController animated:YES completion:Nil];

        // SELECT TEAM LIST ROW
        }else{
    
            TeamHint *theTeamHint = [teamHintDataController objectInListAtIndex:indexPath.row];
            TeamTabbarParentViewController *childViewController = (TeamTabbarParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
            childViewController.user = self.user;
            childViewController.teamHint = theTeamHint;
            
            [self presentViewController:childViewController animated:YES completion:nil];

        }
    }else if(indexPath.section == ADDITIONAL_SECTION){
        
        // SELECT SEARCH TEAM ROW
        if (indexPath.row == SEARCH_TEAM_ROW) {
            
//            SearchTeamForNewMatchViewController *childViewController = (SearchTeamForNewMatchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchTeamForNewMatchView"];
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchTeamForNewMatchNavigationController"];
            SearchTeamForNewMatchViewController *childViewController = (SearchTeamForNewMatchViewController *)[navController topViewController];
            childViewController.originType = VIEW_FROM_MENU;
            childViewController.user = self.user;
            
            [self presentViewController:navController animated:YES completion:nil];
        
        // SELECT INVITE USER ROW
        }else if (indexPath.row == INVITE_USER_ROW){
            [self inviteUserThruKakao];
            
        // SELECT SETTING ROW
        }else if (indexPath.row == SETTING_ROW){
            
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingNaviView"];
            SettingViewController *childViewController = (SettingViewController *)[navController topViewController];
            childViewController.user = self.user;
            
            [self presentViewController:navController animated:YES completion:nil];
        
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == MY_INFO_SECTION) {
        return 20;
    }
    if (section == MY_TEAM_SECTION || section == ADDITIONAL_SECTION){
        return 20;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    [headerImageView setImage:[UIImage imageNamed:@"bg_e2e2e2"]];
    [headerImageView setContentMode:UIViewContentModeScaleToFill];
    [headerView addSubview:headerImageView];
    
    UILabel *headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*2, 0, 150, 20)];
    if (section == MY_INFO_SECTION) {
        [headerNameLabel setText:@"내 정보"];
    }else if (section == MY_TEAM_SECTION) {
        [headerNameLabel setText:@"팀"];
    }else{
        [headerNameLabel setText:@"서비스"];
    }
    [headerNameLabel setBackgroundColor:[UIColor clearColor]];
    [headerNameLabel setFont:UIFontHelveticaBoldWithSize(15)];
    [headerNameLabel setTextColor:UIColorFromRGB(0x000000)];
    [headerNameLabel setTextAlignment:NSTextAlignmentLeft];
    [headerView addSubview:headerNameLabel];
    [headerView bringSubviewToFront:headerNameLabel];
    
    return headerView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 5)];
//    
//    return footerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == MY_TEAM_SECTION){
//        return 62;
//    }else{
//        return 45;
//    }
    return 55;
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertType == ALERT_FOR_LOGOUT) {
        if (buttonIndex == 0) {
            [[LocalUser getInstance] logout];
            UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
            LoginSelectViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginSelectView"];
            [self presentViewController:childViewController animated:YES completion:nil];
        }
    }
}

#pragma mark - Implementation
- (void)inviteUserThruKakao
{
    LoadingView *kakaoLoadingView = [LoadingView startLoading:@"잠시만 기다려주세요." parentView:self.view];
    
    // 카카오톡 링크 열 수 있는지 확인
    if([KakaotalkUtil canOpenKakaoLink])
    {
        //GAI - 카카오톡 초대 트래킹
        NSDictionary *campaignParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"invite_friends", kGAICampaignSource,
                                        @"kakaotalk", kGAICampaignMedium,
                                        @"GroundIOS", kGAICampaignName, nil];
        [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] setAll:campaignParams] build]];
        
        NSMutableArray *metaInfoArray = [NSMutableArray array];
        NSDictionary *metaInfoAndroid = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"android", @"os",
                                         @"phone", @"devicetype",
                                         @"market://details?id=com.anb.ground", @"installurl",
                                         [NSString stringWithFormat:@"anbGround://"], @"executeurl",
                                         nil];
        NSDictionary *metaInfoIOS = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ios", @"os",
                                     @"phone", @"devicetype",
                                     @"http://itunes.apple.com/app/768294447", @"installurl",
                                     [NSString stringWithFormat:@"GroundIOS://"], @"executeurl",
                                     nil];
        
        [metaInfoArray addObject:metaInfoAndroid];
        [metaInfoArray addObject:metaInfoIOS];
        
        [KakaotalkUtil openKakaoAppLinkWithMessage:@"Ground에서 함께 뛰어요!"
                                               URL:@"http://link.kakao.com/?test-ios-app"
                                       appBundleID:[[NSBundle mainBundle] bundleIdentifier]
                                        appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                           appName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                     metaInfoArray:metaInfoArray];
    }
    else{
        NSLog(@"error to open kakao link in team main info");
        [kakaoLoadingView stopLoading];
        return;
    }
    
    [kakaoLoadingView stopLoading];
}
@end
