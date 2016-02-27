//
//  UserDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterUserList;

- (NSUInteger)countOfList;
- (User *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addUserWithUser:(User *)user;
- (void)addUserListWithUserList:(NSArray *)userList;
- (void)removeUserWithUser:(User *)user;
- (NSArray *)filteredUserListAboutFilteringNumber:(BOOL)isManager;
- (NSArray *)allObjectInList;
- (NSArray *)filteredUserListWithUserId:(NSInteger)userId;
- (BOOL)isUserInListWithUserId:(NSInteger)userId;
- (void)removeUserWithUserId:(NSInteger)userId;
- (void)changeIsManager;
- (NSArray *)allUserIdInList;

@end
