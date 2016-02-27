//
//  TeamListRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamListRequest.h"

@implementation TeamListRequest

- (TeamListRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"team_list"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    return nil;
}

@end
