//
//  SearchMatchDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 2..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchMatch;

@interface SearchMatchDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterSearchMatchList;

- (void)addSearchMatchWithSearchMatch:(SearchMatch *)searchMatch;
- (NSUInteger)countOfList;
- (SearchMatch *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)removeAllData;

@end
