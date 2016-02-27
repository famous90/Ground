//
//  TeamInfoDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamInfoDataController.h"

@implementation TeamInfoDataController

- (id)init
{
    if(self = [super init]){
        self.masterData = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList
{
    return [self.masterData count];
}

- (TeamInfo *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterData objectAtIndex:theIndex];
}

- (void)addTeamInfoWithTeam:(TeamInfo *)theTeam
{
    [self.masterData addObject:theTeam];
}

- (void)removeAllTeamList
{
    [self.masterData removeAllObjects];
}

@end
