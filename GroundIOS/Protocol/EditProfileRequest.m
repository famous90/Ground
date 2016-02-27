//
//  EditProfileRequest.m
//  GroundIOS
//
//  Created by Jet on 13. 7. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "EditProfileRequest.h"
#import "UserInfo.h"

@implementation EditProfileRequest

- (EditProfileRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"edit_profile"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setUserInfo:(UserInfo *)user
{
    self.name = user.name;
    self.location1 = user.location1;
    self.location2 = user.location2;
    self.phoneNumber = user.phoneNumber;
    self.profileImageUrl = user.profileImageUrl;
    self.birthYear = user.birthYear;
    self.occupation = user.occupation;
    self.position = user.position;
    self.height = user.height;
    self.weight = user.weight;
    self.mainFoot = user.mainFoot;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.location1 forKey:@"location1"];
    [dict setValue:self.location2 forKey:@"location2"];
    [dict setValue:self.phoneNumber forKey:@"phoneNumber"];
    [dict setValue:self.profileImageUrl forKey:@"profileImageUrl"];
    [dict setValue:[NSNumber numberWithInteger:self.birthYear]  forKey:@"birthYear"];
    [dict setValue:[NSNumber numberWithInteger:self.occupation] forKey:@"occupation"];
    [dict setValue:[NSNumber numberWithInteger:self.position] forKey:@"position"];
    [dict setValue:[NSNumber numberWithInteger:self.height] forKey:@"height"];
    [dict setValue:[NSNumber numberWithInteger:self.weight] forKey:@"weight"];
    [dict setValue:[NSNumber numberWithInteger:self.mainFoot] forKey:@"mainFoot"];
    
    return dict;
}


@end
