//
//  PendingTeamInvitationRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PendingTeamInvitationRequest.h"

@implementation PendingTeamInvitationRequest

- (PendingTeamInvitationRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"pending_team_list"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    return dict;
}

@end
