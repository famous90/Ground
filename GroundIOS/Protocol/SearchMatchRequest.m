//
//  SearchMatchRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "SearchMatchRequest.h"
#import "NSDate+Utils.h"

@implementation SearchMatchRequest

- (SearchMatchRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"search_match"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithFloat:self.startTime*1000] forKey:@"startTime"];
    [dict setValue:[NSNumber numberWithFloat:self.endTime*1000] forKey:@"endTime"];
    [dict setValue:self.latitude forKey:@"latitude"];
    [dict setValue:self.longitude forKey:@"longitude"];
    [dict setValue:[NSNumber numberWithInteger:self.distance] forKey:@"distance"];
    
    return dict;
}

@end
