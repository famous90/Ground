//
//  AcceptUserJoinViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define MEMBER_PAGE         0
#define PENDING_USER_PAGE   1

#import "MyNewsParentViewController.h"
#import "AcceptUserJoinViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "UserInfo.h"

#import "GroundClient.h"

#import "Util.h"
#import "ViewUtil.h"

@implementation AcceptUserJoinViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.showingUser = [[User alloc] init];
    self.showingUserImage = [[UIImage alloc] init];
}

- (void)viewDidLayoutSubviews
{
    if (self.pageType == PENDING_USER_PAGE) {
        self.title = @"가입허가";
    }else if (self.pageType == MEMBER_PAGE){
        self.title = @"팀원 정보";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
    
    [self decidePageType];
    [self getJoinUserInfo];
}

- (void)decidePageType
{
    self.acceptPendingUserButton.hidden = YES;
    self.rejectPendingUserButton.hidden = YES;
    self.dropOutTeamButton.hidden = YES;
    if(self.pageType == PENDING_USER_PAGE){
        self.acceptPendingUserButton.hidden = NO;
        self.rejectPendingUserButton.hidden = NO;
    }else if((self.pageType == MEMBER_PAGE) && (self.user.userId == self.showingUser.userId)){
        self.dropOutTeamButton.hidden = NO;
    }
}

- (void)getJoinUserInfo
{
    LoadingView *loadingView = [LoadingView startLoading:@"정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getUserInfo:self.showingUser.userId callback:^(BOOL result, NSDictionary *data){
        if(result){
            self.showingUserInfo = [[UserInfo alloc] initUserInfoWithData:[data objectForKey:@"userInfo"]];
            if([self.showingUser.imageUrl isEqual:[NSNull null]]){
                NSLog(@"NO PROFILE IMAGE");
                self.showingUserImage = [UIImage imageNamed:@"profile_noImage"];
            }

            [self configureUserInfoView];
        }else{
            NSLog(@"error to load join user info in accept user join");
            [Util showErrorAlertView:nil message:@"가입 팀원의 정보를 가져오는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

//- (void)getUserImage
//{
//    [[GroundClient getInstance] downloadProfileImage:self.showingUser.imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
//        if(result){
//            self.showingUserImage = [data objectForKey:@"image"];
//            [self configureUserInfoView];
//        }else{
//            NSLog(@"error to load user image in accept user join");
//            [Util showErrorAlertView:nil message:@"사진을 불러오는데 실패했습니다"];
//        }
//    }];
//}

- (void)configureUserInfoView
{
    UserInfo *theUser = self.showingUserInfo;
    self.userImageView.image = self.showingUserImage;
    self.userNameLabel.text = theUser.name;
    NSInteger age = 0;
    if (theUser.birthYear != 0) {
        NSDateComponents *dateComponent = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        age = [dateComponent year] - theUser.birthYear;
    }
    self.userAgeLabel.text = [NSString stringWithFormat:@"%d 세", age];
    self.userMobileLabel.text = theUser.phoneNumber;
    self.userBirthYearLabel.text = [NSString stringWithFormat:@"%d 년", theUser.birthYear];
    self.userPositionLabel.text = [theUser changeIntegerPropertyToStringInPropertyListWithPListName:@"positions" propertyNumber:theUser.position];
    self.userHeightLabel.text = [NSString stringWithFormat:@"%d cm", theUser.height];
    self.userWeightLabel.text = [NSString stringWithFormat:@"%d kg", theUser.weight];
    self.userMainFootLabel.text = [theUser mainFootWithPropertyMainFootNumber:theUser.mainFoot];
    self.userLocationLabel.text = [NSString stringWithFormat:@"%@ %@", theUser.location1, theUser.location2];
    self.userOccupationLabel.text = [theUser changeIntegerPropertyToStringInPropertyListWithPListName:@"occupations" propertyNumber:theUser.occupation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToShowMemberInfo"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 
#pragma mark - IBAction Methods
- (IBAction)acceptPendingMemberButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"수락하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] acceptMember:self.showingUser.userId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"error to accept pending member in accept user join");
            [Util showErrorAlertView:nil message:@"가입 멤버를 수락하는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)rejectPendingMemberButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"거절하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] DenyMember:self.showingUser.userId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"error to accept pending member in accept user join");
            [Util showErrorAlertView:nil message:@"가입 멤버를 거절하는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)dropOurTeamButtonTapped:(id)sender
{
    [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@ 정말 탈퇴하시겠습니까?", self.teamHint.name] title:@"경고"];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LoadingView *loadingView = [LoadingView startLoading:@"로딩중입니다." parentView:self.view];
    
    if(buttonIndex == 0)
    {
        [[GroundClient getInstance] leaveTeam:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data)
         {
             if(result){
                 UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
                 MyNewsParentViewController *childViewController = (MyNewsParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
                 childViewController.user = self.user;
                 
                 [self presentViewController:childViewController animated:YES completion:nil];
             }else{
                 NSLog(@"error to leave team in accept user join");
                 [Util showErrorAlertView:nil message:@"팀나가기를 실패했습니다."];
             }
             
             [loadingView stopLoading];
         }];
    }else{
        [loadingView stopLoading];
    }
}
@end
