//
//  EditTeamProfileRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "EditTeamProfileRequest.h"
#import "TeamInfo.h"

@implementation EditTeamProfileRequest

- (EditTeamProfileRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"edit_team_profile"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setTeamInfo:(TeamInfo*)teamInfo
{
    self.teamId = teamInfo.teamId;
    self.teamImageUrl = teamInfo.imageUrl;
    self.teamAddress = teamInfo.address;
    self.latitude = teamInfo.latitude;
    self.longitude = teamInfo.longitude;
    
    NSLog(@"team id = %d, image = %@, address = %@, latitude = %f, longitude = %f", self.teamId, self.teamImageUrl, self.teamAddress, [self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:self.teamImageUrl forKey:@"imageUrl"];
    [dict setValue:self.teamAddress forKey:@"address"];
    [dict setValue:[NSNumber numberWithDouble:[self.latitude doubleValue]] forKey:@"latitude"];
    [dict setValue:[NSNumber numberWithDouble:[self.longitude doubleValue]] forKey:@"longitude"];
    
    return dict;
}

@end
