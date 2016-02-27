//
//  MatchInfo.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ground.h"

@interface MatchInfo : NSObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger homeTeamId;
@property (nonatomic, assign) NSInteger awayTeamId;
@property (nonatomic, strong) NSString *homeTeamName;
@property (nonatomic, strong) NSString *awayTeamName;
@property (nonatomic, strong) NSString *homeImageUrl;
@property (nonatomic, strong) NSString *awayImageUrl;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger awayScore;
@property (nonatomic, assign) NSInteger homeJoinedMembersCount;
@property (nonatomic, assign) NSInteger awayJoinedMembersCount;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, strong) Ground   *ground;
@property (nonatomic, assign) NSInteger join;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) BOOL      open;
@property (nonatomic, assign) BOOL      askSurvey;

- (id)initMatchInfoWithData:(id)data;

- (BOOL)isHomeTeamWithTeam:(NSInteger)teamId;

@end
