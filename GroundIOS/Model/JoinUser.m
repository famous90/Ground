//
//  JoinUser.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "JoinUser.h"

@implementation JoinUser

- (id)initJoinUserWithData:(id)data
{
    self = [super init];
    if(self){
        _userId = [[data valueForKey:@"id"] integerValue];
        _name = [data valueForKey:@"name"];
        _imageUrl = [data valueForKey:@"imageUrl"];
        _join = [[data valueForKey:@"join"] integerValue];
    }
    return self;
}

- (id)initWithUser:(NSInteger)userId name:(NSString *)name imageUrl:(NSString *)imageUrl join:(NSInteger)join
{
    self = [super init];
    if(self){
        _userId = userId;
        _name = name;
        _imageUrl = imageUrl;
        _join = join;
        
        return self;
    }
    return nil;
}

@end
