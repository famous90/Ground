//
//  AcceptMatchRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "AcceptMatchRequest.h"

@implementation AcceptMatchRequest

- (AcceptMatchRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"accept_match"];
    
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
    
    return dict;
}

@end
