//
//  MatchHistoryRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface MatchHistoryRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,assign) NSInteger lastMatchId;
@property (nonatomic,strong) NSString* protocolName;

@end
