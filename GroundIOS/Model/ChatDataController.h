//
//  ChatDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatMessage;

@interface ChatDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterData;

- (NSUInteger)countOfList;
- (void)addChatMessageWithData:(ChatMessage *)chatMessage;
- (ChatMessage *)objectInMasterDataAtIndex:(NSUInteger)theIndex;
- (ChatMessage *)objectInMasterDataWithMessageId:(NSInteger)msgId;
- (void)sortChatMessageById;
- (NSUInteger)getBottomMessageId;
- (void)removeChatMessageWithMessageId:(NSInteger)msgId;

@end
