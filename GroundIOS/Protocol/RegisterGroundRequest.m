//
//  RegisterGroundRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "RegisterGroundRequest.h"
#import "Ground.h"

@implementation RegisterGroundRequest

- (RegisterGroundRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"register_ground"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setGround:(Ground *)ground
{
    self.name = ground.name;
    self.address = ground.address;
    self.latitude = ground.latitude;
    self.longitude = ground.longitude;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.address forKey:@"address"];
    [dict setValue:[NSNumber numberWithDouble:[self.latitude doubleValue]] forKey:@"latitude"];
    [dict setValue:[NSNumber numberWithDouble:[self.longitude doubleValue]] forKey:@"longitude"];
    
    return dict;
}

@end
