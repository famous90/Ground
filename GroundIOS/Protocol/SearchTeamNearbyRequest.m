//
//  SearchTeamNearbyRequest.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 6..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "SearchTeamNearbyRequest.h"

@implementation SearchTeamNearbyRequest

- (SearchTeamNearbyRequest *)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"search_team_nearby"];
    return self;
}

- (NSString *)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary *)getInfoDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.latitude forKey:@"latitude"];
    [dict setValue:self.longituge forKey:@"longitude"];
    [dict setValue:[NSNumber numberWithInteger:self.distance] forKey:@"distance"];
    
    return dict;
}

@end
