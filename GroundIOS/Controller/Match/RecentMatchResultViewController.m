//
//  RecentMatchResultViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "RecentMatchResultViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "MatchDataController.h"
#import "Match.h"

#import "GroundClient.h"

#import "Util.h"
#import "NSDate+Utils.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation RecentMatchResultViewController{
    MatchDataController *recentMatchDataController;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.competitorTeamHint = [[TeamHint alloc] init];
    self.match = [[Match alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    recentMatchDataController = [[MatchDataController alloc] init];
    [self getRecentMatchList];
}

- (void)getRecentMatchList
{
    LoadingView *loadingView = [LoadingView startLoading:@"최근 경기 결과를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getMatchHistory:self.competitorTeamHint.teamId lastMatchId:self.match.matchId callback:^(BOOL result, NSDictionary *data){
        if(result){
            // Tracking - 지난경기 정보 열람
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match_team" action:@"records" label:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] value:0] build]];
            
            NSArray *theMatchArray = [data objectForKey:@"historyList"];
            for(id object in theMatchArray){
                Match *theMatch = [[Match alloc] initMatchWithData:object];
                [recentMatchDataController addMatchWithMatch:theMatch];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"error to load the competitor's recent matches in recent match result");
            [Util showErrorAlertView:nil message:@"최근 기록을 불러오는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToShowRecentResult"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"COUNT: %d", [recentMatchDataController countOfList]);
    return [recentMatchDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentMatchListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Match *matchAtIndex = [recentMatchDataController objectInListAtIndex:indexPath.row];
    UILabel *matchInfoLabel = (UILabel *)[cell viewWithTag:490];
    UILabel *matchResultLabel = (UILabel *)[cell viewWithTag:491];
    NSInteger myScore;
    NSInteger competitorScore;
    NSString *result;
    
    if([matchAtIndex isHomeTeamWithTeam:self.teamHint.teamId]){
        myScore = matchAtIndex.homeScore;
        competitorScore = matchAtIndex.awayScore;
    }else{
        myScore = matchAtIndex.awayScore;
        competitorScore = matchAtIndex.homeScore;
    }
    if(myScore > competitorScore){
        result = @"WIN";
    }else if(myScore == competitorScore){
        result = @"DRAW";
    }else{
        result = @"LOSE";
    }
    
    matchInfoLabel.text = [NSString stringWithFormat:@"%@\n장소: %@\n상대: %@", [NSDate GeneralFormatDateFromNSTimeInterval:matchAtIndex.startTime format:1], matchAtIndex.groundName, matchAtIndex.awayTeamName ];
    matchResultLabel.text = [NSString stringWithFormat:@"%d:%d %@", myScore, competitorScore, result];
    
    return cell;
}

@end
