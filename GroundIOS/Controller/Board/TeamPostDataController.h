//
//  TeamPostDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface TeamPostDataController : NSObject

@property (strong, nonatomic) NSMutableArray *teamPost;

- (NSUInteger)countOfList;
- (Post *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addNewPostWithPost:(Post *)newPost;
- (void)sortDecendingPostwithPostId;
- (NSInteger)getBottomPostId;
- (Post *)lastObjectInList;
- (void)removeAll;

@end
