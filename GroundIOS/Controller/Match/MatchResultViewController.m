//
//  MatchResultViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MatchResultViewController.h"
#import "LoadingView.h"

#import "Ground.h"
#import "GroundClient.h"
#import "Config.h"

#import "User.h"
#import "TeamHint.h"
#import "Match.h"
#import "MatchInfo.h"

#import "NSDate+Utils.h"
#import "Util.h"
#import "ViewUtil.h"

@implementation MatchResultViewController

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
    [self setScreenName:NSStringFromClass([self class])];
    
    [self getMatchInfo];
}

- (void)getMatchInfo
{
    LoadingView *loadingView = [LoadingView startLoading:@"경기 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getMatchInfo:self.match.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            self.matchInfo = [[MatchInfo alloc] initMatchInfoWithData:[data objectForKey:@"matchInfo"]];
            [self configureView];
        }else{
            NSLog(@"error to load match info in match result");
            [Util showErrorAlertView:nil message:@"경기정보를 불러오는데 실패했습니다"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)configureView
{
    MatchInfo *theMatch = self.matchInfo;
    TeamHint *myTeam = self.teamHint;
    
    NSString *matchResult;
    NSInteger matchResultFontColor;
    if (theMatch.homeScore == theMatch.awayScore) {
        matchResult = @"DRAW";
        matchResultFontColor = 0x8C8C8C;
    }
    if ([theMatch isHomeTeamWithTeam:myTeam.teamId]) {
        self.myTeamNameLabel.text = theMatch.homeTeamName;
        self.myScoreLabel.text = [NSString stringWithFormat:@"%d", theMatch.homeScore];
        self.awayTeamNameLabel.text = theMatch.awayTeamName;
        self.awayScoreLabel.text = [NSString stringWithFormat:@"%d", theMatch.awayScore];
        if(theMatch.homeScore > theMatch.awayScore){
            matchResult = @"WIN";
            matchResultFontColor = 0x0E6F49;
        }else if(theMatch.homeScore < theMatch.awayScore){
            matchResult = @"LOSE";
            matchResultFontColor = 0x474747;
        }
    }else{
        self.myTeamNameLabel.text = theMatch.awayTeamName;
        self.myScoreLabel.text = [NSString stringWithFormat:@"%d", theMatch.awayScore];
        self.awayTeamNameLabel.text = theMatch.homeTeamName;
        self.awayScoreLabel.text = [NSString stringWithFormat:@"%d", theMatch.homeScore];
        if(theMatch.awayScore > theMatch.homeScore){
            matchResult = @"WIN";
            matchResultFontColor = 0x0E6F49;
        }else if(theMatch.awayScore < theMatch.homeScore){
            matchResult = @"LOSE";
            matchResultFontColor = 0x474747;
        }
    }
    [self.matchResultLabel setTextColor:UIColorFromRGB(matchResultFontColor)];
    self.matchResultLabel.text = matchResult;
    self.myScoreLabel.hidden = NO;
    self.awayScoreLabel.hidden = NO;
    self.matchResultLabel.hidden = NO;
    self.matchDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.startTime format:11];
    self.matchTimeLabel.text = [NSString stringWithFormat:@"%@-%@", [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.startTime format:12], [NSDate GeneralFormatDateFromNSTimeInterval:theMatch.startTime format:10]];
    self.matchLocationLabel.text = theMatch.ground.name;
    
    [self setDaumMapView];
}

- (void)setDaumMapView
{
    if(!self.mapView){
        self.mapView = [[MTMapView alloc] initWithFrame:[ViewUtil mapViewSizeInMatchResultForiPhoneDeviceScreenHeight]];
        [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
        [self.mapView setUserInteractionEnabled:NO];
        
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
    if ([[segue identifier] isEqualToString:@"CancelToShowMatchResult"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
