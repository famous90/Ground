//
//  AddCommentRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "AddCommentRequest.h"

@implementation AddCommentRequest

- (AddCommentRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"write_comment"];
    
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
    [dict setValue:[NSNumber numberWithInteger:self.postId] forKey:@"postId"];
    [dict setValue:self.comment forKey:@"message"];
    
    return dict;
}

@end
