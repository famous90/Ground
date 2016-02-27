//
//  AcceptMemberRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "AcceptMemberRequest.h"

@implementation AcceptMemberRequest

- (AcceptMemberRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"accept_member"];
    
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
