//
//  Match.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 30..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "Match.h"

@implementation Match

- (id)initMatchWithData:(id)data
{
    self = [super init];
    if(self){
        _matchId = [[data valueForKey:@"id"] integerValue];
        _status = [[data valueForKey:@"status"] integerValue];
        _startTime = [[data valueForKey:@"startTime"] floatValue]/1000;
        _endTime = [[data valueForKey:@"endTime"] floatValue]/1000;
        _groundName = [data valueForKey:@"groundName"];
        _homeTeamId = [[data valueForKey:@"homeTeamId"] integerValue];
        _homeTeamName = [data valueForKey:@"homeTeamName"];
        _homeScore = [[data valueForKey:@"homeScore"] integerValue];
        _awayTeamId = [[data valueForKey:@"awayTeamId"] integerValue];
        _awayTeamName = [data valueForKey:@"awayTeamName"];
        _awayScore = [[data valueForKey:@"awayScore"] integerValue];
    }
    return self;
}

- (BOOL)isHomeTeamWithTeam:(NSInteger)teamId
{
    if(teamId == self.homeTeamId)
        return YES;
    else return NO;
}

@end
