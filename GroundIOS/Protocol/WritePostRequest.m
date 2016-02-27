//
//  WritePostRequest.m
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "WritePostRequest.h"
#import "Post.h"
#import "SBJson.h"
#import "StringUtils.h"

@implementation WritePostRequest

- (WritePostRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"write_post"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (void)setPost:(Post *)post
{
    self.type = post.type;
    self.teamId = post.teamId;
    self.message = post.message;
    
    NSMutableDictionary *extraBody = [[NSMutableDictionary alloc] init];
    [extraBody setValue:post.postImageUrl forKey:@"anb.ground.extra.imagePath"];
    self.extra = [[SBJsonWriter new] stringWithObject:extraBody];
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:self.message forKey:@"message"];
    [dict setValue:self.extra forKey:@"extra"];

    return dict;
}

@end
