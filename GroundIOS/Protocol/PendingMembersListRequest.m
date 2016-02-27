//
//  PendingMembersListRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PendingMembersListRequest.h"

@implementation PendingMembersListRequest

- (PendingMembersListRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"pending_list"];
    
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
