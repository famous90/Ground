//
//  MatchInfo.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MatchInfo.h"

@implementation MatchInfo

- (id)initMatchInfoWithData:(id)data
{
    self = [super init];
    if(self){
        _matchId = [[data valueForKey:@"id"] integerValue];
        _homeTeamId = [[data valueForKey:@"homeTeamId"] integerValue];
        _awayTeamId = [[data valueForKey:@"awayTeamId"] integerValue];
        _homeTeamName = [data valueForKey:@"homeTeamName"];
        _awayTeamName = [data valueForKey:@"awayTeamName"];
        _homeImageUrl = [data valueForKey:@"homeImageUrl"];
        _awayImageUrl = [data valueForKey:@"awayImageUrl"];
        _homeScore = [[data valueForKey:@"homeScore"] integerValue];
        _awayScore = [[data valueForKey:@"awayScore"] integerValue];
        _homeJoinedMembersCount = [[data valueForKey:@"homeJoinedMembersCount"] integerValue];
        _awayJoinedMembersCount = [[data valueForKey:@"awayJoinedMembersCount"] integerValue];
        _status = [[data valueForKey:@"status"] integerValue];
        _startTime = [[data valueForKey:@"startTime"] floatValue]/1000;
        _endTime = [[data valueForKey:@"endTime"] floatValue]/1000;
        _ground = [[Ground alloc] initGroundWithData:[data objectForKey:@"ground"]];
        _join = [[data valueForKey:@"join"] integerValue];
        _description = [data valueForKey:@"description"];
        _open = [[data valueForKey:@"open"] boolValue];
        _askSurvey = [[data valueForKey:@"askSurvey"] boolValue];
    }
    return self;
}

- (BOOL)isHomeTeamWithTeam:(NSInteger)teamId;
{
    if(teamId == self.homeTeamId)
        return YES;
    else return NO;
}

@end
