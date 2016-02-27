//
//  LoginRequest.m
//  httpPrac
//
//  Created by Jet on 13. 6. 5..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "LoginRequest.h"
#import "LocalUser.h"

@implementation LoginRequest

- (LoginRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"login"];
    
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
    [dict setValue:self.password forKey:@"password"];
    
    [dict setValue:[LocalUser getInstance].pushToken forKey:@"pushToken"];
    [dict setValue:[LocalUser getInstance].deviceUuid forKey:@"deviceUuid"];
    [dict setValue:[NSNumber numberWithInt:[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"OS Identifier"] intValue]] forKey:@"os"];
    [dict setValue:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"] forKey:@"appVer"];
    
    //NSLog(@"LOGIN INFO = %@", dict);
    NSLog(@"device model = %@, retina = %d", [LocalUser getInstance].deviceModel, [LocalUser getInstance].retina);
    
    return dict;
}

@end
