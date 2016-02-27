//
//  RegisterTeamRequest.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 20..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "RegisterTeamRequest.h"
#import "TeamInfo.h"

@implementation RegisterTeamRequest

- (RegisterTeamRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"register_team"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setTeamInfo:(TeamInfo*)teamInfo
{
    self.teamName = teamInfo.name;
    self.teamImageUrl = teamInfo.imageUrl;
    self.teamAddress = teamInfo.address;
    self.latitude = teamInfo.latitude;
    self.longitude = teamInfo.longitude;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.teamName forKey:@"name"];
    [dict setValue:self.teamImageUrl forKey:@"teamImageUrl"];
    [dict setValue:self.teamAddress forKey:@"address"];
    [dict setValue:self.latitude forKey:@"latitude"];
    [dict setValue:self.longitude forKey:@"longitude"];
    
    return dict;
}

@end
