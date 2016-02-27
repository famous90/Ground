//
//  FeedListRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FeedListRequest.h"

@implementation FeedListRequest

- (FeedListRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"feed_list"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.LastFeedId] forKey:@"cur"];
    
    return dict;
}

@end
