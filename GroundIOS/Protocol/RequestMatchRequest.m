//
//  RequestMatchRequest.m
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 16..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "RequestMatchRequest.h"

@implementation RequestMatchRequest

- (RequestMatchRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"request_match"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.matchId] forKey:@"matchId"];
    [dict setValue:[NSNumber numberWithInteger:self.homeTeamId] forKey:@"homeTeamId"];
    [dict setValue:[NSNumber numberWithInteger:self.awayTeamId] forKey:@"awayTeamId"];
    
    return dict;
}

@end
