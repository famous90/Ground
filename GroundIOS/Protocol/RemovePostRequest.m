//
//  RemovePostRequest.m
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "RemovePostRequest.h"
#import "Post.h"

@implementation RemovePostRequest

- (RemovePostRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"remove_post"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setPost:(Post *)post
{
    self.teamId = post.teamId;
    self.postId = post.postId;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:[NSNumber numberWithLong:self.postId] forKey:@"postId"];
    
    return dict;
}

@end
