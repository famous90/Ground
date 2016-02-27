//
//  SetMatchScoreViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define READY_SCORE     4
#define HOME_SCORE      5
#define AWAY_SCORE      6
#define SCORE_COMPLETED 7

#import "SetMatchScoreViewController.h"
#import "LoadingView.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"
#import "GroundClient.h"
#import "Config.h"

#import "User.h"
#import "TeamHint.h"
#import "Match.h"
#import "MatchInfo.h"

#import "NSDate+Utils.h"
#import "Util.h"
#import "ViewUtil.h"

@interface SetMatchScoreViewController ()
- (void)myScoreWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)competitorScoreWasSelected:(NSNumber *)selectedIndex element:(id)element;
@end

@implementation SetMatchScoreViewController{
    LoadingView *loadingView;
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
    [self setScreenName:NSStringFromClass([self class])];
    
    NSMutableArray *numList = [[NSMutableArray alloc] init];
    for(int i=0; i<100; i++){
        [numList addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.number = [NSArray arrayWithArray:numList];
    
    [self getMatchInfo];
}

- (void)getMatchInfo
{
    loadingView = [LoadingView startLoading:@"경기 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getMatchInfo:self.match.matchId teamId:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            self.matchInfo = [[MatchInfo alloc] initMatchInfoWithData:[data objectForKey:@"matchInfo"]];
            [self configureView];
        }else{
            NSLog(@"error to load match info in setting match result");
            [Util showErrorAlertView:nil message:@"경기정보를 불러오는데 실패했습니다"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [loadingView stopLoading];
        }
    }];
}

- (void)configureView
{
    TeamHint *myTeam = self.teamHint;
    MatchInfo *theMatch = self.matchInfo;
    BOOL isMyTeamHome = [theMatch isHomeTeamWithTeam:myTeam.teamId];
    
    NSInteger myScore, competitorScore;
    NSString *myTeamName, *competitorTeamName;
    if(isMyTeamHome){
        myScore = theMatch.homeScore;
        competitorScore = theMatch.awayScore;
        myTeamName = theMatch.homeTeamName;
        competitorTeamName = theMatch.awayTeamName;
    }else{
        myScore = theMatch.awayScore;
        competitorScore = theMatch.homeScore;
        myTeamName = theMatch.awayTeamName;
        competitorTeamName = theMatch.homeTeamName;
    }
    self.selectedMyScore = myScore;
    self.selectedCompetitorScore = competitorScore;
    
    if(theMatch.status == READY_SCORE){
        
        self.myScoreTextField.text = [NSString stringWithFormat:@"%d", 0];
        self.competitorScoreTextField.text = [NSString stringWithFormat:@"%d", 0];
        self.myScoreTextField.hidden = NO;
        self.competitorScoreTextField.hidden = NO;
        self.setResultButton.hidden = NO;
        self.selectedMyScore = 0;
        self.selectedCompetitorScore = 0;
    
    }else if(((theMatch.status == HOME_SCORE) && isMyTeamHome) || ((theMatch.status == AWAY_SCORE) && !isMyTeamHome)){
    
        self.myScoreLabel.hidden = NO;
        self.competitorScoreLabel.hidden = NO;
        self.editMyResultInputButton.hidden = NO;
        self.myScoreLabel.text = [NSString stringWithFormat:@"%d", myScore];
        self.competitorScoreLabel.text = [NSString stringWithFormat:@"%d", competitorScore];
        
    }else if(((theMatch.status == AWAY_SCORE) && isMyTeamHome) || ((theMatch.status == HOME_SCORE) && !isMyTeamHome)){
        
        self.myScoreLabel.hidden = NO;
        self.competitorScoreLabel.hidden = NO;
        self.editResultButton.hidden = NO;
        self.acceptResultButton.hidden = NO;
        self.myScoreLabel.text = [NSString stringWithFormat:@"%d", myScore];
        self.competitorScoreLabel.text = [NSString stringWithFormat:@"%d", competitorScore];
        
    }else{
        
        [Util showErrorAlertView:nil message:@"경기정보를 잘못불러왔습니다"];
        NSLog(@"wrong match info load in set match result");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    self.myTeamNameLabel.text = myTeamName;
    self.competitorTeamNameLabel.text = competitorTeamName;
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
        self.mapView.currentLocationTrackingMode = NO;
        
        MTMapPOIItem *poiItem = [[MTMapPOIItem alloc] init];
        [poiItem setMapPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([self.matchInfo.ground.latitude doubleValue], [self.matchInfo.ground.longitude doubleValue])]];
        //        [poiItem setItemName:[MTMapReverseGeoCoder findAddressForMapPoint:poiItem.mapPoint withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"]];

        [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:poiItem.mapPoint.mapPointGeo] zoomLevel:DAUM_MAP_ZOOM_LEVEL animated:YES];
        [self.mapView addPOIItem:poiItem];
        
        [self.matchLocationMapView addSubview:self.mapView];
    }
    [loadingView stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToShowReadyResult"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 
#pragma mark - IBActions Methods
- (IBAction)selectMyScore:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"점수선택" rows:self.number initialSelection:self.selectedMyScore target:self successAction:@selector(myScoreWasSelected:element:) cancelAction:nil origin:sender];
}

- (IBAction)myScoreButtonTapped:(UIBarButtonItem *)sender
{
    [self selectMyScore:sender];
}

- (IBAction)selectAwayScore:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"점수선택" rows:self.number initialSelection:self.selectedCompetitorScore target:self successAction:@selector(competitorScoreWasSelected:element:) cancelAction:nil origin:sender];
}

- (IBAction)awayScoreButtonTapped:(UIBarButtonItem *)sender
{
    [self selectAwayScore:sender];
}

- (IBAction)setResultButtonTapped:(id)sender
{
    [self setMatchScore];
    
    LoadingView *resultLoadingView = [LoadingView startLoading:@"결과를 전송하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] setMatchScore:self.match andIsMyTeamHome:[self.match isHomeTeamWithTeam:self.teamHint.teamId] callback:^(BOOL result, NSDictionary *data){
        if(result) {
            [Util showAlertView:nil message:@"결과를 입력하였습니다"];
            self.myScoreLabel.text = self.myScoreTextField.text;
            self.competitorScoreLabel.text = self.competitorScoreTextField.text;
            self.myScoreLabel.hidden = NO;
            self.competitorScoreLabel.hidden = NO;
            self.myScoreTextField.hidden = YES;
            self.competitorScoreTextField.hidden = YES;
            self.editMyResultInputButton.hidden = NO;
            self.editResultButton.hidden = YES;
            self.acceptResultButton.hidden = YES;
            self.setResultButton.hidden = YES;
        }else{
            NSLog(@"error to set match score in set match result");
            [Util showErrorAlertView:nil message:@"결과입력에 실패했습니다"];
        }
        
        [resultLoadingView stopLoading];
    }];
}

- (IBAction)editResultButtonTapped:(id)sender
{
    self.myScoreTextField.text = self.myScoreLabel.text;
    self.competitorScoreTextField.text = self.competitorScoreLabel.text;
    self.myScoreLabel.hidden = YES;
    self.competitorScoreLabel.hidden = YES;
    self.myScoreTextField.hidden = NO;
    self.competitorScoreTextField.hidden = NO;
    self.editMyResultInputButton.hidden = YES;
    self.setResultButton.hidden = NO;
}

- (IBAction)acceptResultButtonTapped:(id)sender
{
    LoadingView *resultLoadingView = [LoadingView startLoading:@"결과를 수락하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] acceptMatchScoreInMatch:self.match.matchId ByTeam:self.teamHint.teamId callback:^(BOOL result, NSDictionary *data){
        if(result){
            [Util showAlertView:nil message:@"경기 결과가 완성되었습니다"];
            self.editResultButton.hidden = YES;
            self.acceptResultButton.hidden = YES;
            
            MatchInfo *theMatch = self.matchInfo;
            TeamHint *myTeam = self.teamHint;
            NSString *matchResult;
            if (theMatch.homeScore == theMatch.awayScore) {
                matchResult = @"DRAW";
            }
            if ([theMatch isHomeTeamWithTeam:myTeam.teamId]) {
                if(theMatch.homeScore > theMatch.awayScore){
                    matchResult = @"WIN";
                }else if(theMatch.homeScore < theMatch.awayScore){
                    matchResult = @"LOSE";
                }
            }else{
                if(theMatch.awayScore > theMatch.homeScore){
                    matchResult = @"WIN";
                }else if(theMatch.awayScore < theMatch.homeScore){
                    matchResult = @"LOSE";
                }
            }
            self.matchResultLabel.text = matchResult;
            self.matchResultLabel.hidden = NO;
        }else{
            NSLog(@"error to accept match score in set match result");
            [Util showErrorAlertView:nil message:@"결과 수락에 실패했습니다"];
        }
        
        [resultLoadingView stopLoading];
    }];
}

- (IBAction)editMyResultInputButtonTapped:(id)sender
{
    self.myScoreTextField.text = self.myScoreLabel.text;
    self.competitorScoreTextField.text = self.competitorScoreLabel.text;
    self.myScoreLabel.hidden = YES;
    self.competitorScoreLabel.hidden = YES;
    self.myScoreTextField.hidden = NO;
    self.competitorScoreTextField.hidden = NO;
    self.editMyResultInputButton.hidden = YES;
    self.setResultButton.hidden = NO;
}

#pragma mark - Implementation Methods
- (void)setMatchScore
{
    MatchInfo *theMatch = self.matchInfo;
    TeamHint *myTeam = self.teamHint;
    if([theMatch isHomeTeamWithTeam:myTeam.teamId]){
        self.match.homeScore = self.selectedMyScore;
        self.match.awayScore = self.selectedCompetitorScore;
    }else{
        self.match.homeScore = self.selectedCompetitorScore;
        self.match.awayScore = self.selectedMyScore;
    }
}

- (void)myScoreWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedMyScore = [selectedIndex intValue];
    self.myScoreTextField.text = [NSString stringWithFormat:@"%d", self.selectedMyScore];
}

- (void)competitorScoreWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedCompetitorScore = [selectedIndex intValue];
    self.competitorScoreTextField.text = [NSString stringWithFormat:@"%d", self.selectedCompetitorScore];
}

@end
