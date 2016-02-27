//
//  User.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *email;
@property (nonatomic, strong) NSString  *imageUrl;
@property (nonatomic, assign) BOOL      isManager;

- (id)initWithUser:(User *)user;
- (id)initUserWithData:(id)data;
- (id)initWithUserId:(NSInteger)userId name:(NSString *)name imageUrl:(NSString *)imageUrl;
//- (id)initWithUserId:(NSInteger)userId userName:(NSString *)userName email:(NSString *)email imageUrl:(NSString *)imageUrl isManager:(BOOL)isManager;

- (void)makeUserWithUser:(User *)user;

@end
