//
//  RemoveCommentRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "RemoveCommentRequest.h"

@implementation RemoveCommentRequest

- (RemoveCommentRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"remove_comment"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.postId] forKey:@"postId"];
    [dict setValue:[NSNumber numberWithInteger:self.commentId] forKey:@"commentId"];
    
    return dict;
}

@end
