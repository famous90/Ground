//
//  JoinUserDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JoinUser;

@interface JoinUserDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterJoinUserList;

- (NSUInteger)countOfList;
- (JoinUser *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addJoinUserWithJoinUser:(JoinUser *)user;
- (void)addJoinUserListWithJoinUserList:(NSArray *)userList;
- (void)deleteJoinUserWithJoinUser:(JoinUser *)user;
- (NSArray *)objectInList;
- (NSArray *)filteredUserInList:(NSInteger)filterNumber;
- (void)sortUserListByName;
- (NSArray *)allJoinUserInList;

- (NSArray *)filteredJoinUserListWithUserId:(NSInteger)userId;
- (BOOL)isJoinUserInListWithUserId:(NSInteger)userId;
- (void)removeJoinUserWithUserId:(NSInteger)userId;
- (NSArray *)allJoinUserIdInList;

@end
