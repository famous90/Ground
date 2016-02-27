//
//  TeamHintDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeamHint;

@interface TeamHintDataController : NSObject

@property (nonatomic, copy) NSMutableArray *myTeamsList;

- (NSUInteger)countOfList;
- (TeamHint *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addmyTeamsWithTeam:(TeamHint *)teams;
- (void)removeAllTeamList;

@end
