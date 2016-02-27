//
//  RemoveAccountRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "RemoveAccountRequest.h"

@implementation RemoveAccountRequest

- (RemoveAccountRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"remove_account"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    return dict;
}

@end
