//
//  InviteMemberRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "InviteMemberRequest.h"

@implementation InviteMemberRequest

- (InviteMemberRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"invite_member"];
    
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
    [dict setValue:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    
    return dict;
}

@end
