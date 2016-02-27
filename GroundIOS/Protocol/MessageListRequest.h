//
//  MessageListRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 6..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface MessageListRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger matchId;
@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,assign) NSInteger cur;
@property (nonatomic,strong) NSString* protocolName;

@end
