//
//  AcceptMatchRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface AcceptMatchRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger matchId;
@property (nonatomic,strong) NSString* protocolName;

@end
