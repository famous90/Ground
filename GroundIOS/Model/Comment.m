//
//  Comment.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 23..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initCommentWithData:(id)data
{
    self = [super init];
    if(self){
        _commentId = [[data valueForKey:@"id"] integerValue];
        _postId = [[data valueForKey:@"postId"] integerValue];
        _userId = [[data valueForKey:@"userId"] integerValue];
        _userName = [data valueForKey:@"userName"];
        _userImageUrl = [data valueForKey:@"userImageUrl"];
        _message = [data valueForKey:@"message"];
        _createdAt = [[data valueForKey:@"createdAt"] floatValue]/1000;
    }
    return self;
}

@end
