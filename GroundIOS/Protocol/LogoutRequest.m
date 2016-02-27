//
//  LogoutRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "LogoutRequest.h"

@implementation LogoutRequest

- (LogoutRequest *)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"logout"];
    return self;
}

- (NSString *)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary *)getInfoDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.deviceUuid forKey:@"deviceUuid"];
    
    return dict;
}

@end
