//
//  CommentDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 10. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment;

@interface CommentDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterDataList;

- (NSUInteger)countOfList;
- (Comment *)objectInListAtIndex:(NSUInteger)index;
- (void)addNewCommentWithComment:(Comment *)newComment;
- (void)sortCommentListByDate;

@end
