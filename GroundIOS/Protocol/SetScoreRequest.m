//
//  SetScoreRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "SetScoreRequest.h"
#import "Match.h"

@implementation SetScoreRequest

- (SetScoreRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"set_score"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setMatch:(Match *)match andIsMyTeamHome:(BOOL)isHome
{
    self.matchId = match.matchId;
    if (isHome) {
        self.teamId = match.homeTeamId;
    }else{
        self.teamId = match.awayTeamId;
    }
    self.homeScore = match.homeScore;
    self.awayScore = match.awayScore;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.matchId] forKey:@"matchId"];
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:[NSNumber numberWithInteger:self.homeScore] forKey:@"homeScore"];
    [dict setValue:[NSNumber numberWithInteger:self.awayScore] forKey:@"awayScore"];
    
    return dict;
}


@end
