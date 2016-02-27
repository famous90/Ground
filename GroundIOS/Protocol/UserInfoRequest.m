//
//  UserInfoRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "UserInfoRequest.h"

@implementation UserInfoRequest

- (UserInfoRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"user_info"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    
    return dict;
}

@end
