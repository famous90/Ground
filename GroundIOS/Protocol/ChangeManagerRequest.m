//
//  ChangeManagerRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ChangeManagerRequest.h"

@implementation ChangeManagerRequest

- (ChangeManagerRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"change_manager"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setObject:self.theManagerId forKey:@"newManagerIdList"];
    [dict setObject:self.oldManagerId forKey:@"oldManagerIdList"];
    
    return dict;
}

@end
