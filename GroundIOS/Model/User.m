//
//  User.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithUser:(User *)user
{
    self = [super init];
    if(self){
        _userId = user.userId;
        _name = user.name;
        _email = user.email;
        _imageUrl = user.imageUrl;
        _isManager = user.isManager;
        
        return self;
    }
    return nil;
}

- (id)initUserWithData:(id)data
{
    self = [super init];
    if(self){
        _userId = [[data valueForKey:@"id"] integerValue];
        _name = [data valueForKey:@"name"];
        _email = [data valueForKey:@"email"];
        _imageUrl = [data valueForKey:@"imageUrl"];
        _isManager = [[data valueForKey:@"manager"] boolValue];
    }
    return self;
}

- (id)initWithUserId:(NSInteger)userId name:(NSString *)name imageUrl:(NSString *)imageUrl
{
    self = [super init];
    if(self){
        _userId = userId;
        _name = name;
        _imageUrl = imageUrl;
        
    }
    return self;
}

//- (id)initWithUserId:(NSInteger)userId userName:(NSString *)name email:(NSString *)email imageUrl:(NSString *)imageUrl isManager:(BOOL)isManager
//{
//    self = [super init];
//    if(self){
//        _userId = userId;
//        _name = name;
//        _email = email;
//        _imageUrl = imageUrl;
//        _isManager = isManager;
//        
//        return self;
//    }
//    return nil;
//}

- (void)makeUserWithUser:(User *)user
{
    self.userId = user.userId;
    self.name = user.name;
    self.email = user.email;
    self.imageUrl = user.imageUrl;
}

@end
