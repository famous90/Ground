//
//  AcceptTeamInvitationRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "AcceptTeamInvitationRequest.h"

@implementation AcceptTeamInvitationRequest

- (AcceptTeamInvitationRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"accept_team"];
    
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
    
    return dict;
}

@end
