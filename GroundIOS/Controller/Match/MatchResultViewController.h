//
//  MatchResultViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "GAITrackedViewController.h"

@class User;
@class TeamHint;
@class Match;
@class MatchInfo;

@interface MatchResultViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *matchLocationMapView;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint  *teamHint;
@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) MatchInfo *matchInfo;
@property (nonatomic, strong) MTMapView *mapView;

@end
