//
//  LeaveTeamRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "LeaveTeamRequest.h"

@implementation LeaveTeamRequest

- (LeaveTeamRequest *)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"leave_team"];
    return self;
}

- (NSString *)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary *)getInfoDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    
    return dict;
}

@end
