//
//  TeamInfoRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamInfoRequest.h"

@implementation TeamInfoRequest

- (TeamInfoRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"team_info"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    
    return dict;
}


@end
