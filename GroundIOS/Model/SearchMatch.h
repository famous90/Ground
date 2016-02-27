//
//  SMatch.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchMatch : NSObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, strong) NSString  *groundName;
@property (nonatomic, assign) NSInteger homeTeamId;
@property (nonatomic, strong) NSString  *homeTeamName;
@property (nonatomic, strong) NSNumber *distance;

- (id)initSearchMatchWithData:(id)data;

@end
