//
//  MyTeamInfoInMatchViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define NONE_REPLY  0
#define REPLY_NO    1
#define REPLY_YES   2
#define REPLY_YES_SECTION   0
#define REPLY_NO_SECTION    1
#define NONE_REPLY_SECTION  2

#import "MyTeamInfoInMatchViewController.h"
#import "PressingReplyViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "TeamInfo.h"
#import "Match.h"
#import "JoinUser.h"
#import "JoinUserDataController.h"
#import "ImageDataController.h"

#import "GroundClient.h"

#import "Util.h"
#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation MyTeamInfoInMatchViewController{
    JoinUserDataController *noAnswerUserList;
    JoinUserDataController *joiningUserList;
    JoinUserDataController *notJoiningUserList;
    NSArray *UserList;
    ImageDataController *userImageDataController;
    
    LoadingView *loadingView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.myTeamImage = [[UIImage alloc] init];
    self.match = [[Match alloc] init];
}

- (void)viewDidLayoutSubviews
{
    if (self.teamHint.isManaged) {
        self.pressReplyButton.hidden = NO;
    }else{
        self.pressReplyButton.hidden = YES;
        CGRect collectionNewFrame = self.myMemberCollectionView.frame;
        collectionNewFrame.origin = self.myMemberCollectionView.frame.origin;
        collectionNewFrame.size.height = self.view.frame.size.height - collectionNewFrame.origin.y;
        self.myMemberCollectionView.frame = collectionNewFrame;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self getTeamInfo];
    
    self.memberDataController = [[JoinUserDataController alloc] init];
    noAnswerUserList = [[JoinUserDataController alloc] init];
    joiningUserList = [[JoinUserDataController alloc] init];
    notJoiningUserList = [[JoinUserDataController alloc] init];
    userImageDataController = [[ImageDataController alloc] init];

    [self getJoinMember];
    
    self.myMemberCollectionView.delegate = self;
    self.myMemberCollectionView.dataSource = self;
    
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teamInfo_memberList_bg"]];
//    tempImageView.contentMode = UIViewContentModeCenter;
//    [tempImageView setFrame:self.myMemberCollectionView.frame];
//    self.myMemberCollectionView.backgroundView = tempImageView;
}

- (void)getTeamInfo
{
    [[GroundClient getInstance] getTeamInfo:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            TeamInfo *theTeam = [[TeamInfo alloc] initTeamInfoWithData:[data objectForKey:@"teamInfo"]];
            self.teamInfo = theTeam;
            [self configureTeamInfoView];
        }else{
            NSLog(@"error to load team info in my team info in match");
            [Util showErrorAlertView:nil message:@"팀 정보를 가져오는데 실패했습니다"];
        }
    }];
}

- (void)configureTeamInfoView
{
    TeamInfo *theTeamInfo = self.teamInfo;
    TeamHint *theTeamHint = self.teamHint;
    UIImage *theTeamImage = self.myTeamImage;
    
    self.myTeamNameLabel.text = theTeamHint.name;
    self.myTeamImageView.image = [ViewUtil circleMaskImageWithImage:theTeamImage];
    self.myTeamInfoLabel.text = [NSString stringWithFormat:@"나이:평균%.1f세\n팀원:%d명\n클럽점수:%d점", [theTeamInfo.avgBirth floatValue], theTeamInfo.membersCount, theTeamInfo.score];
}

- (void)getJoinMember
{
    loadingView = [LoadingView startLoading:@"참가자 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] showJoinedMembersList:self.match.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *theMembersArray = [data objectForKey:@"userList"];
            for( id object in theMembersArray ){
                JoinUser *theJoinUser = [[JoinUser alloc] initJoinUserWithData:object];
                [self.memberDataController addJoinUserWithJoinUser:theJoinUser];
                if (theJoinUser.imageUrl != (id)[NSNull null]) {
                    [self getJoinMemberImage:theJoinUser.imageUrl MemberId:theJoinUser.userId];
                }
            }
            
            // Tracking - 참가자정보 열람
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match_team" action:@"players" label:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] value:0] build]];
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:[NSString stringWithFormat:@"matchId %d", self.match.matchId] label:@"see_players_list" value:0] build]];
            
            [self divideJoinMember];
        }else{
            NSLog(@"error to load team members list in my team info in match");
            [Util showErrorAlertView:nil message:@"멤버 정보를 가져오는데 실패했습니다"];
            [loadingView stopLoading];
        }
    }];
}

- (void)getJoinMemberImage:(NSString *)imageUrl MemberId:(NSInteger)idNumber
{
    [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
        if(result){
            UIImage *theImage = [data objectForKey:@"image"];
            [userImageDataController addObjectWithImage:theImage withId:idNumber];
            [self.myMemberCollectionView reloadData];
        }else{
            NSLog(@"error to load member in my team info in match");
        }
    }];
}

- (void)divideJoinMember
{
    [noAnswerUserList addJoinUserListWithJoinUserList:[self.memberDataController filteredUserInList:NONE_REPLY]];
    [notJoiningUserList addJoinUserListWithJoinUserList:[self.memberDataController filteredUserInList:REPLY_NO]];
    [joiningUserList addJoinUserListWithJoinUserList:[self.memberDataController filteredUserInList:REPLY_YES]];
    [noAnswerUserList sortUserListByName];
    [notJoiningUserList sortUserListByName];
    [joiningUserList sortUserListByName];
    
    UserList = [[NSArray alloc] initWithObjects:joiningUserList, notJoiningUserList, noAnswerUserList, nil];
    
    [self.myMemberCollectionView reloadData];
    [loadingView stopLoading];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowMembetNotToReply"]){
        PressingReplyViewController *childViewController = (PressingReplyViewController *)[segue destinationViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.matchId = self.match.matchId;
        [childViewController.noAnswerUserDataController addJoinUserListWithJoinUserList:[noAnswerUserList allJoinUserInList]];
    }
    if ([[segue identifier] isEqualToString:@"CancelToShowJoinMemberInfo"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Colleation View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [UserList count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[UserList objectAtIndex:section] countOfList];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CollectionCellIdentifier = @"MyMemberCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
    
    JoinUser *theUser = [[UserList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
    
    UIImageView *userImageView = (UIImageView *)[cell viewWithTag:485];
    UILabel  *userNameLabel = (UILabel *)[cell viewWithTag:486];
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
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myMemberHeaderView" forIndexPath:indexPath];
        CGFloat padding = 17;
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 0, collectionView.frame.size.width - padding*2, 20)];
        headerImageView.image = [UIImage imageNamed:@"bg_e2e2e2"];
        [headerView addSubview:headerImageView];
        UILabel *headerNameLabel = (UILabel *)[headerView viewWithTag:488];
        [headerView bringSubviewToFront:headerNameLabel];
        if(indexPath.section == REPLY_YES_SECTION){
            headerNameLabel.text =[NSString stringWithFormat:@"참가 : %d명", [[UserList objectAtIndex:indexPath.section] countOfList]];
        }else if(indexPath.section == REPLY_NO_SECTION){
            headerNameLabel.text =[NSString stringWithFormat:@"불참 : %d명", [[UserList objectAtIndex:indexPath.section] countOfList]];
        }else{
            headerNameLabel.text =[NSString stringWithFormat:@"미정 : %d명", [[UserList objectAtIndex:indexPath.section] countOfList]];
        }
        
        reusableView = headerView;
    }
    return reusableView;
}

#pragma mark - IBAction Methods
- (IBAction)cancel:(UIStoryboardSegue *)sender
{
}

@end
