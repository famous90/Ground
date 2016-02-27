//
//  FeedDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FeedDataController.h"
#import "Feed.h"

@interface FeedDataController()
@end

@implementation FeedDataController

- (void)setMasterMyNewsList:(NSMutableArray *)newList
{
    if(_masterFeedList != newList){
        _masterFeedList = [newList mutableCopy];
    }
}

- (id)init
{
    if(self = [super init]){
        self.masterFeedList = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList
{
    return [self.masterFeedList count];
}

- (Feed *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterFeedList objectAtIndex:theIndex];
}

- (void)addMyNewsWithNews:(Feed *)news
{
    [self.masterFeedList addObject:news];
}

- (NSInteger)getBottomFeedId
{
    return [[self.masterFeedList lastObject] feedId];
}

@end
