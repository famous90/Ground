//
//  DenyMatchRequest.h
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 16..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface DenyMatchRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger matchId;
@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,strong) NSString* protocolName;

@end
