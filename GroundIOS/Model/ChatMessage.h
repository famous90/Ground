//
//  ChatMessage.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeamHint;

@interface ChatMessage : NSObject

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) NSString* teamName;
@property (nonatomic, strong) NSString* teamImageUrl;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, assign) BOOL ACK;

- (id)initWithData:(NSDictionary*)data;
- (id)initSendMessageWithMessage:(NSString *)msg messageId:(NSInteger)msgId matchId:(NSInteger)matchId teamHint:(TeamHint *)teamHint;
- (void)setMessageData:(NSDictionary*)data;

@end
