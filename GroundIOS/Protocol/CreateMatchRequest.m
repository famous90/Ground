
//
//  CreateMatchRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "CreateMatchRequest.h"
#import "MatchInfo.h"

@implementation CreateMatchRequest

- (CreateMatchRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"create_match"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setMatchInfo:(MatchInfo *)matchInfo
{
    self.teamId = matchInfo.homeTeamId;
    self.startTime = matchInfo.startTime;
    self.endTime = matchInfo.endTime;
    self.groundId = matchInfo.ground.groundId;
    self.awayTeamId = matchInfo.awayTeamId;
    self.open = matchInfo.open;
    self.description = matchInfo.description;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:[NSNumber numberWithFloat:self.startTime*1000] forKey:@"startTime"];
    [dict setValue:[NSNumber numberWithFloat:self.endTime*1000] forKey:@"endTime"];
    [dict setValue:[NSNumber numberWithInteger:self.groundId] forKey:@"groundId"];
    [dict setValue:[NSNumber numberWithInteger:self.awayTeamId] forKey:@"awayTeamId"];
    [dict setValue:self.description forKey:@"description"];
    
    if(self.open){
        
        [dict setValue:@"true" forKey:@"open"];
    }else{
        
        [dict setValue:@"false" forKey:@"open"];
    }
    
    return dict;
}

@end
