//
//  TeamInfoDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeamInfo;

@interface TeamInfoDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterData;

- (NSUInteger)countOfList;
- (TeamInfo *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addTeamInfoWithTeam:(TeamInfo *)theTeam;
- (void)removeAllTeamList;

@end
