//
//  SetScoreRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class Match;

@interface SetScoreRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger matchId;
@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,assign) NSInteger homeScore;
@property (nonatomic,assign) NSInteger awayScore;
@property (nonatomic,strong) NSString* protocolName;

- (void)setMatch:(Match *)match andIsMyTeamHome:(BOOL)isHome;

@end
