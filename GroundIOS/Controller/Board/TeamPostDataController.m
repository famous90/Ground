//
//  TeamPostDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamPostDataController.h"
#import "Post.h"

@interface TeamPostDataController()
@end

@implementation TeamPostDataController

- (void)setTeamPost:(NSMutableArray *)newPost
{
    if(_teamPost != newPost){
        _teamPost = [newPost mutableCopy];
    }
}

- (id)init
{
    if(self = [super init]){
        self.teamPost = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList
{
    return [self.teamPost count];
}

- (Post *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.teamPost objectAtIndex:theIndex];
}

- (void)addNewPostWithPost:(Post *)newPost
{
    [self.teamPost addObject:newPost];
}

- (void)sortDecendingPostwithPostId
{
    NSSortDescriptor *idSorter = [[NSSortDescriptor alloc] initWithKey:@"postId" ascending:NO];
    [self.teamPost sortUsingDescriptors:[NSArray arrayWithObject:idSorter]];
}

- (NSInteger)getBottomPostId
{
    return [[self.teamPost lastObject] postId];
}

- (Post *)lastObjectInList
{
    return [self.teamPost lastObject];
}

- (void)removeAll
{
    [self.teamPost removeAllObjects];
}

@end
