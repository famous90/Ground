//
//  SearchTeamForNewMatchViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define PADDING 9

#import "SearchTeamForNewMatchViewController.h"
#import "MakeMatchViewController.h"
#import "AwayTeamInfoInMatchViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "Team.h"
#import "TeamHint.h"
#import "TeamInfo.h"
#import "Match.h"
#import "TeamInfoDataController.h"
#import "MatchInfo.h"
#import "ImageDataController.h"

#import "GroundClient.h"

#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation SearchTeamForNewMatchViewController{

    TeamInfoDataController *searchTeamResultDataController;
    TeamInfoDataController *nearbyTeamResultDataController;
    ImageDataController *teamImageDataController;
    NSInteger joiningTeamId;
    NSIndexPath *theIndexPath;
    
    CLLocationManager *locationManager;
    BOOL isResultSearchTeamNearby;
}

- (void)viewDidLayoutSubviews
{
    UIImageView *tableViewBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailMatch_searchTeam_bg_icon"]];
    tableViewBgImageView.contentMode = UIViewContentModeCenter;
    [tableViewBgImageView setFrame:self.searchTeamTableView.frame];
    self.searchTeamTableView.backgroundView = tableViewBgImageView;

    NSString *viewTitle;
    if (self.originType == VIEW_FROM_MENU) {
        viewTitle = @"팀 찾기";
    }else if ((self.originType == VIEW_FROM_MAKING_NEW_MATCH) || (self.originType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM)){
        viewTitle = @"상대팀 찾기";
    }
    [self setTitle:viewTitle];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchTeamResultDataController = [[TeamInfoDataController alloc] init];
    nearbyTeamResultDataController = [[TeamInfoDataController alloc] init];
    teamImageDataController = [[ImageDataController alloc] init];
    theIndexPath = [[NSIndexPath alloc] init];
    
    self.distance = 5;
    
    isResultSearchTeamNearby = YES;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"CancelSearchTeamForMatch"]){
        if ((self.originType == VIEW_FROM_MAKING_NEW_MATCH) || (self.originType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM)) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (self.originType == VIEW_FROM_MENU){
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Table View Data Source Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [searchTeamResultDataController countOfList];
    }else return [nearbyTeamResultDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
    
        static NSString *SearchCellIdentifier = @"SearchTeamForMatchCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellIdentifier];
        }

        TeamInfo *theTeam = [searchTeamResultDataController objectInListAtIndex:indexPath.row];
        
        UIImageView *searchResultTeamImageView = (UIImageView *)[cell viewWithTag:4300];
        UILabel *searchResultTeamNameLabel = (UILabel *)[cell viewWithTag:4301];
        UIImage *teamImage;
        if ([theTeam.imageUrl isEqual:[NSNull null]]) {
            teamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
        }else{
            teamImage = [teamImageDataController imageWithId:theTeam.teamId];
        }
        searchResultTeamImageView.image = [ViewUtil circleMaskImageWithImage:teamImage];
        searchResultTeamNameLabel.text = theTeam.name;
        
    }else{
        
        static NSString *CellIdentifier = @"SearchTeamNearbyCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        TeamInfo *theTeam = [nearbyTeamResultDataController objectInListAtIndex:indexPath.row];
        
        UIImageView *searchResultTeamNearbyImageView = (UIImageView *)[cell viewWithTag:4310];
        UILabel *searchResultTeamNearbyNameLabel = (UILabel *)[cell viewWithTag:4311];
        UIImage *teamImage;
        if ([theTeam.imageUrl isEqual:[NSNull null]]) {
            teamImage = [UIImage imageNamed:@"detailMatch_noCompetitive_logo"];
        }else{
            teamImage = [teamImageDataController imageWithId:theTeam.teamId];
        }
        searchResultTeamNearbyImageView.image = [ViewUtil circleMaskImageWithImage:teamImage];
        searchResultTeamNearbyNameLabel.text = theTeam.name;
        
    }
    return cell;
}

#pragma mark - Table View Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TeamInfo *theTeam;
    if (isResultSearchTeamNearby) {
        theTeam = [nearbyTeamResultDataController objectInListAtIndex:indexPath.row];
    }else{
        theTeam = [searchTeamResultDataController objectInListAtIndex:indexPath.row];
    }
    

    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    AwayTeamInfoInMatchViewController *childViewController = (AwayTeamInfoInMatchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AwayTeamInfoInMatchView"];
//    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"AwayTeamInfoInMatchNavigationViewController"];
//    AwayTeamInfoInMatchViewController *childViewController = (AwayTeamInfoInMatchViewController *)[navController topViewController];
    
    childViewController.user = self.user;
    childViewController.teamHint = self.teamHint;
    childViewController.competitorTeamId = theTeam.teamId;
    childViewController.competitorTeamInfo = theTeam;
    childViewController.match.matchId = self.matchId;

    if (self.originType == VIEW_FROM_MAKING_NEW_MATCH) {
        
        childViewController.makeMatchViewController = _makeMatchViewController;
        childViewController.pageoOriginType = self.originType;
        [self.navigationController pushViewController:childViewController animated:YES];
//        _makeMatchViewController.competitiveTeamId = theTeam.teamId;        
//        [_makeMatchViewController.competitiveTeamNameLabel setText:theTeam.name];
//        [_makeMatchViewController.competitiveTeamNameLabel setTextColor:UIColorFromRGB(0xffffff)];
//        
//        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.originType == VIEW_FROM_MENU){
        
        childViewController.pageoOriginType = self.originType;
        [self.navigationController pushViewController:childViewController animated:YES];
        
    }else if (self.originType == VIEW_FROM_DETAIL_MATCH_INVITE_TEAM){
        
        childViewController.pageoOriginType = self.originType;
        [self.navigationController pushViewController:childViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - Search Display Delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    LoadingView *loadingView = [LoadingView startLoading:@"검색 결과를 불러오고 있습니다" parentView:self.view];
    
    isResultSearchTeamNearby = NO;
    [searchTeamResultDataController removeAllTeamList];
    [teamImageDataController removeAll];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[GroundClient getInstance] searchTeam:searchString callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *theTeamArray = [data objectForKey:@"teamList"];
            [self addSearchResultInListWithData:theTeamArray];
        }else{
            NSLog(@"search ground error in make new match");
        }
        
        [loadingView stopLoading];
    }];
    return YES;
}

- (void)addSearchResultInListWithData:(NSArray *)theData
{
    for(id object in theData){
        TeamInfo *theTeamInfo = [[TeamInfo alloc] initTeamInfoWithData:object];
        if (isResultSearchTeamNearby) {
            [nearbyTeamResultDataController addTeamInfoWithTeam:theTeamInfo];
        }else{
            [searchTeamResultDataController addTeamInfoWithTeam:theTeamInfo];
        }
        if (theTeamInfo.imageUrl != (id)[NSNull null]) {
            [[GroundClient getInstance] downloadProfileImage:theTeamInfo.imageUrl thumbnail:YES callback:^(BOOL result, NSDictionary *data){
                if (result) {
                    UIImage *theImage = [data objectForKey:@"image"];
                    [teamImageDataController addObjectWithImage:theImage withId:theTeamInfo.teamId];
                    if (isResultSearchTeamNearby) {
                        [self.tableView reloadData];
                    }else{
                        [self.searchDisplayController.searchResultsTableView reloadData];
                    }
                }else{
                    NSLog(@"error to load team image in search team for new match");
                }
            }];
        }
    }
    if (isResultSearchTeamNearby) {
        [self.tableView reloadData];
    }else{
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchTeamResultDataController removeAllTeamList];
    isResultSearchTeamNearby = YES;
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error to load my location in search team for new match");
//    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)newLocations
{
    CLLocation *currentLocation = [newLocations objectAtIndex:0];
    
    if (currentLocation != nil) {
        NSNumber *currentLatitude = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
        NSNumber *currentLongitude = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
        
        [locationManager stopUpdatingLocation];
        
        LoadingView *loadingView = [LoadingView startLoading:@"내 주변 팀을 불러오고 있습니다" parentView:self.view];
        
        [[GroundClient getInstance] searchTeamNearbyAtLatitude:currentLatitude longitude:currentLongitude distance:self.distance callback:^(BOOL result, NSDictionary *data){
            if (result) {
                NSArray *theDataArray = [data objectForKey:@"teamList"];
                [self addSearchResultInListWithData:theDataArray];
            }else{
                NSLog(@"error to search team nearby in search team for new match");
            }
            
            [loadingView stopLoading];
        }];
    }
//    [locationManager stopUpdatingLocation];
}

#pragma mark - IBAction Methods
- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelToShowCompetitiveInfo"]) {
    }
}

@end
