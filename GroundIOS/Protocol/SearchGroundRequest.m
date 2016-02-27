//
//  SearchGroundRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "SearchGroundRequest.h"

@implementation SearchGroundRequest

- (SearchGroundRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"search_ground"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.name forKey:@"name"];
    
    return dict;
}

@end
