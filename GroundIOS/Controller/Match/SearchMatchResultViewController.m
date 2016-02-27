
//
//  SearchMatchResultViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 31..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

#define kPickerAnimationDuration    0.40
#define kDatePickerTag              4212

#define kTitleKey       @"title"
#define kContentKey     @"content"

#define kDateStartRow       0
#define kDateEndRow         1
#define kTimeStartRow       2
#define kTimeEndRow         3
#define kLocationRow        4
#define kSearchButtonRow    5

#define SEARCH_PARAM_SECTION        0
#define SEARCH_MATCH_BUTTON_SECTION 1
#define SEARCH_RESULT_SECTION       2

#define HEIGHT_OF_SEARCH_MATCH_LOCATION_ROW 45
#define HEIGHT_OF_SEARCH_MATCH_DATE_ROW     30
#define HEIGHT_OF_SEARCH_MATCH_BUTTON_ROW   40
#define HEIGHT_OF_SEARCH_MATCH_RESULT_ROW   63
#define HEIGHT_OF_SEARCH_MATCH_NO_RESULT    150

#import "SearchMatchResultViewController.h"
#import "DetailMatchViewController.h"
#import "MapViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "Match.h"
#import "SearchMatch.h"
#import "SearchMatchDataController.h"

#import "GroundClient.h"

#import "Util.h"
#import "NSDate+Utils.h"
#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

static NSString *kDateCellID = @"SearchDateCell";
static NSString *kDatePickerID = @"SearchPickerCell";
static NSString *kLocationCellID = @"SearchLocationCell";

static BOOL isMenuOn;

@implementation SearchMatchResultViewController{
    NSMutableDictionary *searchRow1;
    NSMutableDictionary *searchRow2;
    NSMutableDictionary *searchRow3;
    NSMutableDictionary *searchRow4;
    NSMutableDictionary *searchRow5;
    
    CLLocationManager *locationManager;
    BOOL firstDefaultSearch;

//    UIView *noDataView;
    LoadingView *searchMatchNearbyLoadingView;
    
    UITapGestureRecognizer *singleFingerTap;
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
    
    [self doMenuSlideBack];
    
    searchMatchNearbyLoadingView = [LoadingView startLoading:@"내 주변의 경기를 불러오고 있습니다" parentView:self.view];

    firstDefaultSearch = YES;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
    
    NSDate *now = [NSDate date];
    self.dataController = [[SearchMatchDataController alloc] init];
    self.indexPath = [[NSIndexPath alloc] init];
    self.selectedStartTime = [NSDate setDateTimeWithDate:now setHour:1 setMinute:0];
    self.selectedEndTime = [[NSDate setDateTimeWithDate:now setHour:23 setMinute:50] dateByAddingCalendarUnits:NSMonthCalendarUnit amount:1];
    self.distance = 5;
    
    [self setLocation];
    searchRow1 = [[NSMutableDictionary alloc] init];
    searchRow2 = [[NSMutableDictionary alloc] init];
    searchRow3 = [[NSMutableDictionary alloc] init];
    searchRow4 = [[NSMutableDictionary alloc] init];
    searchRow5 = [[NSMutableDictionary alloc] init];
    [self setDateFactorInTable];
    
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self setLocation];
}

- (void)setDateFactorInTable
{
    searchRow1 = [@{ kTitleKey : @"날짜",  kContentKey : self.selectedStartTime} mutableCopy];
    searchRow2 = [@{ kTitleKey : @" ",       kContentKey : self.selectedEndTime} mutableCopy];
    searchRow3 = [@{ kTitleKey : @"시간",  kContentKey : self.selectedStartTime} mutableCopy];
    searchRow4 = [@{ kTitleKey : @" ",       kContentKey : self.selectedEndTime} mutableCopy];
    searchRow5 = [@{ kTitleKey : @"지역",     kContentKey : self.searchLocation} mutableCopy];
    self.dataArray = @[searchRow1, searchRow2, searchRow3, searchRow4, searchRow5];
}

- (void)setLocation
{
    if (self.poiItem) {
        self.searchLocation = self.poiItem.itemName;
        self.searchLatitude = [NSNumber numberWithFloat:self.poiItem.mapPoint.mapPointGeo.latitude];
        self.searchLongitude = [NSNumber numberWithFloat:self.poiItem.mapPoint.mapPointGeo.longitude];
    }else{
        self.searchLocation = @"내위치";
        self.searchLatitude = [NSNumber numberWithFloat:37.469];
        self.searchLongitude = [NSNumber numberWithFloat:126.964];
    }
}

//- (void)setTableViewBackGroundForNoData
//{
//    noDataView = [[UIView alloc] init];
//    [noDataView setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
//    [noDataLabel setFont:UIFontHelveticaBoldWithSize(15)];
//    [noDataLabel setTextColor:UIColorFromRGB(0xe2e2e2)];
//    [noDataLabel setNumberOfLines:1];
//    [noDataLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [noDataLabel setShadowColor:[UIColor lightTextColor]];
//    [noDataLabel setBackgroundColor:[UIColor clearColor]];
//    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
//    [noDataLabel setText:@"주변 경기가 없습니다"];
//    
//    [noDataView setHidden:YES];
//    [noDataView addSubview:noDataLabel];
//    [self.tableView insertSubview:noDataView belowSubview:self.tableView];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark - UITable View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SEARCH_PARAM_SECTION) {
        
        if ([self hasInlineDatePicker]) {
            NSInteger numRows = self.dataArray.count;
            return ++numRows;
        }
        
        return self.dataArray.count;
        
    }else if(section == SEARCH_MATCH_BUTTON_SECTION){
        return 1;
    }else{
        
        if ([self.dataController countOfList]) {
            return [self.dataController countOfList];
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // INSERT PARAMETER to search match
    if (indexPath.section == SEARCH_PARAM_SECTION) {
        
        UITableViewCell *cell = nil;
        
        NSString *cellID = kLocationCellID;
        if ([self indexPathHasPicker:indexPath]) {
            cellID = kDatePickerID;
        }else if([self indexPathHasDate:indexPath]){
            cellID = kDateCellID;
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSInteger modelRow = indexPath.row;
        if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row) {
            modelRow--;
        }
        
        NSDictionary *itemData = self.dataArray[modelRow];
        
        UIImageView *searchMatchRowBarImageView = (UIImageView *)[cell viewWithTag:4215];
        searchMatchRowBarImageView.hidden = YES;
        
        // DATE & TIME section
        if ([cellID isEqualToString:kDateCellID]) {
            
            UILabel *searchMatchDateTitleLabel = (UILabel *)[cell viewWithTag:4210];
            UILabel *searchMatchDateLabel = (UILabel *)[cell viewWithTag:4211];
            
            searchMatchDateTitleLabel.text = [itemData valueForKey:kTitleKey];
            searchMatchDateLabel.text = [self getDateContent:indexPath];
            
        // LOCATION section
        }else if([cellID isEqualToString:kLocationCellID]){
            
            UILabel *searchMatchLocationTitleLabel = (UILabel *)[cell viewWithTag:4213];
            UILabel *searchMatchLocationLabel = (UILabel *)[cell viewWithTag:4214];
            searchMatchLocationTitleLabel.text = [itemData valueForKey:kTitleKey];
            searchMatchLocationLabel.text = [NSString stringWithFormat:@"%@ 근방 %dkm", [itemData valueForKey:kContentKey], self.distance];
            
        // DATE PICKER section
        }else if ([cellID isEqualToString:kDatePickerID]){
            
        }
        
        return cell;
        
    // SEARCH BUTTON section
    }else if(indexPath.section == SEARCH_MATCH_BUTTON_SECTION){
        static NSString *CellIdentifier = @"SearchMatchButtonCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
        
    // SEARCH RESULT section
    }else if(indexPath.section == SEARCH_RESULT_SECTION){
        
        if ([self.dataController countOfList]) {
            static NSString *CellIdentifier = @"SearchMatchResultCell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            SearchMatch *theSearchMatchAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
            UILabel *searchMatchDateLabel = (UILabel *)[cell viewWithTag:4200];
            UILabel *searchMatchDayLabel = (UILabel *)[cell viewWithTag:4201];
            UILabel *searchMatchTimeLabel = (UILabel *)[cell viewWithTag:4202];
            UILabel *searchMatchGroundNameLabel = (UILabel *)[cell viewWithTag:4203];
            UILabel *searchMatchCompetitiveNameLabel = (UILabel *)[cell viewWithTag:4204];
            UILabel *searchMatchDistanceLabel = (UILabel *)[cell viewWithTag:4205];
            UILabel *searchMatchCompetitiveTeamAgeLabel = (UILabel *)[cell viewWithTag:4206];
            UIImageView *searchMatchCompetitiveTeamPointImageView = (UIImageView *)[cell viewWithTag:4207];
            
            searchMatchDateLabel.text = [NSDate getWeekdayFromNSTimeInterval:theSearchMatchAtIndex.startTime];
            searchMatchDayLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:theSearchMatchAtIndex.startTime format:6];
            searchMatchTimeLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:theSearchMatchAtIndex.startTime format:12];
            searchMatchGroundNameLabel.text = theSearchMatchAtIndex.groundName;
            searchMatchCompetitiveNameLabel.text = theSearchMatchAtIndex.homeTeamName;
            searchMatchDistanceLabel.text = [NSString stringWithFormat:@"%dm", (int)([theSearchMatchAtIndex.distance floatValue]*1000)];
            
            //        searchMatchCompetitiveTeamAgeLabel.text = [NSString stringWithFormat:@"%.1f세", 29.5 ];
            searchMatchCompetitiveTeamAgeLabel.hidden = YES;
            searchMatchCompetitiveTeamPointImageView.hidden = YES;
            
            return cell;
            
        }else{
            static NSString *CellIdentifier = @"noSearchMatchCell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
        }
        
    }else return nil;
}

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:SEARCH_PARAM_SECTION]];
    
    if ([self hasPickerForIndexPath:indexPath]) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    BOOL before = NO;
    if ([self hasInlineDatePicker]) {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // if DATE PICKER is inserted, delete
    if ([self hasInlineDatePicker]) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:SEARCH_PARAM_SECTION]] withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked) {
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:SEARCH_PARAM_SECTION];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:SEARCH_PARAM_SECTION];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    NSInteger modelRow = indexPath.row;
    if ((self.datePickerIndexPath != nil) && (self.datePickerIndexPath.row <= indexPath.row)) {
        modelRow--;
    }
    
    if ((modelRow == kDateStartRow) || (modelRow == kDateEndRow)) {
        [self updateDatePickerWithDatePickerMode:UIDatePickerModeDate];
    }else if((modelRow == kTimeStartRow) || (modelRow == kTimeEndRow)){
        [self updateDatePickerWithDatePickerMode:UIDatePickerModeTime];
    }
}

- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = self.dataArray[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kContentKey] animated:YES];
    
    if (self.pickerView.superview == nil) {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        startFrame.origin.y = self.view.frame.size.height;
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        [UIView animateWithDuration:kPickerAnimationDuration
                         animations:^{
                             self.pickerView.frame = endFrame;
                         }
                         completion:^(BOOL finished){
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                             self.navigationItem.rightBarButtonItem.title = @"done";
        }];
    }
}


#pragma mark - UITable View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SEARCH_PARAM_SECTION) {
        
        NSInteger modelRow = indexPath.row;
        if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row) {
            modelRow--;
        }
        
        if ([self indexPathHasPicker:indexPath]) {
            return self.pickerCellRowHeight;
        }else if(modelRow == kLocationRow){
            return HEIGHT_OF_SEARCH_MATCH_LOCATION_ROW;
        }else return HEIGHT_OF_SEARCH_MATCH_DATE_ROW;
        
    }else if (indexPath.section == SEARCH_MATCH_BUTTON_SECTION)
        return HEIGHT_OF_SEARCH_MATCH_BUTTON_ROW;
    
    else{
        if ([self.dataController countOfList]) {
            return HEIGHT_OF_SEARCH_MATCH_RESULT_ROW;
            
        }else{
            return HEIGHT_OF_SEARCH_MATCH_NO_RESULT;
        }
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SEARCH_RESULT_SECTION/* && [self.dataController countOfList]*/) {
        return 23;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == SEARCH_RESULT_SECTION/* && [self.dataController countOfList]*/) {
        UIView *searchResultSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
        headerImageView.image = [UIImage imageNamed:@"bar_labelWithLine_green_upper"];
        [searchResultSectionView addSubview:headerImageView];
        UILabel *headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 120, 15)];
        [headerNameLabel setBackgroundColor:[UIColor clearColor]];
        headerNameLabel.text = @"경기검색 결과";
        headerNameLabel.font = UIFontFixedFontWithSize(12);
        headerNameLabel.textColor = UIColorFromRGB(0xffffff);
        headerNameLabel.textAlignment = NSTextAlignmentCenter;
        [searchResultSectionView addSubview:headerNameLabel];
        
        return searchResultSectionView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == SEARCH_PARAM_SECTION) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // DATE CELL Selected
        if (cell.reuseIdentifier == kDateCellID) {
            if (EMBEDDED_DATE_PICKER) {
                [self displayInlineDatePickerForRowAtIndexPath:indexPath];
            }else{
                [self displayExternalDatePickerForRowAtIndexPath:indexPath];
            }
            
        // LOCATION CELL Selected
        }else if (cell.reuseIdentifier == kLocationCellID) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jet_Storyboard" bundle:nil];
            MapViewController *childViewController = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            
            if (self.poiItem) {
                [childViewController setPoiItem:self.poiItem];
            }
            
            [childViewController setHidesBottomBarWhenPushed:YES];
            childViewController.groundTag = 2;
            [self.navigationController pushViewController:childViewController animated:YES];
        }
        
    // SEARCH RESULT CELL Selected
    }else if (indexPath.section == SEARCH_RESULT_SECTION){
        SearchMatch *searchMatchAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
        UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
        DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.match.matchId = searchMatchAtIndex.matchId;
        childViewController.pageOriginType = VIEW_FROM_SEARCH_MATCH;
        
        [self presentViewController:navController animated:YES completion:nil];
        
//        self.indexPath = indexPath;
//        [self showActionSheetViewWithMatch:[self.dataController objectInListAtIndex:indexPath.row]];
    }
}

- (void)showActionSheetViewWithMatch:(SearchMatch *)theMatch
{
//    NSString *sheetTitleString = @"\n\n\n\n\n\n\n";
//    UIView *sheetView = [[UIView alloc] init];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitleString
//                                                             delegate:self
//                                                    cancelButtonTitle:@"취소"
//                                               destructiveButtonTitle:@"경기 요청하기"
//                                                    otherButtonTitles:nil,nil];
//    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 320-40, 40)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = UIColorFromRGB(0x6d6d6d);
//    titleLabel.numberOfLines = 0;
//    titleLabel.font = [UIFont systemFontOfSize:18];
//    titleLabel.adjustsFontSizeToFitWidth = YES;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"경기 상세 정보";
//    titleLabel.frame = [ViewUtil height:titleLabel.text labelObject:titleLabel];
//    [sheetView addSubview:titleLabel];
//    
////    HOME TEAM IMAGE
////    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample.png"]];
////    [imageView setFrame:CGRectMake(320-100, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, 70, 70)];
////    [sheetView addSubview:imageView];
//    
//    UILabel *detailMatchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, 320-40, 40)];
//    detailMatchLabel.backgroundColor = [UIColor clearColor];
//    detailMatchLabel.textColor = UIColorFromRGB(0x6d6d6d);
//    detailMatchLabel.numberOfLines = 0;
//    detailMatchLabel.font = [UIFont boldSystemFontOfSize:15];
//    detailMatchLabel.adjustsFontSizeToFitWidth = YES;
//    NSString *start = [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.startTime format:7];
//    NSString *end = [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.endTime format:8];
//    detailMatchLabel.text = [NSString stringWithFormat: @"%@와 경기\n%@에서\n%@부터 %@까지", theMatch.homeTeamName, theMatch.groundName, start, end];
//    detailMatchLabel.frame = [ViewUtil height:detailMatchLabel.text labelObject:detailMatchLabel];
//    [sheetView addSubview:detailMatchLabel];
//    
//    [sheetView setFrame:CGRectMake(0, 0, 320, detailMatchLabel.frame.origin.y + detailMatchLabel.frame.size.height +10)];
//    [actionSheet addSubview:sheetView];
//    
//    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
//    [actionSheet showInView:appWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    switch (buttonIndex) {
//        case 0:{
//            LoadingView *loadingView = [LoadingView startLoading:@"경기 요청 중" parentView:self.view];
//            
//            SearchMatch *theSearchMatch = [self.dataController objectInListAtIndex:self.indexPath.row];
//            [[GroundClient getInstance] requestMatch:theSearchMatch.matchId hometeam:theSearchMatch.homeTeamId awayTeam:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
//                if(result){
////                    [self dismissViewControllerAnimated:YES completion:nil];
//                    [self.tabBarController setSelectedIndex:1];
//                }else{
//                    NSLog(@"error to request away match in search match");
//                    [Util showErrorAlertView:nil message:@"경기 요청에 실패했습니다"];
//                    self.indexPath = nil;
//                }
//                
//                [loadingView stopLoading];
//            }];
//            break;
//        }
//        case 1:{
//            self.indexPath = nil;
//            break;
//        }
//        default:
//            break;
//    }
}

#pragma mark - Utilities
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;

    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

- (void)updateDatePickerWithDatePickerMode:(UIDatePickerMode)mode
{
    if (self.datePickerIndexPath != nil) {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        
        if (targetedDatePicker != nil) {
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDatePickerMode:mode];
//            targetedDatePicker.minimumDate = [itemData valueForKey:kContentKey];
            [targetedDatePicker setMinuteInterval:10];
            [targetedDatePicker setDate:[itemData valueForKey:kContentKey] animated:NO];
        }
    }
}

- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row) {
        modelRow--;
    }
    
    if ((modelRow == kDateStartRow) || (modelRow == kDateEndRow) || (modelRow == kTimeStartRow) || (modelRow == kTimeEndRow)) {
        hasDate = YES;
    }
    return hasDate;
}

- (NSString *)getDateContent:(NSIndexPath *)indexPath
{
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row) {
        modelRow--;
    }
    
    NSString *dateContent = nil;
    NSDate *selectedDate = [self.dataArray[modelRow] valueForKey:kContentKey];
    NSTimeInterval selectedTimeInterval = [selectedDate timeIntervalSince1970];
    switch (modelRow) {
        case kDateStartRow:{
            dateContent = [NSString stringWithFormat:@"%@ 부터", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:11]];
            break;
        }
        case kDateEndRow:{
            dateContent = [NSString stringWithFormat:@"%@ 까지", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:11]];
            break;
        }
        case kTimeStartRow:{
            dateContent = [NSString stringWithFormat:@"%@ 부터", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:10]];
            break;
        }
        case kTimeEndRow:{
            dateContent = [NSString stringWithFormat:@"%@ 까지", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:10]];
            break;
        }
        default:
            break;
    }
    return dateContent;
}

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

#pragma mark - IBAction
- (IBAction)slide:(id)sender
{
    if(!isMenuOn){
        [self doMenuSlide];
    }else{
        [self doMenuSlideBack];
    }
}

- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    NSIndexPath *nextCellIndexPath = nil;
    
    if ([self hasInlineDatePicker]) {
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:SEARCH_PARAM_SECTION];
        nextCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row + 1 inSection:SEARCH_PARAM_SECTION];
    }else{
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
        nextCellIndexPath = [NSIndexPath indexPathForRow:targetedCellIndexPath.row + 1 inSection:SEARCH_PARAM_SECTION];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    NSDate *selectedDate = targetedDatePicker.date;
    NSTimeInterval selectedTimeInterval = [selectedDate timeIntervalSince1970];

    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:selectedDate forKey:kContentKey];
    
    UILabel *searchMatchDateLabel = (UILabel *)[cell viewWithTag:4211];
    
    NSInteger modelRow = targetedCellIndexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < targetedCellIndexPath.row) {
        modelRow--;
    }

    switch (modelRow) {
        case kDateStartRow:{
            searchMatchDateLabel.text = [NSString stringWithFormat:@"%@ 부터", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:11]];
            self.selectedStartTime = selectedDate;
            
            if ([selectedDate timeIntervalSince1970] > [self.selectedEndTime timeIntervalSince1970]) {
                UILabel *nextDateLabel = (UILabel *)[nextCell viewWithTag:4211];
                nextDateLabel.text = [NSString stringWithFormat:@"%@ 까지", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:11]];
                self.selectedEndTime = selectedDate;
            }
            
            break;
        }
        case kDateEndRow:{
            searchMatchDateLabel.text = [NSString stringWithFormat:@"%@ 까지", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:11]];
            self.selectedEndTime = selectedDate;
            break;
        }
        case kTimeStartRow:{
            searchMatchDateLabel.text = [NSString stringWithFormat:@"%@ 부터", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:10]];
            self.selectedStartTime = selectedDate;
            
            break;
        }
        case kTimeEndRow:{
            searchMatchDateLabel.text = [NSString stringWithFormat:@"%@ 까지", [NSDate GeneralFormatDateFromNSTimeInterval:selectedTimeInterval format:10]];
            self.selectedEndTime = selectedDate;
            break;
        }
        default:
            break;
    }
    [self setDateFactorInTable];
}

- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:kPickerAnimationDuration animations:^{
        self.pickerView.frame = pickerFrame;} completion:^(BOOL finished){
            [self.pickerView removeFromSuperview];
        }];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)searchMatchButtonTapped:(id)sender
{
    [self.dataController removeAllData];
    
    LoadingView *loadingView = [LoadingView startLoading:@"검색결과를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] searchMatchWithStartTime:[self.selectedStartTime timeIntervalSince1970] endTime:[self.selectedEndTime timeIntervalSince1970] latitude:self.searchLatitude longitude:self.searchLongitude distance:self.distance callback:^(BOOL result, NSDictionary *data){
        if (result) {
            NSArray *searchResultArray = [data objectForKey:@"matchList"];
            for( id object in searchResultArray ){
                SearchMatch *theSearchMatch = [[SearchMatch alloc] initSearchMatchWithData:object];
                [self.dataController addSearchMatchWithSearchMatch:theSearchMatch];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"error to search match in search match result");
            [Util showErrorAlertView:nil message:@"경기 검색에 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

#pragma mark - Map View Delegate Methods
- (void)setMapPOI:(MTMapPOIItem *)poiItem
{
    self.poiItem = poiItem;
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error to load my location in search match result");
    [searchMatchNearbyLoadingView stopLoading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)newLocations
{
    CLLocation *currentLocation = [newLocations objectAtIndex:0];
    
    if (currentLocation != Nil && firstDefaultSearch) {
        firstDefaultSearch = NO;
        NSNumber *currentLatitude = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
        NSNumber *currentLongitude = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
        
        [locationManager stopUpdatingLocation];
        
        NSDate *now = [NSDate date];
        NSTimeInterval startTimeDefault = [[NSDate setDateTimeWithDate:now setHour:1 setMinute:0] timeIntervalSince1970];
        NSTimeInterval endTimeDefault = [[[NSDate setDateTimeWithDate:now setHour:23 setMinute:59] dateByAddingCalendarUnits:NSMonthCalendarUnit amount:1] timeIntervalSince1970];
        
        [[GroundClient getInstance] searchMatchWithStartTime:startTimeDefault endTime:endTimeDefault latitude:currentLatitude longitude:currentLongitude distance:self.distance callback:^(BOOL result, NSDictionary *data){
            if (result) {
                NSArray *theDataArray = [data objectForKey:@"matchList"];
                for(id object in theDataArray){
                    SearchMatch *theSearchMatch = [[SearchMatch alloc] initSearchMatchWithData:object];
                    [self.dataController addSearchMatchWithSearchMatch:theSearchMatch];
                }
                [self.tableView reloadData];
            }else{
                NSLog(@"error to search match nearby in search match result");
            }
            
            [searchMatchNearbyLoadingView stopLoading];
        }];
        
    }else{
        [searchMatchNearbyLoadingView stopLoading];
    }
    [locationManager stopUpdatingLocation];
}
@end
