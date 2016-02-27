//
//  DenyMemberRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DenyMemberRequest.h"

@implementation DenyMemberRequest

- (DenyMemberRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"deny_member"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.memberId] forKey:@"memberId"];
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    
    return dict;
}

@end
