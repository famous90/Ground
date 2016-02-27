//
//  DetailMatchViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 5..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define HOME_ONLY           0
#define INVITE              1
#define REQUEST             2
#define MATCHING_COMPLETED  3

#define NONE_REPLY  0
#define REPLY_NO    1
#define REPLY_YES   2

#import "DetailMatchViewController.h"
#import "MyTeamInfoInMatchViewController.h"
#import "AwayTeamInfoInMatchViewController.h"
#import "SearchTeamForNewMatchViewController.h"
#import "ChatViewController.h"
#import "TeamTabbarParentViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "Match.h"
#import "MatchInfo.h"

#import "Ground.h"
#import "GroundClient.h"
#import "Config.h"

#import "NSDate+Utils.h"
#import "Util.h"
#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation DetailMatchViewController{
    BOOL joinMatchButtonSelected;
    BOOL notJoinMatchButtonSelected;
    BOOL matchInfoSectionTapped;
}

- (void)viewDidLayoutSubviews
{
//    self.acceptMatchButton.hidden = YES;
//    self.rejectMatchButton.hidden = YES;
//    self.cancelMatchRequestButton.hidden = YES;
//    
//    self.surveyMemberParticipating.hidden = YES;
//    self.joinMatchButton.hidden = YES;
//    self.notJoinMatchButton.hidden = YES;
//    self.chattingImageView.hidden = NO;
//    NSLog(@"VIEW DID LAYOUT SUBVIEWS");
    
    if (self.matchInfo.status == MATCHING_COMPLETED) {
        NSInteger randomBgNum = arc4random() % 3;
        NSArray *backgroundImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"detailMatch_complete_bg1"], [UIImage imageNamed:@"detailMatch_complete_bg2"], [UIImage imageNamed:@"detailMatch_complete_bg3"], nil];
        self.teamInfoBgImageView.image = [backgroundImageArray objectAtIndex:randomBgNum];
        
        CGRect chattingButtonNewFrame = self.chattingButton.frame;
        chattingButtonNewFrame.size.width = self.view.frame.size.width - self.chattingButton.frame.origin.x * 2;
        self.chattingButton.frame = chattingButtonNewFrame;
        
    }else if (self.matchInfo.status == HOME_ONLY){
        [self.chattingButton setHidden:YES];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.match = [[Match alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    matchInfoSectionTapped = YES;
    self.competitorTeamHint = [[TeamHint alloc] init];

    [self getMatchInfo];
}

- (void)getMatchInfo
{
     LoadingView *loadingView = [LoadingView startLoading:@"경기 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getMatchInfo:self.match.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            self.matchInfo = [[MatchInfo alloc] initMatchInfoWithData:[data objectForKey:@"matchInfo"]];
            
            if (self.teamHint.imageUrl != (id)[NSNull null]) {
                [self getMyTeamImage];
            }else{
                self.myTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
                self.myTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.myTeamImage];
            }

            [self configureView];
        }else{
            NSLog(@"error to load match info in setting match result");
            [Util showErrorAlertView:nil message:@"경기정보를 불러오는데 실패했습니다"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)getMyTeamImage
{
    if ((self.pageOriginType == VIEW_FROM_MATCH_LIST) || (self.pageOriginType == VIEW_FROM_SEARCH_MATCH && self.matchInfo.status == REQUEST) || (self.pageOriginType == VIEW_FROM_PUSHMESSAGE)) {
        [[GroundClient getInstance] downloadProfileImage:self.teamHint.imageUrl thumbnail:FALSE callback:^(BOOL result, NSDictionary *data){
            if(result){
                
                self.myTeamImage = [data objectForKey:@"image"];
                self.myTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.myTeamImage];
                
            }else{
                NSLog(@"error to download my team image in detail match info");
//                [Util showErrorAlertView:nil message:@"우리팀 사진을 불러오느데 실패하였습니다"];
                self.myTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
                self.myTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.myTeamImage];
            }
        }];
    }
}

- (void)getCompetitorTeamImage:(NSString *)competitorTeamImageUrl
{
    if (competitorTeamImageUrl != (id)[NSNull null]) {
        [[GroundClient getInstance] downloadProfileImage:competitorTeamImageUrl thumbnail:FALSE callback:^(BOOL result, NSDictionary *data){
            if(result){
                self.competitorTeamImage = [data objectForKey:@"image"];
                self.competitorTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.competitorTeamImage];
            }else{
                NSLog(@"error to download my team image in detail match info");
                //            [Util showErrorAlertView:nil message:@"상대팀 사진을 불러오는데 실패하였습니다"];
                self.competitorTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
                self.competitorTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.competitorTeamImage];
            }
        }];
        
    }else{
        self.competitorTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
        self.competitorTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.competitorTeamImage];
    }
}

- (void)configureView
{
    MatchInfo *theMatch = self.matchInfo;
    TeamHint *myTeam = self.teamHint;
    
    NSString *myTeamName;
    NSString *competitiveTeamName;
    NSInteger homeJoinedMembersCount;
    NSInteger competitorJoinedMembersCount;
    
    // HAVE A COMPETITIVE TEAM
    if(theMatch.homeTeamId && theMatch.awayTeamId){
        
        // HOME
        if([theMatch isHomeTeamWithTeam:self.teamHint.teamId]){
            homeJoinedMembersCount = theMatch.homeJoinedMembersCount;
            competitorJoinedMembersCount = theMatch.awayJoinedMembersCount;
            [self.competitorTeamHint setTeamhintWithTeamId:theMatch.awayTeamId name:theMatch.awayTeamName imageUrl:theMatch.awayImageUrl];
            
        // AWAY
        }else{
            homeJoinedMembersCount = theMatch.awayJoinedMembersCount;
            competitorJoinedMembersCount = theMatch.homeJoinedMembersCount;
            [self.competitorTeamHint setTeamhintWithTeamId:theMatch.homeTeamId name:theMatch.homeTeamName imageUrl:theMatch.homeImageUrl];
        }
        myTeamName = myTeam.name;
        competitiveTeamName = self.competitorTeamHint.name;

        [self getCompetitorTeamImage:self.competitorTeamHint.imageUrl];
        
    // NO COMPETITIVE
    }else{
        
        // VIEW FROM MATCH LIST
        if ((self.pageOriginType == VIEW_FROM_MATCH_LIST) || (self.pageOriginType == VIEW_FROM_PUSHMESSAGE)) {
            myTeamName = myTeam.name;
            homeJoinedMembersCount = theMatch.homeJoinedMembersCount;
            competitiveTeamName = @"상대없음";
            competitorJoinedMembersCount = 0;
            self.competitorTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
            self.competitorTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.competitorTeamImage];
            
        // VIEW FROM SEARCH MATCH
        }else {
            myTeamName = @"상대없음";
            homeJoinedMembersCount = 0;
            competitiveTeamName = theMatch.homeTeamName;
            competitorJoinedMembersCount = theMatch.homeJoinedMembersCount;
            [self.myTeamImageView setUserInteractionEnabled:NO];
            self.myTeamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
            self.myTeamImageView.image = [ViewUtil circleMaskImageWithImage:self.myTeamImage];
            [self.myTeamImageGestureRecognizer setEnabled:NO];
            [self getCompetitorTeamImage:theMatch.homeImageUrl];
        }
    }
    
    self.myTeamNameLabel.text = myTeamName;
    self.myTeamJoinedMembersCountLabel.text = [NSString stringWithFormat:@"%d명", homeJoinedMembersCount];
    self.competitorTeamNameLabel.text = competitiveTeamName;
    self.competitorJoinedMembersCountLabel.text = [NSString stringWithFormat:@"%d명", competitorJoinedMembersCount];
    
    if (self.teamHint.isManaged) {
        [self setMatchingButtonOnView];
    }
    
    [self setNavTitle];
    
    if ((self.pageOriginType == VIEW_FROM_MATCH_LIST) || (self.pageOriginType == VIEW_FROM_SEARCH_MATCH && theMatch.status == REQUEST) || (self.pageOriginType == VIEW_FROM_PUSHMESSAGE)) {
        self.requestMatchButton.hidden = YES;
        [self setSurveyButtonOnView];
    }
    
    self.matchDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.startTime format:1];
    self.matchTimeLabel.text = [NSString stringWithFormat:@"%@~%@", [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.startTime format:10], [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.endTime format:10]];
    self.matchLocationLabel.text = theMatch.ground.name;
    if ([theMatch.description isEqual:[NSNull null]]) {
        self.matchDescriptionTextView.text = @"추가 내용 없음";
        [self.matchDescriptionTextView setTextAlignment:NSTextAlignmentCenter];
    }else{
        self.matchDescriptionTextView.text = theMatch.description;
    }
    
    [self setDaumMapView];
}

- (void)setMatchingButtonOnView
{
    MatchInfo *theMatch = self.matchInfo;
    
    if ((self.pageOriginType == VIEW_FROM_MATCH_LIST) || (self.pageOriginType == VIEW_FROM_SEARCH_MATCH && theMatch.status == REQUEST) || (self.pageOriginType == VIEW_FROM_PUSHMESSAGE)) {
        
        self.chattingButton.hidden = NO;
        // HOME & NO COMPETITIVE
        if(theMatch.status == HOME_ONLY){
            //        self.chattingImageView.hidden = YES;
            
        }else if(theMatch.status == INVITE){
            
            // HOME & INVITE
            if([theMatch isHomeTeamWithTeam:self.teamHint.teamId]){
                self.cancelMatchRequestButton.hidden = NO;
                
                // AWAY & WAS INVITED
            }else{
                self.acceptMatchButton.hidden = NO;
                self.rejectMatchButton.hidden = NO;
            }
            
        }else if(theMatch.status == REQUEST){
            
            // HOME & REQUEST
            if([theMatch isHomeTeamWithTeam:self.teamHint.teamId]){
                self.acceptMatchButton.hidden = NO;
                self.rejectMatchButton.hidden = NO;
                
                // AWAY & WAS REQUESTED
            }else{
                self.cancelMatchRequestButton.hidden = NO;
            }
            self.chattingButton.hidden = NO;
            
        // MATCHING_COMPLETED
        }else if(theMatch.status == MATCHING_COMPLETED){
            self.chattingButton.hidden = NO;
        }
        
    // MATCH INFO FOR SEARCH MATCH RESULT
    }else if(self.pageOriginType == VIEW_FROM_SEARCH_MATCH && theMatch.status != REQUEST){
        [self.requestMatchButton setHidden:NO];
    }
}

- (void)setNavTitle
{
    MatchInfo *theMatch = self.matchInfo;
    NSString *navTitle = nil;
    
    if(self.pageOriginType == VIEW_FROM_SEARCH_MATCH){
        
        if (theMatch.status == REQUEST) {
        
            navTitle = @"요청한 경기";
            
        }else{
            
            navTitle = @"경기 검색 결과";
        }
    }else if ((self.pageOriginType == VIEW_FROM_MATCH_LIST) || (self.pageOriginType == VIEW_FROM_PUSHMESSAGE)) {
        // COMPLETE MATCH
        if(theMatch.status == MATCHING_COMPLETED){
            navTitle = @"경기정보";
            
            // HOME & NO COMPETITIVE
        }else if(theMatch.status == HOME_ONLY){
            navTitle = @"홈경기정보";
            
        }else if(theMatch.status == INVITE){
            
            // HOME & INVITE COMPETITIVE
            if([theMatch isHomeTeamWithTeam:self.teamHint.teamId]){
                navTitle = @"우리팀 경기";
                
                // AWAY & WAS INVITED
            }else{
                navTitle = @"상대 초대 경기";
            }
            
        }else if(theMatch.status == REQUEST){
            
            // HOME & WAS REQUESTED
            if([theMatch isHomeTeamWithTeam:self.teamHint.teamId]){
                navTitle = @"요청받은 경기";
                
                // AWAY & REQUEST COMPETITIVE
            }else{
                navTitle = @"요청한 경기";
            }
        }
    }
    self.title = navTitle;
}

- (void)setSurveyButtonOnView
{
    // surveying
    if(self.matchInfo.askSurvey){

        self.surveyMemberParticipating.hidden = YES;
        [self.joinMatchButton setHidden: NO];
        [self.notJoinMatchButton setHidden: NO];
        
        if(self.matchInfo.join == NONE_REPLY){
            joinMatchButtonSelected = NO;
            notJoinMatchButtonSelected = NO;
            
        }else if(self.matchInfo.join == REPLY_NO){

            [self.joinMatchButton setSelected:NO];
            [self.notJoinMatchButton setSelected:YES];
            joinMatchButtonSelected = NO;
            notJoinMatchButtonSelected = YES;
            
        }else{
            
            [self.joinMatchButton setSelected:YES];
            [self.notJoinMatchButton setSelected:NO];
            joinMatchButtonSelected = YES;
            notJoinMatchButtonSelected = NO;
        }
        
    // manager and not surveying yet
    }else if((!self.matchInfo.askSurvey) && self.teamHint.isManaged){
        
        [self.surveyMemberParticipating setHidden:NO];
        self.joinMatchButton.hidden = YES;
        self.notJoinMatchButton.hidden = YES;
        joinMatchButtonSelected = NO;
        notJoinMatchButtonSelected = NO;
        
    // not manager and not surveying yet
    }else{

        [self.surveyMemberParticipating setTitle:@"참가자 조사를 시작하지 않았습니다" forState:UIControlStateNormal];
        [self.surveyMemberParticipating setTitle:@"참가자 조사를 시작하지 않았습니다" forState:UIControlStateSelected];
        [self.surveyMemberParticipating setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6] forState:UIControlStateNormal];
        self.surveyMemberParticipating.hidden = NO;
        self.surveyMemberParticipating.enabled = NO;
        self.joinMatchButton.hidden = YES;
        self.notJoinMatchButton.hidden = YES;
        joinMatchButtonSelected = NO;
        notJoinMatchButtonSelected = NO;
    }
}

- (void)setDaumMapView
{
    if(!self.mapView){
        self.mapView = [[MTMapView alloc] initWithFrame:[ViewUtil mapViewSizeInDetailMatchForiPhoneDeviceScreenHeight]];
        [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
        [self.mapView setUserInteractionEnabled:NO];
        self.mapView.currentLocationTrackingMode = NO;
        
        MTMapPOIItem *poiItem = [[MTMapPOIItem alloc] init];
        [poiItem setMapPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([self.matchInfo.ground.latitude doubleValue], [self.matchInfo.ground.longitude doubleValue])]];
//        [poiItem setItemName:[MTMapReverseGeoCoder findAddressForMapPoint:poiItem.mapPoint withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"]];

        [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:poiItem.mapPoint.mapPointGeo] zoomLevel:DAUM_MAP_ZOOM_LEVEL animated:YES];
        [self.mapView addPOIItem:poiItem];

        [self.matchLocationMapView addSubview:self.mapView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToShowDetailMatch"]) {
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
        
        if (self.pageOriginType == VIEW_FROM_MATCH_LIST) {
            [self dismissViewControllerAnimated:YES completion:nil];
        
        }else if (self.pageOriginType == VIEW_FROM_SEARCH_MATCH){
            [self dismissViewControllerAnimated:YES completion:Nil];
            
        }else if (self.pageOriginType == VIEW_FROM_PUSHMESSAGE){
            UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
            TeamTabbarParentViewController *childViewController = (TeamTabbarParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
            childViewController.user = self.user;
            childViewController.teamHint = self.teamHint;
            childViewController.tabbarSelectedIndex = TABBAR_INDEX_MATCH;
            
            [self presentViewController:childViewController animated:YES completion:nil];
        }
    }
    if ([[segue identifier] isEqualToString:@"ShowMyTeamInfoInMatch"]) {
        MyTeamInfoInMatchViewController *childViewController = (MyTeamInfoInMatchViewController *)[segue destinationViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.myTeamImage = self.myTeamImage;
        childViewController.match = self.match;

        [self.mapView removeFromSuperview];
        self.mapView = NULL;
    }
    if ([[segue identifier] isEqualToString:@"ChatWithCompetitiveTeam"]) {
        ChatViewController *childViewController = (ChatViewController *)[segue destinationViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.matchId = self.match.matchId;
        childViewController.competitiveTeamHint = self.competitorTeamHint;
        childViewController.myTeamImage = self.myTeamImage;
        childViewController.competitiveTeamImage = self.competitorTeamImage;
    }
}

#pragma mark - 
#pragma mark - IBAction Methods
- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelToShowDetailMatch"]) {
    }
    if ([[segue identifier] isEqualToString:@"CancelToShowJoinMemberInfo"]) {
    }
    if ([[segue identifier] isEqualToString:@"CancelToShowCompetitiveInfo"]) {
    }
    if ([[segue identifier] isEqualToString:@"CancelChatting"]) {
    }
}

- (IBAction)myTeamViewTapped:(UIGestureRecognizer *)sender
{
}

- (IBAction)competitorTeamTapped:(UIGestureRecognizer *)sender
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    
    // SEARCH COMPETITIVE TEAM
    if (self.matchInfo.status == HOME_ONLY) {
        
        SearchTeamForNewMatchViewController *childViewController = (SearchTeamForNewMatchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchTeamForNewMatchView"];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.matchId = self.matchInfo.matchId;
        childViewController.originType = VIEW_FROM_DETAIL_MATCH_INVITE_TEAM;
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
        
        [self.navigationController pushViewController:childViewController animated:YES];
    
    // SHOW COMPETITIVE TEAM INFO
    }else{

        AwayTeamInfoInMatchViewController *childViewController = (AwayTeamInfoInMatchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AwayTeamInfoInMatchView"];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.competitorTeamId = self.competitorTeamHint.teamId;
        childViewController.teamImage = self.competitorTeamImage;
        childViewController.match = self.match;
        childViewController.pageoOriginType = VIEW_FROM_DETAIL_MATCH;
        
        [self.mapView removeFromSuperview];
        self.mapView = NULL;

        [self.navigationController pushViewController:childViewController animated:YES];
    }
}

- (IBAction)acceptMatchButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"경기 수락 중" parentView:self.view];
    
    [[GroundClient getInstance] acceptMatch:self.matchInfo.matchId callback:^(BOOL result, NSDictionary *data){
        if(result){
            // Tracking - 경기수락
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match" action:@"accept" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"match" label:@"accept" value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"error to accept match in detail match");
            [Util showErrorAlertView:nil message:@"경기를 수락하는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)rejectMatchButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"경기 거절 중" parentView:self.view];
    
    [[GroundClient getInstance] denyMatch:self.matchInfo.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            // Tracking - 경기거절
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match" action:@"reject" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"match" label:@"reject" value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"error to reject match in detail match");
            [Util showErrorAlertView:nil message:@"경기를 거절하는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)cancelMatchRequestButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"경기 요청 취소 중" parentView:self.view];
    
    [[GroundClient getInstance] cancelMatch:self.matchInfo.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            // Tracking - 경기요청취소
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match" action:@"request_cancel" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"match" label:@"cancel" value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"error to cancel match in detail match");
            [Util showErrorAlertView:nil message:@"경기 취소를 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)requestMatchButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"경기 요청 중" parentView:self.view];
    
    [[GroundClient getInstance] requestMatch:self.matchInfo.matchId hometeam:self.matchInfo.homeTeamId awayTeam:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if (result) {
            // Tracking - 경기요청
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match" action:@"request" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"match" label:@"request" value:[NSNumber numberWithBool:self.matchInfo.askSurvey]] build]];
            
            [self getMatchInfo];
        }else{
            NSLog(@"error to request away match in search match");
            [Util showErrorAlertView:nil message:@"경기 요청에 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)matchInfoButtonTapped:(id)sender
{
    if (!matchInfoSectionTapped) {
        [self.view sendSubviewToBack:self.matchDetailInfoSectionImageView];
        [self.view sendSubviewToBack:self.matchDescriptionTextView];
        [self.view sendSubviewToBack:self.matchDescriptionTitleLabel];

        [self.view bringSubviewToFront:self.matchTimeBgImageView];
        [self.view bringSubviewToFront:self.matchLocationBgImageView];
        [self.view bringSubviewToFront:self.matchDateLabel];
        [self.view bringSubviewToFront:self.matchDateTitleLabel];
        [self.view bringSubviewToFront:self.matchTimeTitleLabel];
        [self.view bringSubviewToFront:self.matchTimeLabel];
        [self.view bringSubviewToFront:self.matchLocationTitleLabel];
        [self.view bringSubviewToFront:self.matchLocationLabel];
        [self.view bringSubviewToFront:self.matchLocationMapView];
        matchInfoSectionTapped = YES;
    }
}

- (IBAction)matchDetailInfoButtonTapped:(id)sender
{
    if (matchInfoSectionTapped) {
        [self.matchDescriptionTextView setHidden:NO];
        [self.matchDescriptionTitleLabel setHidden:NO];
        [self.view bringSubviewToFront:self.matchInfoBgImageView];
        [self.view bringSubviewToFront:self.matchDescriptionTextView];
        [self.view bringSubviewToFront:self.matchInfoFirstRowTitleBgImageView];
        [self.view bringSubviewToFront:self.matchDescriptionTitleLabel];
        [self.view sendSubviewToBack:self.matchInfoSectionImageView];
        matchInfoSectionTapped = NO;
    }
}

- (IBAction)surveyMemberParticipatingButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"조사를 시작하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] startJoinSurvey:self.match.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *date){
        if (result) {
            // Tracking - 참가자조사 시작
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"survey" label:@"" value:0] build]];
            
            self.surveyMemberParticipating.hidden = YES;
            self.joinMatchButton.hidden = NO;
            self.notJoinMatchButton.hidden = NO;
            [Util showAlertView:nil message:@"경기 참가 조사를 시작하였습니다"];
        }else{
            NSLog(@"error to start survey in detail match");
            [Util showErrorAlertView:Nil message:@"참가 조사하기에 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)joinMatchButtonTapped:(id)sender
{
    if (!joinMatchButtonSelected) {
        
        LoadingView *loadingView = [LoadingView startLoading:@"참가 정보를 보내고 있습니다" parentView:self.view];
        
        [[GroundClient getInstance] joinMatch:self.matchInfo.matchId teamId:self.teamHint.teamId join:YES callback:^(BOOL result, NSDictionary *data){
            if(result){
                [Util showAlertView:nil message:@"경기에 참여하기로 하였습니다"];
                joinMatchButtonSelected = YES;
                notJoinMatchButtonSelected = NO;
                [self.joinMatchButton setSelected:YES];
                [self.notJoinMatchButton setSelected:NO];
            }else{
                NSLog(@"error to join match in detail match");
                [Util showErrorAlertView:nil message:@"참여 메세지를 보내는데 실패했습니다"];
            }
            
            [loadingView stopLoading];
        }];
    }
}

- (IBAction)notJoinMatchButtonTapped:(id)sender
{
    if (!notJoinMatchButtonSelected) {
        
        LoadingView *loadingView = [LoadingView startLoading:@"참가 정보를 보내고 있습니다" parentView:self.view];
        
        [[GroundClient getInstance] joinMatch:self.matchInfo.matchId teamId:self.teamHint.teamId join:NO callback:^(BOOL result, NSDictionary *data){
            if(result){
                [Util showAlertView:nil message:@"경기에 불참하기로 하였습니다"];
                joinMatchButtonSelected = NO;
                notJoinMatchButtonSelected = YES;
                [self.joinMatchButton setSelected:NO];
                [self.notJoinMatchButton setSelected:YES];
            }else{
                NSLog(@"error to join match in detail match");
                [Util showErrorAlertView:nil message:@"불참 메세지를 보내는데 실패했습니다"];
            }
            
            [loadingView stopLoading];
        }];
    }
}

@end
