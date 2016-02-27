//
//  PostListRequest.m
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PostListRequest.h"

@implementation PostListRequest

- (PostListRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"post_list"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:[NSNumber numberWithLong:self.lastPostId] forKey:@"cur"];
    
    return dict;
}

@end
