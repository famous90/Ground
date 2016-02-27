//
//  MyNewsViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define JOIN_TEAM           0
#define ACCEPT_MEMBER       1
#define DENY_MEMBER         2
#define DENY_TEAM           3
#define LEAVE_TEAM          4
#define REQUEST_MATCH       5
#define INVITE_TEAM         6
#define MATCHING_COMPLETED  7
#define DENY_MATCH          8
#define DO_SURVEY           9
#define SET_SCORE           10
#define ACCEPT_SCORE        11
#define SCORE_COMPLETED     12

#define REGISTER    0
#define REQUESTED   1
#define COMPLETED   2

#define GAME_TAB_MATCHLIST  1
#define TEAM_TAB_TEAMMAIN   3

#define HEIGHT_OF_FEED              79
#define HEIGHT_OF_WELCOME_MESSAGE   115

#import "MyNewsViewController.h"
#import "TeamTabbarParentViewController.h"
#import "DetailMatchViewController.h"
#import "SetMatchScoreViewController.h"
#import "MatchResultViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "FeedDataController.h"
#import "Feed.h"
#import "TeamHint.h"
#import "TeamInfo.h"
#import "Match.h"

#import "GroundClient.h"

#import "Util.h"
#import "ViewUtil.h"
#import "NSDate+Utils.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

static BOOL isMenuOn;

@implementation MyNewsViewController{
    BOOL isLastFeed;
    UITapGestureRecognizer *singleFingerTap;
    
    BOOL rightAfterRegister;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isMenuOn = NO;
    [self.coverView removeFromSuperview];
    [singleFingerTap removeTarget:self action:@selector(handleSingleTap:)];
    [self.tableView setScrollEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    rightAfterRegister = NO;
    self.lastFeedId = 0;
    isLastFeed = NO;
    self.newsDataController = [[FeedDataController alloc] init];
    [self getMyNews];
}

- (void)getMyNews
{
    LoadingView *loadingView = [LoadingView startLoading:@"소식들을 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getFeedList:self.lastFeedId callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *feedList = [data objectForKey:@"feedList"];
            for(id feed in feedList){
                Feed *theFeed = [[Feed alloc] initFeedWithData:feed];
                [self.newsDataController addMyNewsWithNews:theFeed];
            }
            if (self.lastFeedId == [self.newsDataController getBottomFeedId]) {
                isLastFeed = YES;
            }else{
                self.lastFeedId = [self.newsDataController getBottomFeedId];
            }
            
            if (self.lastFeedId == 0) {
                rightAfterRegister = YES;
            }
            
            [self.tableView reloadData];
        }else{
            NSLog(@"load my news error");
            [Util showAlertView:nil message:@"나의 소식을 불러오는데 실패했습니다.\n다시 시도해 주세요.\n불편을 드려 죄송합니다."];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu slide implementation Methods
- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    [self doMenuSlideBack];
}

- (void)doMenuSlide
{
    isMenuOn = [_myNewsParentViewController slide];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.coverView = [[UIView alloc] initWithFrame:screenRect];
    [self.coverView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.coverView addGestureRecognizer:singleFingerTap];
    [self.view addSubview:self.coverView];
    [self.tableView setScrollEnabled:NO];
}

- (void)doMenuSlideBack
{
    isMenuOn = [_myNewsParentViewController slideBack];
    [self.coverView removeFromSuperview];
    [self.tableView setScrollEnabled:YES];
}

#pragma mark -
#pragma mark - IBAction Methods
- (IBAction)slide:(id)sender
{
    if(!isMenuOn){
        [self doMenuSlide];
    }else{
        [self doMenuSlideBack];
    }
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (rightAfterRegister) {
        return 1;
        
    }else return [self.newsDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!rightAfterRegister) {
        static NSString *CellIdentifier = @"FeedCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Feed *feedAtIndex = [self.newsDataController objectInListAtIndex:indexPath.row];
        UIImageView *feedIconImageView = (UIImageView *)[cell viewWithTag:200];
        UILabel *feedDateLabel = (UILabel *)[cell viewWithTag:201];
        UILabel *feedTeamNameLabel = (UILabel *)[cell viewWithTag:202];
        UILabel *feedContentLabel = (UILabel *)[cell viewWithTag:203];
        UIImageView *feedTeamLabelBgImageView = (UIImageView *)[cell viewWithTag:204];
        UIImageView *feedTeamLabelBgFrontImageView = (UIImageView *)[cell viewWithTag:205];
        
        NSArray *feedIconImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"registered_icon"], [UIImage imageNamed:@"request_icon"], [UIImage imageNamed:@"complete_icon"], nil];
        NSString *feedTeamName;
        NSString *feedContent;
        NSInteger iconImageNumber = 0;
        
        switch (feedAtIndex.type) {
            case JOIN_TEAM:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 님이 %@ 팀에서 함께 뛰고 싶어합니다", feedAtIndex.userName, feedAtIndex.teamName];
                iconImageNumber = REQUESTED;
                break;
            }
            case ACCEPT_MEMBER:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 님이 %@ 팀의 일원이 되었습니다", feedAtIndex.userName, feedAtIndex.teamName];
                iconImageNumber = REGISTER;
                break;
            }
            case DENY_MEMBER:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀은 %@ 님을 팀원으로 받아들이기 어렵습니다", feedAtIndex.teamName, feedAtIndex.userName];
                iconImageNumber = COMPLETED;
                break;
            }
            case DENY_TEAM:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 님이 %@ 팀의 초대를 거절하였습니다", feedAtIndex.userName, feedAtIndex.teamName];
                iconImageNumber = COMPLETED;
                break;
            }
            case LEAVE_TEAM:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 님이 %@ 팀에서 나갔습니다", feedAtIndex.userName, feedAtIndex.teamName];
                iconImageNumber = COMPLETED;
                break;
            }
            case REQUEST_MATCH:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀에서 %@ 팀으로 경기 요청이 들어왔습니다", feedAtIndex.teamName, feedAtIndex.requestedTeamName];
                iconImageNumber = REQUESTED;
                break;
            }
            case INVITE_TEAM:{
                feedTeamName = feedAtIndex.requestedTeamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀이 %@ 팀에 경기 초대를 하였습니다", feedAtIndex.teamName, feedAtIndex.requestedTeamName];
                iconImageNumber = REQUESTED;
                break;
            }
            case MATCHING_COMPLETED:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀과 %@ 팀의 경기가 등록되었습니다", feedAtIndex.homeTeamName, feedAtIndex.awayTeamName];
                iconImageNumber = REGISTER;
                break;
            }
            case DENY_MATCH:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀에서 %@팀의 경기요청을 거절하였습니다", feedAtIndex.teamName, feedAtIndex.requestedTeamName];
                iconImageNumber = COMPLETED;
                break;
            }
            case DO_SURVEY:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀에서 경기 참가를 조사하고 있습니다", feedAtIndex.teamName];
                iconImageNumber = COMPLETED;
                break;
            }
            case SET_SCORE:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀의 경기 결과를 입력해주세요", feedAtIndex.teamName];
                iconImageNumber = REQUESTED;
                break;
            }
            case ACCEPT_SCORE:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀의 경기 결과가 입력되었습니다\n결과를 수락 또는 수정해주세요", feedAtIndex.teamName];
                iconImageNumber = REQUESTED;
                break;
            }
            case SCORE_COMPLETED:{
                feedTeamName = feedAtIndex.teamName;
                feedContent = [NSString stringWithFormat:@"%@ 팀의 경기 결과가 최종 입력되었습니다", feedAtIndex.teamName];
                iconImageNumber = REGISTER;
                break;
            }
            default :
                break;
        }
        feedContentLabel.text = feedContent;
        [feedContentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [feedContentLabel sizeToFit];
        CGRect newLabelFrame = feedTeamNameLabel.frame;
        CGRect newLabelBgFrame = feedTeamLabelBgImageView.frame;
        CGRect newLabelFrontBgFrame = feedTeamLabelBgFrontImageView.frame;
        CGSize newSize = [feedTeamName sizeWithFont:UIFontHelveticaBoldWithSize(13)];
        newLabelFrame.size.width = newSize.width;
        newLabelFrame.origin.x = self.view.frame.size.width - (newSize.width + 17);
        newLabelBgFrame.size.width = newSize.width + 17;
        newLabelBgFrame.origin.x = self.view.frame.size.width - (newSize.width + 17);
        newLabelFrontBgFrame.origin.x = self.view.frame.size.width - (newSize.width + 17 + feedTeamLabelBgFrontImageView.frame.size.width);
        
        feedTeamLabelBgImageView.frame = newLabelBgFrame;
        feedTeamLabelBgFrontImageView.frame = newLabelFrontBgFrame;
        feedTeamNameLabel.frame = newLabelFrame;
        
        feedDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:feedAtIndex.createdAt format:13];
        feedTeamNameLabel.text = feedTeamName;
        [feedTeamNameLabel setTextAlignment:NSTextAlignmentCenter];
        feedIconImageView.image = [feedIconImageArray objectAtIndex:iconImageNumber];
             
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"RightAfterRegisterCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((isLastFeed == NO) && (indexPath.row == [self.newsDataController countOfList] - 1)) {
        [self getMyNews];
    }
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (rightAfterRegister) {
        return HEIGHT_OF_WELCOME_MESSAGE;
    }else return HEIGHT_OF_FEED;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (!rightAfterRegister) {
        LoadingView *loadingView = [LoadingView startLoading:@"해당 페이지로 이동 중입니다" parentView:self.view];
        
        Feed *theFeed = [self.newsDataController objectInListAtIndex:indexPath.row];
        
        [[GroundClient getInstance] getTeamHintWithTeamId:theFeed.teamId callback:^(BOOL result, NSDictionary *data){
            if (result) {
                
                TeamHint *theTeamHint = [[TeamHint alloc] initWithTeamData:[data objectForKey:@"teamHint"]];
                [self selectPassingPageForDidSelectRowAtIndexPath:indexPath withFeed:theFeed withTeamHint:theTeamHint];
                
            }else{
                
                NSLog(@"error to load team hint in my news");
                [Util showErrorAlertView:nil message:@"페이지 정보를 불러오는데 실패하였습니다"];
                
            }
            
            [loadingView stopLoading];
        }];
    }
}

- (void)selectPassingPageForDidSelectRowAtIndexPath:(NSIndexPath *)indexPath withFeed:(Feed *)theFeed withTeamHint:(TeamHint *)theTeamHint
{
    // Tracking - 뉴스피드 클릭
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"feed" action:@"feed_type" label:[NSString stringWithFormat:@"%d", theFeed.type] value:[NSNumber numberWithInt:1]] build]];
    
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    
    // go to TEAM INFO
    if ((theFeed.type == JOIN_TEAM)||(theFeed.type == ACCEPT_MEMBER)||(theFeed.type == DENY_MEMBER)) {
        
        TeamTabbarParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
        childViewController.user = self.user;
        childViewController.teamHint = theTeamHint;
        childViewController.tabbarSelectedIndex = TEAM_TAB_TEAMMAIN;
        [self presentViewController:childViewController animated:YES completion:nil];
        
    }else if ((theFeed.type == LEAVE_TEAM)||(theFeed.type == DENY_TEAM)){
        
        
    // go to DETAIL MATCH
    }else if ((theFeed.type == REQUEST_MATCH)||(theFeed.type == INVITE_TEAM)||(theFeed.type == MATCHING_COMPLETED)||(theFeed.type == DO_SURVEY)){
        
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
        DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = theTeamHint;
        [childViewController.match setMatchId:theFeed.matchId];
        [self presentViewController:navController animated:YES completion:nil];
        
    // go to MATCH LIST
    }else if (theFeed.type == DENY_MATCH){
        
        TeamTabbarParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
        childViewController.user = self.user;
        childViewController.teamHint = theTeamHint;
        childViewController.tabbarSelectedIndex = GAME_TAB_MATCHLIST;
        [self presentViewController:childViewController animated:YES completion:nil];
        
    // go to SET SCORE
    }else if ((theFeed.type == SET_SCORE)||(theFeed.type == ACCEPT_SCORE)){
        
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SetMatchScoreNavigationViewController"];
        SetMatchScoreViewController *childViewController = (SetMatchScoreViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = theTeamHint;
        [childViewController.match setMatchId:theFeed.matchId];
        [self presentViewController:navController animated:YES completion:nil];
        
    // go to MATCH RESULT
    }else if (theFeed.type == SCORE_COMPLETED){
        
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MatchResultNavigationViewController"];
        MatchResultViewController *childViewController = (MatchResultViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = theTeamHint;
        [childViewController.match setMatchId:theFeed.matchId];
        [self presentViewController:navController animated:YES completion:nil];
        
    }
}

@end
