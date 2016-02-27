//
//  MatchDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 31..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Match;

@interface MatchDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterMatchList;

- (NSUInteger)countOfList;
- (Match *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addMatchWithMatch:(Match *)match;
- (void)addMatchListWithMatchList:(NSArray *)matchList;
- (void)sortMatchListByDate;
- (NSArray *)matchListWithStatus:(NSInteger)status;
- (NSArray *)matchListWithStatus:(NSInteger)status homeTeamId:(NSInteger)teamId;
- (NSArray *)matchListWithStatus:(NSInteger)status awayTeamId:(NSInteger)teamId;
- (NSInteger)getBottomMatchId;

@end
