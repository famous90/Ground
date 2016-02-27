//
//  UserDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "UserDataController.h"
#import "User.h"

@interface UserDataController()
- (void)initailizeDefaultDataList;
@end

@implementation UserDataController

- (void)initailizeDefaultDataList
{
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    self.masterUserList = userList;
}

- (void)setMasterJoinUserList:(NSMutableArray *)newUserList
{
    if(_masterUserList != newUserList)
        _masterUserList = [newUserList mutableCopy];
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
    return [self.masterUserList count];
}

- (User *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterUserList objectAtIndex:theIndex];
}

- (void)addUserWithUser:(User *)user
{
    [self.masterUserList addObject:user];
}

- (void)addUserListWithUserList:(NSArray *)userList
{
    [self.masterUserList addObjectsFromArray:userList];
}

- (void)removeUserWithUser:(User *)user
{
    [self.masterUserList removeObject:user];
}

- (NSArray *)objectInList
{
    return [NSArray arrayWithArray:self.masterUserList];
}

- (NSArray *)filteredUserListAboutFilteringNumber:(BOOL)isManager
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"isManager == %d", isManager];
    NSArray *dataSet = [NSArray arrayWithArray:self.masterUserList];
    return [dataSet filteredArrayUsingPredicate:resultPredicate];
}

- (NSArray *)allObjectInList
{
    NSArray *dataSet = [NSArray arrayWithArray:self.masterUserList];
    return dataSet;
}

- (NSArray *)filteredUserListWithUserId:(NSInteger)userId
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"userId == %d", userId];
    NSArray *dataSet = [NSArray arrayWithArray:self.masterUserList];
    NSArray *resultDataSet = [dataSet filteredArrayUsingPredicate:resultPredicate];
    return resultDataSet;
}

- (BOOL)isUserInListWithUserId:(NSInteger)userId
{
    if([[self filteredUserListWithUserId:userId] count]){
        return YES;
    }else return NO;
}

- (void)removeUserWithUserId:(NSInteger)userId
{
    NSArray *resultDataSet = [self filteredUserListWithUserId:userId];
    if([resultDataSet count]){
        [self.masterUserList removeObject:[resultDataSet objectAtIndex:0]];
        return;
    }else return;
}

- (void)changeIsManager
{
    for(User *theUser in self.masterUserList){
        theUser.isManager = !theUser.isManager;
    }
}

- (NSArray *)allUserIdInList
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for(User *theUser in self.masterUserList){
        [data addObject:[NSNumber numberWithInt:theUser.userId]];
    }
    return [[NSArray alloc] initWithArray:data];
}

@end
