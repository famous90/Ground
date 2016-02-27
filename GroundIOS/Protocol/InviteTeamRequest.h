//
//  InviteTeamRequest.h
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 16..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface InviteTeamRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger matchId;
@property (nonatomic,assign) NSInteger homeTeamId;
@property (nonatomic,assign) NSInteger awayTeamId;
@property (nonatomic,strong) NSString* protocolName;

@end
