//
//  TeamMainInfoViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define MEMBER_PAGE         0
#define PENDING_USER_PAGE   1
#define MANAGER_SECTION     0
#define MEMBER_SECTION      1

#import "TeamMainInfoViewController.h"
#import "EditTeamInfoViewController.h"
#import "AcceptUserJoinViewController.h"
#import "EditManagerViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "TeamInfo.h"
#import "UserDataController.h"
#import "ImageDataController.h"

#import "GroundClient.h"

#import "Util.h"
#import "ViewUtil.h"
#import "KakaotalkUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

static BOOL isMenuOn;

@implementation TeamMainInfoViewController{
    UserDataController *memberDataController;
    UserDataController *wantToJoinUserList;
    UserDataController *managerUserList;
    UserDataController *normalUserList;
    ImageDataController *userImageDataController;
    NSMutableArray *userList;
    NSMutableArray *sectionList;
    BOOL hasMemberToJoin;
    NSInteger listingSectionNumber;
    
    LoadingView *loadingView;
    
    UITapGestureRecognizer *singleFingerTap;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
}

- (void)viewDidLayoutSubviews
{
    if (!self.teamHint.isManaged) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self doMenuSlideBack];
    
    listingSectionNumber = MEMBER_PAGE;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    loadingView = [LoadingView startLoading:@"팀 정보를 불러오고 있습니다" parentView:self.view];
    
    [self getTeamInfo];

    memberDataController = [[UserDataController alloc] init];
    wantToJoinUserList = [[UserDataController alloc] init];
    managerUserList = [[UserDataController alloc] init];
    normalUserList = [[UserDataController alloc] init];
    userImageDataController = [[ImageDataController alloc] init];
    userList = [[NSMutableArray alloc] init];
    sectionList = [[NSMutableArray alloc] init];

    if (self.teamHint.isManaged) {
        [self getMemberWantToJoinTeam];
    }else{
        [self getMember];
    }
    
    self.myMemberCollectionView.delegate = self;
    self.myMemberCollectionView.dataSource = self;
    
}

- (void)getTeamInfo
{
//    LoadingView *loadingView = [LoadingView startLoading:@"팀원 목록을 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getTeamInfo:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            TeamInfo *theTeam = [[TeamInfo alloc] initTeamInfoWithData:[data objectForKey:@"teamInfo"]];
            self.teamInfo = theTeam;
            if (![theTeam.imageUrl isEqual:[NSNull null]]) {
                [self getMyTeamImage];
            }else{
//                self.teamImageView.image = [ViewUtil maskImage:[UIImage imageNamed:@"inactiveTeam_icon"] withMask:[UIImage imageNamed:@"circleImageFrame"]];
                self.teamImage = [UIImage imageNamed:@"inactiveTeam_icon"];
                self.teamImageView.image = [ViewUtil circleMaskImageWithImage:self.teamImage];
            }
            [self configureTeamInfoView];
        }else{
            NSLog(@"error to load team info in my team info in match");
            [Util showErrorAlertView:nil message:@"팀 정보를 가져오는데 실패했습니다"];
        }
        
//        [loadingView stopLoading];
    }];
}

- (void)getMyTeamImage
{
    [[GroundClient getInstance] downloadProfileImage:self.teamHint.imageUrl thumbnail:FALSE callback:^(BOOL result, NSDictionary *data){
        if(result){
            UIImage *theImage = [data objectForKey:@"image"];
//            self.teamImageView.image = [ViewUtil maskImage:theImage withMask:[UIImage imageNamed:@"circleImageFrame.png"]];
            self.teamImage = theImage;
            self.teamImageView.image = [ViewUtil circleMaskImageWithImage:self.teamImage];
        }else{
            NSLog(@"error to download my team image in detail match info");
            [Util showErrorAlertView:nil message:@"사진 다운에 실패하였습니다"];
        }
    }];
}

- (void)configureTeamInfoView
{
    TeamInfo *theTeam = self.teamInfo;
    
    self.teamNameLabel.text = theTeam.name;
    self.teamInfoLabel.text = [NSString stringWithFormat:@"나이 : %.1f세\n팀원 : %d명\n클럽점수 : %d점", [theTeam.avgBirth floatValue], theTeam.membersCount, theTeam.score];
}

- (void)getMemberWantToJoinTeam
{
    [[GroundClient getInstance] getPendingMembersList:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *theMemberArray = [data objectForKey:@"userList"];
            
            if (![theMemberArray count]) {
                listingSectionNumber = MEMBER_PAGE;
            }
            
            for(id object in theMemberArray){
                User *theUser = [[User alloc] initUserWithData:object];
                [wantToJoinUserList addUserWithUser:theUser];
                if (![theUser.imageUrl isEqual:[NSNull null]]) {
                    [self getMemberImage:theUser.imageUrl MemberId:theUser.userId];
                }
            }
            [self getMember];
        }else{
            NSLog(@"error to load pending member in team main info");
            [Util showErrorAlertView:nil message:@"가입 팀원을 불러오는데 실패했습니다"];
            [loadingView stopLoading];
        }
    }];
}

- (void)getMember
{
    [[GroundClient getInstance] getTeamMembersList:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *theMemberArray = [data objectForKey:@"userList"];
            for(id object in theMemberArray){
                User *theUser = [[User alloc] initUserWithData:object];
                [memberDataController addUserWithUser:theUser];
                if(![theUser.imageUrl isEqual:[NSNull null]]){
                    [self getMemberImage:theUser.imageUrl MemberId:theUser.userId];
                }
            }
            
            [self divideMember];
        }else{
            NSLog(@"error to load member list in team main info");
            [Util showErrorAlertView:nil message:@"팀원을 불러오는데 실패했습니다"];
            [loadingView stopLoading];
        }
    }];
}

- (void)divideMember
{
    [managerUserList addUserListWithUserList:[memberDataController filteredUserListAboutFilteringNumber:YES]];
    [normalUserList addUserListWithUserList:[memberDataController filteredUserListAboutFilteringNumber:NO]];
    
    [userList addObject:managerUserList];
    [userList addObject:normalUserList];
    
    [self.myMemberCollectionView reloadData];
    
    [loadingView stopLoading];
}

- (void)getMemberImage:(NSString *)imageUrl MemberId:(NSInteger)idNumber
{
    [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
        if(result){
            UIImage *theContentImage = [data objectForKey:@"image"];
            [userImageDataController addObjectWithImage:theContentImage withId:idNumber];
            [self.myMemberCollectionView reloadData];
        }else{
            NSLog(@"error to load member in my team info in match");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(self.teamHint.teamId){
        return YES;
    }else return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"EditTeamInfo"]){
        
        EditTeamInfoViewController *childViewController = (EditTeamInfoViewController *)[segue destinationViewController];
        
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.myTeamInfo = self.teamInfo;
        childViewController.teamImage = self.teamImage;
        childViewController.hidesBottomBarWhenPushed = YES;
        return;
    }
    
    // MANAGER EDIT Selected
    if([[segue identifier] isEqualToString:@"EditManager"]){
        
        EditManagerViewController *childViewController = (EditManagerViewController *)[segue destinationViewController];
        
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        [childViewController.managerUserList addUserListWithUserList:[managerUserList allObjectInList]];
        [childViewController.normarUserList addUserListWithUserList:[normalUserList allObjectInList]];
        childViewController.hidesBottomBarWhenPushed = YES;
        return;
    }
    
    NSIndexPath *indexPath = [[self.myMemberCollectionView indexPathsForSelectedItems] objectAtIndex:0];
    
    // PENDING MEMBER Selected
    if([[segue identifier] isEqualToString:@"ShowUserWantToJoin"]){
        
        User *userAtIndex = [wantToJoinUserList objectInListAtIndex:indexPath.row];
        AcceptUserJoinViewController *childViewController = (AcceptUserJoinViewController *)[segue destinationViewController];
        
        childViewController.pageType = PENDING_USER_PAGE;
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.showingUser = userAtIndex;
        childViewController.showingUserImage = [userImageDataController imageWithId:userAtIndex.userId];
        childViewController.hidesBottomBarWhenPushed = YES;
    }
    
    // TEAM MEMBER Selected
    if([[segue identifier] isEqualToString:@"ShowUserInfo2"] || [[segue identifier] isEqualToString:@"ShowUserInfo"]){
        
        User *userAtIndex = [[userList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
        AcceptUserJoinViewController *childViewController = (AcceptUserJoinViewController *)[segue destinationViewController];
        
        childViewController.pageType = MEMBER_PAGE;
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.showingUser = userAtIndex;
        childViewController.showingUserImage = [userImageDataController imageWithId:userAtIndex.userId];
        childViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark -
#pragma mark - Menu slide implementation methods
- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    [self doMenuSlideBack];
}

- (void)doMenuSlide
{
    isMenuOn = [_teamTabbarParentViewController slide];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.coverView = [[UIView alloc] initWithFrame:screenRect];
    [self.coverView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.coverView addGestureRecognizer:singleFingerTap];
    [self.view addSubview:self.coverView];
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    [self.myMemberCollectionView setScrollEnabled:NO];
}

- (void)doMenuSlideBack
{
    isMenuOn = [_teamTabbarParentViewController slideBack];
    [self.coverView removeFromSuperview];
    [singleFingerTap removeTarget:self action:@selector(handleSingleTap:)];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.myMemberCollectionView setScrollEnabled:YES];
}

#pragma mark - IBAction Methods
- (IBAction)slide:(id)sender
{
    if(!isMenuOn){
        [self doMenuSlide];
    }else{
        [self doMenuSlideBack];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelToEditTeamInfo"]) {
    }
}

- (IBAction)accept:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"AcceptJoinToTeam"]){
        
    }
}

- (IBAction)reject:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"RejectJoinToTeam"]){
        
    }
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [userList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([wantToJoinUserList countOfList] && (listingSectionNumber == PENDING_USER_PAGE) && (section == MEMBER_SECTION)) {
        return [wantToJoinUserList countOfList];
    }else return ([[userList objectAtIndex:section] countOfList] + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // MANAGER EDIT Cell
    if ((indexPath.section == MANAGER_SECTION) && (indexPath.row == [[userList objectAtIndex:indexPath.section] countOfList])) {
        
        static NSString *CellIdentifier = @"EditManagerCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
        
    // KAKAOTALK INVITE Cell
    }else if((listingSectionNumber == MEMBER_PAGE) && (indexPath.section == MEMBER_SECTION) && (indexPath.row == [[userList objectAtIndex:indexPath.section] countOfList])){
        static NSString *CellIdentifier = @"InviteUserThroughKakaotalkCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        UIImageView *InviteThruKakaoImageView = (UIImageView *)[cell viewWithTag:510];
        InviteThruKakaoImageView.image = [UIImage imageNamed:@"button_kakao"];
        return cell;
        
        
    // PENDING MEMBER Cell
    }else if ((listingSectionNumber == PENDING_USER_PAGE) && (indexPath.section == MEMBER_SECTION)){
        
        static NSString *CellIdentifier = @"PendingUserCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        User *theUser = [wantToJoinUserList objectInListAtIndex:indexPath.row];
        
        UIImageView *pendingUserImageView = (UIImageView *)[cell viewWithTag:503];
        UILabel *pendingUserNameLabel = (UILabel *)[cell viewWithTag:504];
        if(![theUser.imageUrl isEqual:[NSNull null]]){
            pendingUserImageView.image = [userImageDataController imageWithId:theUser.userId];
        }else{
            pendingUserImageView.image = [UIImage imageNamed:@"profile_noImage"];
        }
        pendingUserNameLabel.text = theUser.name;
//        pendingUserNameLabel.font = UIFontFixedFontWithSize(12);
        
        return cell;
        
    //  NORMAL MEMBER Cell
    }else{
        NSMutableArray *CellIdentifierArray = [[NSMutableArray alloc] initWithObjects:@"ManagerUserCell", @"NormalUserCell", nil];
        NSMutableArray *tagArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:505], [NSNumber numberWithInt:507], nil];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.section] forIndexPath:indexPath];
        User *theUser = [[userList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
        
        NSInteger tag = [[tagArray objectAtIndex:indexPath.section] integerValue];
        UIImageView *userImageView = (UIImageView *)[cell viewWithTag:tag++];
        if([theUser.imageUrl isEqual:[NSNull null]]){
            userImageView.image = [UIImage imageNamed:@"profile_noImage"];
        }else{
            userImageView.image = [userImageDataController imageWithId:theUser.userId];
        }
        UILabel *userNameLabel = (UILabel *)[cell viewWithTag:tag];
        userNameLabel.text = theUser.name;
//        userNameLabel.font = UIFontFixedFontWithSize(12);
        
        return cell;
    }
}

#pragma mark - Collection View Delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MemberOrganizationHeaderView" forIndexPath:indexPath];
        UIImageView *headerLeftBarImageView = (UIImageView *)[headerView viewWithTag:5050];
        UIImageView *headerMiddleBarImageView = (UIImageView *)[headerView viewWithTag:5051];
        UIButton *headerLeftButton = (UIButton *)[headerView viewWithTag:5052];
        UIButton *headerMiddleButton = (UIButton *)[headerView viewWithTag:5053];
        [headerLeftButton addTarget:self action:@selector(headerLeftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [headerMiddleButton addTarget:self action:@selector(headerMiddleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableArray *sectionHeaderImageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"bar_labelWithLine_green_upper"], [UIImage imageNamed:@"bar_labelWithLine_black_upper"], nil];
        NSMutableArray *sectionHeaderTitleArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"매니져: %d명", [managerUserList countOfList]], [NSString stringWithFormat:@"일반 멤버: %d명", [normalUserList countOfList]], nil];
        headerLeftBarImageView.image = [sectionHeaderImageArray objectAtIndex:indexPath.section];
        [headerLeftButton setTitle:[sectionHeaderTitleArray objectAtIndex:indexPath.section] forState:UIControlStateNormal];
        headerLeftButton.titleLabel.textAlignment = NSTextAlignmentCenter;

        headerMiddleBarImageView.image = [UIImage imageNamed:@"bar_labelWithLine_gray_upper_middle"];
        [headerMiddleButton setTitle:[NSString stringWithFormat:@"가입신청유저:%d명",[wantToJoinUserList countOfList]] forState:UIControlStateNormal];
        headerMiddleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        headerMiddleBarImageView.hidden = YES;
        headerMiddleButton.hidden = YES;
        if(indexPath.section == MEMBER_SECTION){
            if([wantToJoinUserList countOfList]){
                headerMiddleBarImageView.hidden = NO;
                headerMiddleButton.hidden = NO;
            }
        }
        
        if(listingSectionNumber == MEMBER_PAGE){
            [headerView sendSubviewToBack:headerMiddleBarImageView];
        }else{
            [headerView sendSubviewToBack:headerLeftBarImageView];
        }
        
        reusableView = headerView;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if ((listingSectionNumber == MEMBER_PAGE) && (indexPath.section == MEMBER_SECTION) && (indexPath.row == [[userList objectAtIndex:indexPath.section] countOfList])) {
        [self inviteThruKakaotalk];
    }
}

- (void)headerLeftButtonTapped
{
    if(listingSectionNumber == PENDING_USER_PAGE){
        listingSectionNumber = MEMBER_PAGE;
        [self.myMemberCollectionView reloadData];
    }
}

- (void)headerMiddleButtonTapped
{
    if(listingSectionNumber == MEMBER_PAGE){
        listingSectionNumber = PENDING_USER_PAGE;
        [self.myMemberCollectionView reloadData];
    }
}

#pragma mark - kakaotalk
- (void)inviteThruKakaotalk
{
    LoadingView *kakaoLoadingView = [LoadingView startLoading:@"잠시만 기다려주세요." parentView:self.view];
    
    // 카카오톡 링크 열 수 있는지 확인
    if([KakaotalkUtil canOpenKakaoLink])
    {
        //GAI - 카카오톡 초대 트래킹
        NSDictionary *campaignParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"invite_team_member", kGAICampaignSource,
                                        @"kakaotalk", kGAICampaignMedium,
                                        @"GroundIOS", kGAICampaignName, nil];
        [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] setAll:campaignParams] build]];
        
        NSMutableArray *metaInfoArray = [NSMutableArray array];
        NSDictionary *metaInfoAndroid = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"android", @"os",
                                         @"phone", @"devicetype",
                                         @"market://details?id=com.anb.ground", @"installurl",
                                         [NSString stringWithFormat:@"anbGround://showInvitation?teamId=%d", self.teamHint.teamId], @"executeurl",
                                         nil];
        NSDictionary *metaInfoIOS = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ios", @"os",
                                     @"phone", @"devicetype",
                                     @"http://itunes.apple.com/app/768294447", @"installurl",
                                     [NSString stringWithFormat:@"GroundIOS://teamId=%d", self.teamHint.teamId], @"executeurl",
                                     nil];
        
        [metaInfoArray addObject:metaInfoAndroid];
        [metaInfoArray addObject:metaInfoIOS];
        
        [KakaotalkUtil openKakaoAppLinkWithMessage:[NSString stringWithFormat:@"%@에서 당신을 초대합니다.", self.teamHint.name]
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
