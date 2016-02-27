//
//  AwayTeamInfoInMatchViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "AwayTeamInfoInMatchViewController.h"
#import "RecentMatchResultViewController.h"
#import "MyNewsParentViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "JoinUser.h"
#import "TeamHint.h"
#import "TeamInfo.h"
#import "Match.h"
#import "JoinUserDataController.h"
#import "UserDataController.h"
#import "ImageDataController.h"

#import "GroundClient.h"

#import "Util.h"
#import "ViewUtil.h"

@implementation AwayTeamInfoInMatchViewController{
    JoinUserDataController *userDataController;
    UserDataController *teamMemberDataController;
    ImageDataController *userImageDataController;
    
    LoadingView *loadingView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.match = [[Match alloc] init];
    self.teamImage = [[UIImage alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if((self.pageoOriginType == VIEW_FROM_MENU) || (self.pageoOriginType == VIEW_FROM_TEAMURL_INVITE)){
        [self.joinTeamButton setHidden:NO];
    }
    
    if((self.pageoOriginType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM) || (self.pageoOriginType == VIEW_FROM_MAKING_NEW_MATCH)) {
        [self.inviteTeamButton setHidden:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
    
//    if ((self.pageoOriginType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM) || (self.pageoOriginType == VIEW_FROM_MAKING_NEW_MATCH) || (self.pageoOriginType == VIEW_FROM_MENU) || (self.pageoOriginType == VIEW_FROM_TEAMURL_INVITE)) {
//        
//        teamMemberDataController = [[UserDataController alloc] init];
////        [self getTeamMember];
//        [self getTeamInfo];
//        
//    }else if(self.pageoOriginType == VIEW_FROM_DETAIL_MATCH){
//        [self getTeamInfo];
//        
//        userDataController = [[JoinUserDataController alloc] init];
//        userImageDataController = [[ImageDataController alloc] init];
//        [self getAwayTeamJoinedMember];
//        
//    }
    
    [self getTeamInfo];
    
    self.competitorMemberCollectionView.delegate = self;
    self.competitorMemberCollectionView.dataSource = self;
}

- (void)getTeamInfo
{
    [[GroundClient getInstance] getTeamInfo:self.competitorTeamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            TeamInfo *theTeam = [[TeamInfo alloc] initTeamInfoWithData:[data objectForKey:@"teamInfo"]];
            self.competitorTeamInfo = theTeam;
            [self getTeamImage];
            
            if(self.pageoOriginType == VIEW_FROM_DETAIL_MATCH){
                userDataController = [[JoinUserDataController alloc] init];
                userImageDataController = [[ImageDataController alloc] init];
                [self getAwayTeamJoinedMember];
                
            }else if((self.pageoOriginType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM) || (self.pageoOriginType == VIEW_FROM_MAKING_NEW_MATCH) || (self.pageoOriginType == VIEW_FROM_MENU) || (self.pageoOriginType == VIEW_FROM_TEAMURL_INVITE)){
//                teamMemberDataController = [[UserDataController alloc] init];
//                [self getTeamMember];
            }
        }else{
            NSLog(@"error to load team info in my team info in match");
            [Util showErrorAlertView:nil message:@"팀 정보를 가져오는데 실패했습니다"];
        }
    }];
}

- (void)getTeamImage
{
    if (![self.competitorTeamInfo.imageUrl isEqual:[NSNull null]]) {
        [[GroundClient getInstance] downloadProfileImage:self.competitorTeamInfo.imageUrl thumbnail:FALSE callback:^(BOOL result, NSDictionary *data){
            if (result) {
                UIImage *theImage = [data objectForKey:@"image"];
                self.teamImage = theImage;
                
            }else{
                NSLog(@"error to load team image in away team info in match");
                self.teamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
            }
            
            [self configureTeamInfoView];
        }];
        
    }else{
        self.teamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
        [self configureTeamInfoView];
    }
}

- (void)configureTeamInfoView
{
    TeamInfo *theTeamInfo = self.competitorTeamInfo;
//    TeamHint *theTeamHint = self.competitorTeamHint;
    UIImage *theTeamImage = self.teamImage;
    
    self.teamNameLabel.text = theTeamInfo.name;
    self.teamImageView.image = [ViewUtil circleMaskImageWithImage:theTeamImage];
    self.teamMainInfoLabel.text = [NSString stringWithFormat:@"나이:평균%.1f세\n팀원:%d명\n클럽점수:%d점", [theTeamInfo.avgBirth floatValue], theTeamInfo.membersCount, theTeamInfo.score];
}

- (void)getAwayTeamJoinedMember
{
    loadingView = [LoadingView startLoading:@"팀 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] showJoinedMembersList:self.match.matchId teamId:self.competitorTeamId callback:^(BOOL result, NSDictionary *data){
        if (result) {
            NSArray *theMemberArray = [data objectForKey:@"userList"];
            for(id object in theMemberArray){
                JoinUser *theJoinUser = [[JoinUser alloc] initJoinUserWithData:object];
                [userDataController addJoinUserWithJoinUser:theJoinUser];
                if (![theJoinUser.imageUrl isEqual:[NSNull null]]) {
                    [self getMemberImage:theJoinUser.imageUrl MemberId:theJoinUser.userId];
                }
            }
            [self.competitorMemberCollectionView reloadData];
            [loadingView stopLoading];
        }else{
            NSLog(@"error to load members in away team info in match");
            [Util showErrorAlertView:nil message:@"팀원 정보를 가져오는데 실패했습니다"];
            [loadingView stopLoading];
        }
    }];
}

- (void)getTeamMember
{
    loadingView = [LoadingView startLoading:@"팀 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getTeamMembersList:self.competitorTeamId callback:^(BOOL result, NSDictionary *data){
        if (result) {
            NSArray *theMemberArray = [data objectForKey:@"userList"];
            for(id object in theMemberArray){
                User *theUser = [[User alloc] initUserWithData:object];
                [teamMemberDataController addUserWithUser:theUser];
                if (![theUser.imageUrl isEqual:[NSNull null]]) {
                    [self getMemberImage:theUser.imageUrl MemberId:theUser.userId];
                }
            }
            [self.competitorMemberCollectionView reloadData];
            [loadingView stopLoading];
        }else{
            NSLog(@"error to load members in away team info in match");
            [Util showErrorAlertView:nil message:@"팀원 정보를 가져오는데 실패했습니다"];
            [loadingView stopLoading];
        }
    }];
}

- (void)getMemberImage:(NSString *)imageUrl MemberId:(NSInteger)idNumber
{
    [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
        if(result){
            UIImage *theImage = [data objectForKey:@"image"];
            [userImageDataController addObjectWithImage:theImage withId:idNumber];
            [self.competitorMemberCollectionView reloadData];
        }else{
            NSLog(@"error to load member in my team info in match");
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowTeamRecentMatchResult"]){
        RecentMatchResultViewController *childViewController = (RecentMatchResultViewController *)[segue destinationViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
//        childViewController.competitorTeamHint = self.competitorTeamHint;
        childViewController.match = self.match;
    }
    if ([[segue identifier] isEqualToString:@"CancelToShowCompetitiveInfo"]) {
        if (self.pageoOriginType == VIEW_FROM_TEAMURL_INVITE) {
            [self goMyNewsView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)goMyNewsView
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    MyNewsParentViewController *childViewController = (MyNewsParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
    childViewController.user = self.user;

    [self presentViewController:childViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([teamMemberDataController countOfList] > 0)
    {
        return [teamMemberDataController countOfList];
    }else{
        return [userDataController countOfList];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"competitorMemberCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JoinUser *theUser = [userDataController objectInListAtIndex:indexPath.row];
    
    UIImageView *userImageView = (UIImageView *)[cell viewWithTag:496];
    UILabel  *userNameLabel = (UILabel *)[cell viewWithTag:497];
    userNameLabel.text = theUser.name;
    if (theUser.imageUrl != (id)[NSNull null]) {
        userImageView.image = [userImageDataController imageWithId:theUser.userId];
    }else{
        userImageView.image = [UIImage imageNamed:@"profile_noImage"];
    }
    
    return cell;
}

#pragma mark - Collection View Delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"awayMemberHeaderView" forIndexPath:indexPath];
        UIImageView *headerImageView = (UIImageView *)[headerView viewWithTag:498];
        headerImageView.image = [UIImage imageNamed:@"sample_banner.png"];
        UILabel *headerNameLabel = (UILabel *)[headerView viewWithTag:499];
        headerNameLabel.text = @"상대팀 멤버";
        
        reusableView = headerView;
    }
    if(kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"awayMemberFooterView" forIndexPath:indexPath];
        reusableView = footerView;
    }
    return reusableView;
}

#pragma mark - IBAction Methods
- (IBAction)cancel:(UIStoryboardSegue *)sender
{
}

- (IBAction)joinTeamButtonTapped:(id)sender
{
    LoadingView *joinLoadingView = [LoadingView startLoading:@"가입 신청하고 있습니다" parentView:self.view];
    
    if(self.pageoOriginType == VIEW_FROM_MENU){
        [[GroundClient getInstance] joinTeam:self.competitorTeamId callback:^(BOOL result, NSDictionary *data){
            if(result){
                [Util showAlertViewWithTag:self message:[NSString stringWithFormat:@"%@팀에 가입신청 완료!!\n매니저의 응답을 기다리세요^^", self.competitorTeamInfo.name] title:nil tag:VIEW_FROM_MENU];
            }else{
                NSLog(@"Error to join the team in AwayTeamInfoInMatchViewController.");
                [Util showErrorAlertView:nil message:@"팀 가입에 실패하였습니다"];
            }
            
            [joinLoadingView stopLoading];
        }];
    }else if(self.pageoOriginType == VIEW_FROM_TEAMURL_INVITE){
        [[GroundClient getInstance] acceptTeamInvitation:self.competitorTeamId callback:^(BOOL result, NSDictionary *data){
            if(result){
                [Util showAlertViewWithTag:self message:[NSString stringWithFormat:@"축하합니다!!\n%@팀의 팀원이 되셨습니다^^", self.competitorTeamInfo.name] title:nil tag:VIEW_FROM_TEAMURL_INVITE];
            }else{
                NSLog(@"Error to be accepted as a member of the team in AwayTeamInfoInMatchViewController.");
                [Util showErrorAlertView:nil message:@"팀 가입에 실패하였습니다"];
            }
        
            [joinLoadingView stopLoading];
        }];
    }else{
        
    }
}

- (IBAction)inviteTeamButtonTapped:(id)sender
{
    if (self.teamHint.teamId == self.competitorTeamId) {
        [Util showErrorAlertView:nil message:@"우리 팀과 경기를 만들 수 없습니다"];
        return;
    }
    
    if (self.pageoOriginType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM) {
        
        LoadingView *inviteLoadingView = [LoadingView startLoading:@"초대하고 있습니다" parentView:self.view];
        
        [[GroundClient getInstance] inviteTeamWithMatchId:self.match.matchId hometeam:self.teamHint.teamId awayTeam:self.competitorTeamId callback:^(BOOL result, NSDictionary *data){
            if (result) {
                
                if (self.pageoOriginType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }else{
                
                NSLog(@"error to invite a team in search team for new match");
                [Util showErrorAlertView:nil message:@"초대하지 못했습니다"];
            }
            
            [inviteLoadingView stopLoading];
        }];
        
    }else if (self.pageoOriginType == VIEW_FROM_MAKING_NEW_MATCH){
        
        _makeMatchViewController.competitiveTeamId = self.competitorTeamId;
        [_makeMatchViewController.competitiveTeamNameLabel setText:self.competitorTeamInfo.name];
        [_makeMatchViewController.competitiveTeamNameLabel setTextColor:UIColorFromRGB(0x000000)];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == VIEW_FROM_MENU){
        if(buttonIndex == 0){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if(alertView.tag == VIEW_FROM_TEAMURL_INVITE){
        if(buttonIndex == 0){
            [self goMyNewsView];
        }
    }
}

@end
