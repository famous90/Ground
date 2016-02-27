//
//  ChangePasswordRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ChangePasswordRequest.h"

@implementation ChangePasswordRequest

- (ChangePasswordRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"change_password"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.thePassword forKey:@"newPassword"];
    
    return dict;
}

@end
