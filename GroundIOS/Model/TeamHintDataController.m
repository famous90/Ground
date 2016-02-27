//
//  TeamHintDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamHintDataController.h"
#import "TeamHint.h"

@interface TeamHintDataController()
- (void)initializeDefaultDataList;
@end

@implementation TeamHintDataController

- (void)initializeDefaultDataList
{
    NSMutableArray *teamList = [[NSMutableArray alloc] init];
    self.myTeamsList = teamList;
    
}

- (void)setMyTeamsList:(NSMutableArray *)newList
{
    if(_myTeamsList != newList){
        _myTeamsList = [newList mutableCopy];
    }
}

- (id)init
{
    if(self = [super init]){
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList
{
    return [self.myTeamsList count];
}

- (TeamHint *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.myTeamsList objectAtIndex:theIndex];
}

- (void)addmyTeamsWithTeam:(TeamHint *)teams
{
    [self.myTeamsList addObject:teams];
}

- (void)removeAllTeamList
{
    [self.myTeamsList removeAllObjects];
}


@end
