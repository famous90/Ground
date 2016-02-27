//
//  SearchGroundForNewMatchViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 26..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define SEARCH_RESULT_GROUND_SECTION  0
#define REGISTER_NEW_GTOUND_SECTION   1
#define PADDING 9.0

#import "SearchGroundForNewMatchViewController.h"
#import "MakeMatchViewController.h"
#import "MapViewController.h"
#import "LoadingView.h"

#import "Ground.h"

#import "GroundClient.h"
#import "Config.h"

#import "Util.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation SearchGroundForNewMatchViewController{
    NSMutableArray *searchResults;
}

- (void)viewDidLayoutSubviews
{
    self.navigationItem.rightBarButtonItem = nil;
    
    UIImageView *tableViewBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailMatch_searchGround_bg_icon"]];
    tableViewBgView.contentMode = UIViewContentModeCenter;
    [tableViewBgView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tableViewBgView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    searchResults = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - Table View Data Source Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([searchResults count]) {
        return 2;
    }else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([searchResults count] && (section == SEARCH_RESULT_GROUND_SECTION)) {
        if(tableView == self.searchDisplayController.searchResultsTableView){
            return [searchResults count];
        }else return 0;
    }else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([searchResults count] && (indexPath.section == SEARCH_RESULT_GROUND_SECTION)) {
        static NSString *CellIdentifier = @"SearchGroundForMatchCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Ground *theGround = [searchResults objectAtIndex:indexPath.row];
        if(tableView == self.searchDisplayController.searchResultsTableView){
            UILabel *searchResultGroundNameLabel = (UILabel *)[cell viewWithTag:4250];
            UILabel *searchResultGroundAddressLabel = (UILabel *)[cell viewWithTag:4251];
            searchResultGroundNameLabel.text = theGround.name;
            if (theGround.address != (id)[NSNull null]) {
                searchResultGroundAddressLabel.text = theGround.address;
            }else searchResultGroundAddressLabel.hidden = YES;
        }
    }else{
        static NSString *CellIdentifier = @"RegisterNewGroundCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToSearchGround"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table View Delegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([searchResults count] && (indexPath.section == SEARCH_RESULT_GROUND_SECTION)) {
        Ground *theGround = [searchResults objectAtIndex:indexPath.row];
        [self.makeMatchViewController setGround:theGround];
        [self.navigationController popViewControllerAnimated:YES];
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"운동장 선택" message:@"이 운동장을 선택하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
//        UIView *mapView = [[MTMapView alloc] initWithFrame:CGRectMake(PADDING, PADDING, 260, 300)];
////        self.mapView = [[MTMapView alloc] initWithFrame:CGRectMake(1, 1, 258, 98)];
//        [MTMapView setMapTilePersistentCacheEnabled:YES];
//        [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
//        [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:self.poiItem.mapPoint.mapPointGeo] zoomLevel:DAUM_MAP_ZOOM_LEVEL animated:YES];
//        [self.mapView addPOIItem:self.poiItem];
//        [alertView addSubview:mapView];
//        [alertView show];
    }else{
        [self selectAddNewGround];
    }
}

- (void)selectAddNewGround
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jet_Storyboard" bundle:nil];
    MapViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    childViewController.groundTag = 1;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - Search Display Delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchResults removeAllObjects];
    
    LoadingView *loadingView = [LoadingView startLoading:@"검색 결과를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] searchGround:searchString callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *theGroundArray = [data objectForKey:@"groundList"];
            for(id object in theGroundArray){
                Ground *theGround = [[Ground alloc] initGroundWithData:object];
                [searchResults addObject:theGround];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }else{
            NSLog(@"search ground error in make new match");
        }
        
        [loadingView stopLoading];
    }];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchResults removeAllObjects];

}

@end
