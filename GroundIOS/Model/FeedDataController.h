//
//  FeedDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@interface FeedDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterFeedList;

- (NSUInteger)countOfList;
- (Feed *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addMyNewsWithNews:(Feed *)news;
- (NSInteger)getBottomFeedId;

@end
