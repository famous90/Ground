//
//  CreateMatchRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class MatchInfo;

@interface CreateMatchRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,assign) NSInteger groundId;
@property (nonatomic,assign) NSInteger awayTeamId;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,assign) BOOL open;
@property (nonatomic,strong) NSString* protocolName;

- (void)setMatchInfo:(MatchInfo *)matchInfo;

@end
