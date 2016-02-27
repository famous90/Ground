//
//  MatchDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 31..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MatchDataController.h"
#import "Match.h"

@implementation MatchDataController

- (void)setMasterMatchList:(NSMutableArray *)newMatchList
{
    if(_masterMatchList != newMatchList){
        _masterMatchList = [newMatchList mutableCopy];
    }
}

- (id)init
{
    if(self = [super init]){
        self.masterMatchList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfList
{
    return [self.masterMatchList count];
}

- (Match *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterMatchList objectAtIndex:theIndex];
}

- (void)addMatchWithMatch:(Match *)match
{
    [self.masterMatchList addObject:match];
}

- (void)addMatchListWithMatchList:(NSArray *)matchList
{
    [self.masterMatchList addObjectsFromArray:matchList];
}

- (void)sortMatchListByDate
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self.masterMatchList sortUsingDescriptors:sortDescriptors];
}

- (NSArray *)matchListWithStatus:(NSInteger)status
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"status == %d", status];
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterMatchList];
    return [dataSet filteredArrayUsingPredicate:resultPredicate];
}

- (NSArray *)matchListWithStatus:(NSInteger)status homeTeamId:(NSInteger)teamId
{
    NSPredicate *resultPredicateWithStatus = [NSPredicate predicateWithFormat:@"status == %d", status];
    NSPredicate *resultPredicateWithHome = [NSPredicate predicateWithFormat:@"homeTeamId == %d", teamId];
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterMatchList];
    return [[dataSet filteredArrayUsingPredicate:resultPredicateWithStatus] filteredArrayUsingPredicate:resultPredicateWithHome];
}

- (NSArray *)matchListWithStatus:(NSInteger)status awayTeamId:(NSInteger)teamId
{
    NSPredicate *resultPredicateWithStatus = [NSPredicate predicateWithFormat:@"status == %d", status];
    NSPredicate *resultPredicateWithAway = [NSPredicate predicateWithFormat:@"awayTeamId == %d", teamId];
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterMatchList];
    return [[dataSet filteredArrayUsingPredicate:resultPredicateWithStatus] filteredArrayUsingPredicate:resultPredicateWithAway];
}

- (NSInteger)getBottomMatchId
{
    return [[self.masterMatchList lastObject] matchId];
}

@end
