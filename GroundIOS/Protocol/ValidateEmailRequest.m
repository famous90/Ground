//
//  ValidateEmailRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ValidateEmailRequest.h"

@implementation ValidateEmailRequest

- (ValidateEmailRequest *)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"validate_email"];
    return self;
}

- (NSString *)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary *)getInfoDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.email forKey:@"email"];
    
    return dict;
}

@end
