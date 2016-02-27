//
//  CancelMatchRequest.m
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 16..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "CancelMatchRequest.h"

@implementation CancelMatchRequest

- (CancelMatchRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"cancel_match"];
    
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
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    
    return dict;
}

@end
