//
//  Match.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 30..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, strong) NSString  *groundName;
@property (nonatomic, assign) NSInteger homeTeamId;
@property (nonatomic, strong) NSString  *homeTeamName;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger awayTeamId;
@property (nonatomic, strong) NSString  *awayTeamName;
@property (nonatomic, assign) NSInteger awayScore;

- (id)initMatchWithData:(id)data;

- (BOOL)isHomeTeamWithTeam:(NSInteger)teamId;

@end
