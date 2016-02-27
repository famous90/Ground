//
//  MatchsViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define HOME_ONLY           0
#define INVITE              1
#define REQUEST             2
#define MATCHING_COMPLETED  3
#define READY_SCORE         4
#define HOME_SCORE          5
#define AWAY_SCORE          6
#define SCORE_COMPLETED     7

#define COMPLETED_MATCH_SECTION 0
#define RESULT_READY_SECTION    1
#define SCORE_COMPLETED_SECTION 2

#define HOME_SECTION    0
#define AWAY_SECTION    1

#define HEIGHT_OF_MATCH         63
#define HEIGHT_OF_PAST_MATCH    55
#define HEIGHT_OF_MAKING_MATCH  73
#define HEIGHT_OF_NO_MATCH      150

#import "MatchsViewController.h"
#import "MakeMatchViewController.h"
#import "DetailMatchViewController.h"
#import "SetMatchScoreViewController.h"
#import "MatchResultViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "Match.h"
#import "MatchDataController.h"

#import "GroundClient.h"

#import "Util.h"
#import "NSDate+Utils.h"
#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

static BOOL isMenuOn;

@implementation MatchsViewController{
    BOOL matchCompleteListTapped;
    
//    BOOL isManager;
    
    NSInteger matchHistoryCur;
    BOOL isLastMatchHistory;
    BOOL loadFromGetMatchList;
    
    MatchDataController *completeMatchDataController;
    MatchDataController *resultReadyMatchDataController;
    MatchDataController *pastMatchDataController;
    
    MatchDataController *homeMatchDataController;
    MatchDataController *awayMatchDataController;
    
    MatchDataController *matchDataController;
    
    NSMutableArray *completeMatchList;
    NSMutableArray *completeMatchSectionList;

    NSMutableArray *makingMatchList;
    NSMutableArray *makingMatchSectionList;

    UITapGestureRecognizer *singleFingerTap;

//    UIView *noDataView;
    LoadingView *loadingView;
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
    
    [self showCompleteMatchList];
//    [self setTableViewBackGroundForNoData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    matchHistoryCur = INT32_MAX;
    isLastMatchHistory = NO;
    
    completeMatchDataController = [[MatchDataController alloc] init];
    resultReadyMatchDataController = [[MatchDataController alloc] init];
    pastMatchDataController = [[MatchDataController alloc] init];
    homeMatchDataController = [[MatchDataController alloc] init];
    awayMatchDataController = [[MatchDataController alloc] init];
    matchDataController = [[MatchDataController alloc] init];
    
    [self getMatchList];
}

- (void)getMatchList
{
    loadingView = [LoadingView startLoading:@"경기 목록을 불러오고 있습니다" parentView:self.tableView];
    
    [[GroundClient getInstance] getMatchList:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if (result) {
            NSArray *theMatchList = [data objectForKey:@"matchList"];
            for( id object in theMatchList ){
                Match *theMatch = [[Match alloc] initMatchWithData:object];
                [matchDataController addMatchWithMatch:theMatch];
            }
        }else{
            NSLog(@"error to load match list in match list");
            [Util showErrorAlertView:nil message:@"경기 정보를 불러오는데 실패했습니다"];

        }
        
        loadFromGetMatchList = YES;
        [self getMatchHistoryList];
    }];
}

- (void)getMatchHistoryList
{
    [[GroundClient getInstance] getMatchHistory:self.teamHint.teamId lastMatchId:matchHistoryCur callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *theMatchArray = [data objectForKey:@"matchList"];
            for(id object in theMatchArray){
                Match *theMatch = [[Match alloc] initMatchWithData:object];
                [pastMatchDataController addMatchWithMatch:theMatch];
            }
            [pastMatchDataController sortMatchListByDate];
//            if([pastMatchDataController countOfList]){
//                matchHistroyCur = [[pastMatchDataController objectInListAtIndex:0] matchId];
//            }

            if (matchHistoryCur == [pastMatchDataController getBottomMatchId]) {
                isLastMatchHistory = YES;
            }else{
                matchHistoryCur = [pastMatchDataController getBottomMatchId];
            }

        }else{
            NSLog(@"error to load match history list in match list");
            [Util showErrorAlertView:nil message:@"지난 경기를 불러오는데 실패했습니다"];
        }
        
        [self divideMatchList];
    }];
}

- (void)divideMatchList
{
    if (loadFromGetMatchList) {
        [completeMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:MATCHING_COMPLETED]];
        if (self.teamHint.isManaged) {
            [resultReadyMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:READY_SCORE]];
            [resultReadyMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:HOME_SCORE]];
            [resultReadyMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:AWAY_SCORE]];
            
            [resultReadyMatchDataController sortMatchListByDate];
        }
        [completeMatchDataController sortMatchListByDate];
        
        [homeMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:HOME_ONLY]];
        [homeMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:INVITE homeTeamId:self.teamHint.teamId]];
        [homeMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:REQUEST homeTeamId:self.teamHint.teamId]];
        [awayMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:INVITE awayTeamId:self.teamHint.teamId]];
        [awayMatchDataController addMatchListWithMatchList:[matchDataController matchListWithStatus:REQUEST awayTeamId:self.teamHint.teamId]];
        
        [homeMatchDataController sortMatchListByDate];
        [awayMatchDataController sortMatchListByDate];
        
    }
    [pastMatchDataController sortMatchListByDate];
    
    [self makeMatchList];
}

- (void)makeMatchList
{
    if (loadFromGetMatchList) {
        makingMatchList = [[NSMutableArray alloc] init];
        makingMatchSectionList = [[NSMutableArray alloc] init];
        
        if([homeMatchDataController countOfList]){
            [makingMatchList addObject:homeMatchDataController];
            [makingMatchSectionList addObject:[NSNumber numberWithInt:HOME_SECTION]];
        }
        if([awayMatchDataController countOfList]){
            [makingMatchList addObject:awayMatchDataController];
            [makingMatchSectionList addObject:[NSNumber numberWithInt:AWAY_SECTION]];
        }
    }
    
    completeMatchList = [[NSMutableArray alloc] init];
    completeMatchSectionList = [[NSMutableArray alloc] init];
    
    if([completeMatchDataController countOfList]){
        [completeMatchList addObject:completeMatchDataController];
        [completeMatchSectionList addObject:[NSNumber numberWithInt:COMPLETED_MATCH_SECTION]];
    }
    if([resultReadyMatchDataController countOfList]){
        [completeMatchList addObject:resultReadyMatchDataController];
        [completeMatchSectionList addObject:[NSNumber numberWithInt:RESULT_READY_SECTION]];
    }
    if([pastMatchDataController countOfList]){
        [completeMatchList addObject:pastMatchDataController];
        [completeMatchSectionList addObject:[NSNumber numberWithInt:SCORE_COMPLETED_SECTION]];
    }
    
    [self.tableView reloadData];
    [loadingView stopLoading];
}

//- (void)setTableViewBackGroundForNoData
//{
//    noDataView = [[UIView alloc] init];
//    [noDataView setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
//    [noDataLabel setFont:UIFontHelveticaBoldWithSize(15)];
//    [noDataLabel setTextColor:UIColorFromRGB(0xe2e2e2)];
//    [noDataLabel setNumberOfLines:1];
//    [noDataLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [noDataLabel setShadowColor:[UIColor lightTextColor]];
//    [noDataLabel setBackgroundColor:[UIColor clearColor]];
//    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
//    [noDataLabel setText:@"등록된 경기가 없습니다"];
//    
//    [noDataView setHidden:YES];
//    [noDataView addSubview:noDataLabel];
//    [self.tableView insertSubview:noDataView belowSubview:self.tableView];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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
    [self.tableView setScrollEnabled:NO];
}

- (void)doMenuSlideBack
{
    isMenuOn = [_teamTabbarParentViewController slideBack];
    [singleFingerTap removeTarget:self action:@selector(handleSingleTap:)];
    [self.coverView removeFromSuperview];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.tableView setScrollEnabled:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (matchCompleteListTapped) {
        if ([completeMatchList count]) {
            return [completeMatchList count];
            
        }else{
            return 1;
        }
        
    }else{
        if ([makingMatchList count]) {
            return [makingMatchList count];
            
        }else{
            return 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (matchCompleteListTapped) {
        if ([completeMatchList count]) {
            return [[completeMatchList objectAtIndex:section] countOfList];
            
        }else{
            return 1;
        }
        
    }else{
        if ([makingMatchList count]) {
            return [[makingMatchList objectAtIndex:section] countOfList];
            
        }else{
            return 1;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (matchCompleteListTapped) {
        if ([completeMatchList count]) {
            NSMutableArray *CellIdentifierArray = [[NSMutableArray alloc] init];
            NSMutableArray *tagArray = [[NSMutableArray alloc] init];
            
            if([completeMatchDataController countOfList]){
                [CellIdentifierArray addObject:@"CompleteMatchListCell"];
                [tagArray addObject:[NSNumber numberWithInt:4400]];
            }
            if([resultReadyMatchDataController countOfList]){
                [CellIdentifierArray addObject:@"ResultReadyMatchListCell"];
                [tagArray addObject:[NSNumber numberWithInt:4420]];
            }
            if([pastMatchDataController countOfList]){
                [CellIdentifierArray addObject:@"PastMatchListCell"];
                [tagArray addObject:[NSNumber numberWithInt:4430]];
            }
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifierArray objectAtIndex:indexPath.section]];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.section]];
            }
            NSInteger tag = [[tagArray objectAtIndex:indexPath.section] integerValue];
            
            Match *matchAtIndex = [[completeMatchList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
            TeamHint *theTeam = self.teamHint;
            NSString *competitorName;
            if([matchAtIndex isHomeTeamWithTeam:theTeam.teamId]){
                competitorName = matchAtIndex.awayTeamName;
            }else{
                competitorName = matchAtIndex.homeTeamName;
            }
            
            switch ([[completeMatchSectionList objectAtIndex:indexPath.section] integerValue]) {
                case COMPLETED_MATCH_SECTION:
                {
                    UILabel *completeMatchDayLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *completeMatchDateLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *completeMatchTimeLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *completeMatchGroundLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *completeMatchCompetitiveLabel = (UILabel *)[cell viewWithTag:tag++];
                    //            UIView *completeMatchComepetitiveIconImageView = (UIView *)[cell viewWithTag:tag++];
                    
                    completeMatchDayLabel.text = [NSDate getWeekdayFromNSTimeInterval:matchAtIndex.startTime];
                    completeMatchDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:6];
                    completeMatchTimeLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:12];
                    completeMatchGroundLabel.text = matchAtIndex.groundName;
                    //            CGSize labelSize = [competitorName sizeWithFont:UIFontFixedFontWithSize(12)];
                    //            CGRect labelFrame = CGRectMake(self.view.frame.size.width - labelSize.width - 17, 24, labelSize.width, 14);
                    //            completeMatchCompetitiveLabel.frame = labelFrame;
                    completeMatchCompetitiveLabel.text = competitorName;
                    //            completeMatchCompetitiveLabel.font = UIFontFixedFontWithSize(12);
                    
                    //            CGRect imageFrame = completeMatchComepetitiveIconImageView.frame;
                    //            CGRect newImageFrame = CGRectMake(labelFrame.origin.x - 5 - imageFrame.size.width, imageFrame.origin.y, imageFrame.size.width, imageFrame.size.height);
                    //            completeMatchComepetitiveIconImageView.frame = newImageFrame;
                    
                    return cell;
                }
                case RESULT_READY_SECTION:
                {
                    UILabel *resultReadyMatchDayLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *resultReadyMatchDateLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *resultReadyMatchTimeLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *resultReadyMatchGroundLabel = (UILabel *)[cell viewWithTag:tag++];
                    UIImageView *resultReadyMatchIconImageView = (UIImageView *)[cell viewWithTag:tag++];
                    
                    resultReadyMatchDayLabel.text = [NSDate getWeekdayFromNSTimeInterval:matchAtIndex.startTime];
                    resultReadyMatchDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:6];
                    resultReadyMatchTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:12]];
                    resultReadyMatchGroundLabel.text = matchAtIndex.groundName;
                    resultReadyMatchIconImageView.image = [UIImage imageNamed:@"matchList_ready_icon"];
                    
                    return cell;
                }
                case SCORE_COMPLETED_SECTION:
                {
                    UILabel *pastMatchResultLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *pastMatchDateAndTimeLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *pastMatchCompetitiveNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *pastMatchMyTeamScoreLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *pastMatchCompetitiveTeamScoreLabel = (UILabel *)[cell viewWithTag:tag++];
                    
                    NSString *result;
                    NSInteger resultColor;
                    NSInteger myScore;
                    NSInteger competitorScore;
                    NSString *competitorName;
                    if([matchAtIndex isHomeTeamWithTeam:theTeam.teamId]){
                        myScore = matchAtIndex.homeScore;
                        competitorScore = matchAtIndex.awayScore;
                        competitorName = matchAtIndex.awayTeamName;
                    }else{
                        myScore = matchAtIndex.awayScore;
                        competitorScore = matchAtIndex.homeScore;
                        competitorName = matchAtIndex.homeTeamName;
                    }
                    if(myScore>competitorScore){
                        result = @"WIN";
                        resultColor = 0x0E6F49;
                    }else if(myScore == competitorScore){
                        result = @"DRAW";
                        resultColor = 0x8C8C8C;
                    }else{
                        result = @"LOSE";
                        resultColor = 0x474747;
                    }
                    pastMatchResultLabel.text = result;
                    pastMatchResultLabel.backgroundColor = UIColorFromRGB(resultColor);
                    pastMatchResultLabel.font = UIFontFixedFontWithSize(22);
                    pastMatchDateAndTimeLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:11];
                    pastMatchCompetitiveNameLabel.text = competitorName;
                    pastMatchMyTeamScoreLabel.text = [NSString stringWithFormat:@"%d", myScore];
                    pastMatchMyTeamScoreLabel.font = UIFontFixedFontWithSize(22);
                    pastMatchCompetitiveTeamScoreLabel.text = [NSString stringWithFormat:@"%d", competitorScore];
                    pastMatchCompetitiveTeamScoreLabel.font = UIFontFixedFontWithSize(22);
                    
                    return cell;
                }
                default:
                    return cell;
            }
            
        }else{
            static NSString *CellIdentifier = @"noMatchCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
        
    }else{
        if ([makingMatchList count]) {
            NSMutableArray *CellIdentifierArray = [[NSMutableArray alloc] init];
            NSMutableArray *tagArray = [[NSMutableArray alloc] init];
            
            if([homeMatchDataController countOfList]){
                [CellIdentifierArray addObject:@"UndecidedHomeMatchListCell"];
                [tagArray addObject:[NSNumber numberWithInt:4500]];
            }
            if([awayMatchDataController countOfList]){
                [CellIdentifierArray addObject:@"UndecidedAwayMatchListCell"];
                [tagArray addObject:[NSNumber numberWithInt:4510]];
            }
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifierArray objectAtIndex:indexPath.section]];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.section]];
            }
            
            NSInteger tag = [[tagArray objectAtIndex:indexPath.section] integerValue];
            Match *matchAtIndex = [[makingMatchList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
            TeamHint *theTeam = self.teamHint;
            NSString *competitiveTeamName;
            if([matchAtIndex isHomeTeamWithTeam:theTeam.teamId]){
                if (matchAtIndex.status != HOME_ONLY) {
                    competitiveTeamName = matchAtIndex.awayTeamName;
                }else{
                    competitiveTeamName = @"상대없음";
                }
            }else{
                competitiveTeamName = matchAtIndex.homeTeamName;
            }
            
            switch ([[makingMatchSectionList objectAtIndex:indexPath.section] integerValue]) {
                case HOME_SECTION:
                {
                    UILabel *homeMatchDayLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *homeMatchDateLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *homeMatchCompetitiveNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *homeMatchGroundNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *homeMatchStatusMessageLabel = (UILabel *)[cell viewWithTag:tag++];
                    UIImageView *homeMatchStatusIconImageView = (UIImageView *)[cell viewWithTag:tag++];
                    UILabel *homeMatchSectionNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UIImageView *homeMatchSectionBgImageView = (UIImageView *)[cell viewWithTag:tag++];
                    
                    homeMatchDayLabel.text = [NSDate getWeekdayFromNSTimeInterval:matchAtIndex.startTime];
                    homeMatchDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:6];
                    homeMatchCompetitiveNameLabel.text = competitiveTeamName;
                    homeMatchGroundNameLabel.text = matchAtIndex.groundName;
                    switch (matchAtIndex.status) {
                        case HOME_ONLY:{
                            homeMatchStatusMessageLabel.text = @"상대없음";
                            homeMatchStatusIconImageView.image = [UIImage imageNamed:@"matchList_noCompetitive_icon_white"];
                            break;
                        }
                        case REQUEST:{
                            homeMatchStatusMessageLabel.text = @"수락대기중";
                            homeMatchStatusIconImageView.image = [UIImage imageNamed:@"matchList_request_icon_white"];
                            break;
                        }
                        case INVITE:{
                            homeMatchStatusMessageLabel.text = @"요청함";
                            homeMatchStatusIconImageView.image = [UIImage imageNamed:@"matchList_waiting_icon_white"];
                            break;
                        }
                        default:
                            break;
                    }
                    if(indexPath.row != 0){
                        homeMatchSectionNameLabel.hidden = YES;
                        homeMatchSectionBgImageView.hidden = YES;
                    }
                    
                    return cell;
                }
                case AWAY_SECTION:
                {
                    UILabel *awayMatchDayLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *awayMatchDateLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *awayMatchCompetitiveNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *awayMatchGroundNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UILabel *awayMatchStatusMessageLabel = (UILabel *)[cell viewWithTag:tag++];
                    UIImageView *awayMatchStatusIconImageView = (UIImageView *)[cell viewWithTag:tag++];
                    UILabel *awayMatchSectionNameLabel = (UILabel *)[cell viewWithTag:tag++];
                    UIImageView *awayMatchSectionBgImageView = (UIImageView *)[cell viewWithTag:tag++];
                    
                    awayMatchDayLabel.text = [NSDate getWeekdayFromNSTimeInterval:matchAtIndex.startTime];
                    awayMatchDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:6];
                    awayMatchCompetitiveNameLabel.text = competitiveTeamName;
                    awayMatchGroundNameLabel.text = matchAtIndex.groundName;
                    switch (matchAtIndex.status) {
                        case REQUEST:{
                            awayMatchStatusMessageLabel.text = @"수락대기중";
                            awayMatchStatusIconImageView.image = [UIImage imageNamed:@"matchList_request_icon_black"];
                            break;
                        }
                        case INVITE:{
                            awayMatchStatusMessageLabel.text = @"요청들어옴";
                            awayMatchStatusIconImageView.image = [UIImage imageNamed:@"matchList_waiting_icon_black"];
                            break;
                        }
                        default:
                            break;
                    }
                    if(indexPath.row != 0){
                        awayMatchSectionNameLabel.hidden = YES;
                        awayMatchSectionBgImageView.hidden = YES;
                    }
                    
                    return cell;
                }
                default:
                    return cell;
            }
            
        }else{
            static NSString *CellIdentifier = @"noMatchCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((isLastMatchHistory == NO) && (matchCompleteListTapped && indexPath.section == SCORE_COMPLETED_SECTION && indexPath.row == [pastMatchDataController countOfList]-1) ) {
        loadFromGetMatchList = NO;
        [self getMatchHistoryList];
    }
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    UINavigationController *navController;
    
    if (matchCompleteListTapped) {
        Match *matchAtIndex = [[completeMatchList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
        
        // COMPLETE MATCH Selected
        if([[completeMatchSectionList objectAtIndex:indexPath.section] integerValue] == COMPLETED_MATCH_SECTION){
            navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
            DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
            childViewController.user = self.user;
            childViewController.teamHint = self.teamHint;
            childViewController.match = matchAtIndex;
            childViewController.pageOriginType = VIEW_FROM_MATCH_LIST;
            
            // READY TO RESULT MATCH Selected
        }else if([[completeMatchSectionList objectAtIndex:indexPath.section] integerValue] == RESULT_READY_SECTION){
            navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SetMatchScoreNavigationViewController"];
            SetMatchScoreViewController *childViewController = (SetMatchScoreViewController *)[navController topViewController];
            childViewController.user = self.user;
            childViewController.teamHint = self.teamHint;
            childViewController.match = matchAtIndex;
            
            // MATCH RESULT Selected
        }else{
            navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MatchResultNavigationViewController"];
            MatchResultViewController *childViewController = (MatchResultViewController *)[navController topViewController];
            childViewController.user = self.user;
            childViewController.teamHint = self.teamHint;
            childViewController.match = matchAtIndex;
        }

    }else{
        Match *matchAtIndex = [[makingMatchList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
        navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
        DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.match = matchAtIndex;
        childViewController.pageOriginType = VIEW_FROM_MATCH_LIST;
        
    }
    navController.hidesBottomBarWhenPushed = YES;
    [self presentViewController:navController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionRowHeightArray = [[NSMutableArray alloc] init];

    if (matchCompleteListTapped) {
        if([completeMatchDataController countOfList]){
            [sectionRowHeightArray addObject:[NSNumber numberWithFloat:HEIGHT_OF_MATCH]];
        }
        if([resultReadyMatchDataController countOfList]){
            [sectionRowHeightArray addObject:[NSNumber numberWithFloat:HEIGHT_OF_MATCH]];
        }
        if([pastMatchDataController countOfList]){
            [sectionRowHeightArray addObject:[NSNumber numberWithFloat:HEIGHT_OF_PAST_MATCH]];
        }
    }else{
        if ([homeMatchDataController countOfList]) {
            [sectionRowHeightArray addObject:[NSNumber numberWithFloat:HEIGHT_OF_MAKING_MATCH]];
        }
        if ([awayMatchDataController countOfList]) {
            [sectionRowHeightArray addObject:[NSNumber numberWithFloat:HEIGHT_OF_MAKING_MATCH]];
        }
    }
    
    if ([sectionRowHeightArray count]) {
        return [[sectionRowHeightArray objectAtIndex:indexPath.section] floatValue];
    }else{
        return HEIGHT_OF_NO_MATCH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionHeaderHeightArray = [[NSMutableArray alloc] init];
    
    if (matchCompleteListTapped) {
        if([completeMatchDataController countOfList]){
            [sectionHeaderHeightArray addObject:[NSNumber numberWithInteger:2]];
        }
        if([resultReadyMatchDataController countOfList]){
            [sectionHeaderHeightArray addObject:[NSNumber numberWithInteger:0]];
        }
        if([pastMatchDataController countOfList]){
            [sectionHeaderHeightArray addObject:[NSNumber numberWithInteger:0]];
        }

    }else{
        if ([homeMatchDataController countOfList]) {
            [sectionHeaderHeightArray addObject:[NSNumber numberWithFloat:2.0f]];
        }
        if ([awayMatchDataController countOfList]) {
            [sectionHeaderHeightArray addObject:[NSNumber numberWithFloat:2.0f]];
        }
    }

    if ([sectionHeaderHeightArray count]) {
        return [[sectionHeaderHeightArray objectAtIndex:section] integerValue];
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (matchCompleteListTapped) {
        if (section == 0) {
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
            headerImageView.image = [UIImage imageNamed:@"bar_line_black"];
            [tableHeaderView addSubview:headerImageView];
            return tableHeaderView;
        }
    }else{
        NSArray *sectionHeaderBarImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"bar_line_green"], [UIImage imageNamed:@"bar_line_black"], nil];
        if ([[makingMatchList objectAtIndex:section] countOfList]) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
            headerImageView.image = [sectionHeaderBarImageArray objectAtIndex:section];
            [headerView addSubview:headerImageView];
            
            return headerView;
        }
    }
    return nil;
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
    if ([[segue identifier] isEqualToString:@"CancelMakeNewMatch"]) {
    }
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnMakeNewMatch"]) {
    }
}

- (IBAction)matchListSelectButtonTapped:(id)sender
{
    LoadingView *switchLoadingView;
    
    // COMPLETE MATCH TAPPED
    if (matchCompleteListTapped && (sender == self.makingMatchListButton)) {
        
        switchLoadingView = [LoadingView startLoading:@"경기를 불러오고 있습니다" parentView:self.tableView];
        
        [self showMakingMatchList];
        
        [switchLoadingView stopLoading];

    // MAKING MATCH TAPPED
    }else if (!matchCompleteListTapped && (sender == self.completeMatchListButton)){

        switchLoadingView = [LoadingView startLoading:@"경기를 불러오고 있습니다" parentView:self.tableView];

        [self showCompleteMatchList];
        
        [switchLoadingView stopLoading];
    }
}

- (IBAction)makeNewMatchButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MakeMatchNavigationViewController"];
    MakeMatchViewController *childViewController = (MakeMatchViewController *)[navController topViewController];
    childViewController.matchsViewController = self;
    childViewController.user = self.user;
    childViewController.teamHint = self.teamHint;
    //        [childViewController setHidesBottomBarWhenPushed:YES];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Implementation Methods
- (void)showCompleteMatchList
{
    matchCompleteListTapped = YES;
    [self.completeMatchListButton setSelected:YES];
    [self.makingMatchListButton setSelected:NO];
    [self.tableView reloadData];
}

- (void)showMakingMatchList
{
    matchCompleteListTapped = NO;
    [self.completeMatchListButton setSelected:NO];
    [self.makingMatchListButton setSelected:YES];
    [self.tableView reloadData];
}

@end
