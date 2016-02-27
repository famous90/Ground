//
//  SearchMatchDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 2..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "SearchMatchDataController.h"
#import "SearchMatch.h"
@interface SearchMatchDataController()
- (void)initializeDefaultDataList;
@end

@implementation SearchMatchDataController
- (void)initializeDefaultDataList
{
    NSMutableArray *matchList = [[NSMutableArray alloc] init];
    self.masterSearchMatchList = matchList;
}

- (id)init
{
    self = [super init];
    if(self){
        [self initializeDefaultDataList];
    }
    return self;
}

- (void)setMasterSearchMatchList:(NSMutableArray *)newSearchMatchList
{
    if(_masterSearchMatchList != newSearchMatchList)
        _masterSearchMatchList = [newSearchMatchList mutableCopy];
}

- (void)addSearchMatchWithSearchMatch:(SearchMatch *)searchMatch
{
    [self.masterSearchMatchList addObject:searchMatch];
}

- (NSUInteger)countOfList
{
    return [self.masterSearchMatchList count];
}

- (SearchMatch *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterSearchMatchList objectAtIndex:theIndex];
}

- (void)removeAllData
{
    [self.masterSearchMatchList removeAllObjects];
}

@end
