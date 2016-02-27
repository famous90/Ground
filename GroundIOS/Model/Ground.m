//
//  Ground.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "Ground.h"

@implementation Ground

- (id)initGroundWithData:(id)data
{
    self = [super init];
    if(self){
        _groundId = [[data valueForKey:@"id"] integerValue];
        _name = [data valueForKey:@"name"];
        _address = [data valueForKey:@"address"];
        _latitude = [data valueForKey:@"latitude"];
        _longitude = [data valueForKey:@"longitude"];
    }
    return self;
}

- (id)initWithGround:(Ground *)ground
{
    self = [super init];
    if(self){
        self = [ground mutableCopy];
    }
    return self;
}

@end
