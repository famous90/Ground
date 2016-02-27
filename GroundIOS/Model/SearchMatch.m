//
//  SMatch.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "SearchMatch.h"

@implementation SearchMatch

- (id)initSearchMatchWithData:(id)data
{
    self = [super init];
    if(self){
        _matchId = [[data valueForKey:@"id"] integerValue];
        _startTime = [[data valueForKey:@"startTime"] floatValue]/1000;
        _endTime = [[data valueForKey:@"endTime"] floatValue]/1000;
        _groundName = [data valueForKey:@"groundName"];
        _homeTeamId = [[data valueForKey:@"homeTeamId"] integerValue];
        _homeTeamName = [data valueForKey:@"homeTeamName"];
        _distance = [data valueForKey:@"distance"];
    }
    return self;
}

@end
