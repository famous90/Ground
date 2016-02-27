//
//  FacebookLoginRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FacebookLoginRequest.h"
#import "LocalUser.h"

@implementation FacebookLoginRequest

- (FacebookLoginRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"facebook_login"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.email forKey:@"email"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.imageUrl forKey:@"imageUrl"];
    
    [dict setValue:[LocalUser getInstance].pushToken forKey:@"pushToken"];
    [dict setValue:[LocalUser getInstance].deviceUuid forKey:@"deviceUuid"];
    [dict setValue:[NSNumber numberWithInt:[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"OS Identifier"] intValue]] forKey:@"os"];
    [dict setValue:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"] forKey:@"appVer"];
    
    //NSLog(@"login info = %@", dict);
    
    return dict;
}

@end
