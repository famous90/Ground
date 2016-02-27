//
//  TeamHintRequest.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamHintRequest.h"

@implementation TeamHintRequest

- (TeamHintRequest *)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"team_hint"];
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
