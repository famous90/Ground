//
//  CommentDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "CommentDataController.h"
#import "Comment.h"

@implementation CommentDataController

- (void)setMasterDataList:(NSMutableArray *)newCommentList
{
    if (_masterDataList != newCommentList) {
        _masterDataList = [newCommentList mutableCopy];
    }
}

- (id)init
{
    self = [super init];
    if(self){
        self.masterDataList = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList
{
    return [self.masterDataList count];
}

- (Comment *)objectInListAtIndex:(NSUInteger)index
{
    return [self.masterDataList objectAtIndex:index];
}

- (void)addNewCommentWithComment:(Comment *)newComment
{
    if (![self isCommentInListWithId:newComment.commentId]) {
        [self.masterDataList addObject:newComment];
    }
}

- (BOOL)isCommentInListWithId:(NSInteger)commentId
{
    for( Comment *theComment in self.masterDataList){
        if(theComment.commentId == commentId){
            return YES;
        }
    }
    return NO;
}

- (void)sortCommentListByDate
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self.masterDataList sortUsingDescriptors:sortDescriptors];
}
@end
