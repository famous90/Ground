//
//  IMRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 5..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class TeamHint;
@class ChatMessage;

@interface IMRequest : NSObject

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, assign) BOOL ACK;

- (NSDictionary*)getInfoDictionary;
- (void)setWithChatMessage:(ChatMessage *)chatMessage;

@end
