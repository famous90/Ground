//
//  EmailRegisterRequest.m
//  GroundIOS
//
//  Created by Jet on 13. 7. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "EmailRegisterRequest.h"
#import "LocalUser.h"

@implementation EmailRegisterRequest

- (EmailRegisterRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"register"];
    
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
    
    NSLog(@"login info = %@", dict);
    
    return dict;
}


@end
