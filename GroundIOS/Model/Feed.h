//
//  Feed.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 23..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, assign) NSInteger requestedTeamId;
@property (nonatomic, strong) NSString *requestedTeamName;
@property (nonatomic, strong) NSString *homeTeamName;
@property (nonatomic, strong) NSString *awayTeamName;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSTimeInterval createdAt;

- (id)initFeedWithData:(id)data;

@end
