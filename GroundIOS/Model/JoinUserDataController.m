//
//  JoinUserDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "JoinUserDataController.h"
#import "JoinUser.h"

@interface JoinUserDataController()
- (void)initailizeDefaultDataList;
@end

@implementation JoinUserDataController

- (void)initailizeDefaultDataList
{
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    self.masterJoinUserList = userList;
}

- (void)setMasterJoinUserList:(NSMutableArray *)newJoinUserList
{
    if(_masterJoinUserList != newJoinUserList)
        _masterJoinUserList = [newJoinUserList mutableCopy];
}

- (id)init
{
    self = [super init];
    if(self){
        [self initailizeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList
{
    return [self.masterJoinUserList count];
}

- (JoinUser *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterJoinUserList objectAtIndex:theIndex];
}

- (void)addJoinUserWithJoinUser:(JoinUser *)user
{
    [self.masterJoinUserList addObject:user];
}

- (void)addJoinUserListWithJoinUserList:(NSArray *)userList
{
    [self.masterJoinUserList addObjectsFromArray:userList];
}

- (void)deleteJoinUserWithJoinUser:(JoinUser *)user
{
    [self.masterJoinUserList removeObject:user];
}

- (NSArray *)objectInList
{
    return [NSArray arrayWithArray:self.masterJoinUserList];
}

- (NSArray *)filteredUserInList:(NSInteger)filterNumber
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"join == %d", filterNumber];
    NSArray *dataSet = [NSArray arrayWithArray:self.masterJoinUserList];
    return [dataSet filteredArrayUsingPredicate:resultPredicate];
}

- (void)sortUserListByName
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self.masterJoinUserList sortUsingDescriptors:sortDescriptors];
}

- (NSArray *)allJoinUserInList
{
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterJoinUserList];
    return dataSet;
}


- (NSArray *)filteredJoinUserListWithUserId:(NSInteger)userId
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"userId == %d", userId];
    NSArray *dataSet = [NSArray arrayWithArray:self.masterJoinUserList];
    NSArray *resultDataSet = [dataSet filteredArrayUsingPredicate:resultPredicate];
    return resultDataSet;
}

- (BOOL)isJoinUserInListWithUserId:(NSInteger)userId
{
    if([[self filteredJoinUserListWithUserId:userId] count]){
        return YES;
    }else return NO;
}

- (void)removeJoinUserWithUserId:(NSInteger)userId
{
    NSArray *resultDataSet = [self filteredJoinUserListWithUserId:userId];
    if([resultDataSet count]){
        [self.masterJoinUserList removeObject:[resultDataSet objectAtIndex:0]];
        return;
    }else return;
}

- (NSArray *)allJoinUserIdInList
{
    NSMutableArray *userIds = [[NSMutableArray alloc] init];
    for( JoinUser *theJoinUser in self.masterJoinUserList){
        [userIds addObject:[NSNumber numberWithInteger:theJoinUser.userId]];
    }
    return userIds;
}
@end
