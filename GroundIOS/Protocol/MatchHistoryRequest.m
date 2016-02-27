//
//  MatchHistoryRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MatchHistoryRequest.h"

@implementation MatchHistoryRequest

- (MatchHistoryRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"match_history"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:[NSNumber numberWithInteger:self.lastMatchId] forKey:@"cur"];
    [dict setValue:false forKey:@"order"];
    
    return dict;
}

@end
