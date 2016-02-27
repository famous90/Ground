//
//  ChatDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ChatDataController.h"
#import "ChatMessage.h"

@implementation ChatDataController

- (id)init
{
    self = [super init];
    if (self) {
        self.masterData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfList
{
    return [self.masterData count];
}

- (void)addChatMessageWithData:(ChatMessage *)chatMessage
{
//    if (![self isMessageInListWithMessageId:chatMessage.messageId]) {
    [self.masterData addObject:chatMessage];
//    }
}

- (ChatMessage *)objectInMasterDataAtIndex:(NSUInteger)theIndex
{
    return [self.masterData objectAtIndex:theIndex];
}

- (ChatMessage *)objectInMasterDataWithMessageId:(NSInteger)msgId
{
    for(int index = 0 ; index < [self.masterData count] ; index++){
        ChatMessage *chatMessage = [self.masterData objectAtIndex:index];
        if (chatMessage.messageId == msgId) {
            return chatMessage;
        }
    }
    return nil;
}

- (void)sortChatMessageById
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"messageId" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self.masterData sortUsingDescriptors:sortDescriptors];
}

- (NSUInteger)getBottomMessageId
{
    return [[self.masterData lastObject] messageId];
}

- (BOOL)isMessageInListWithMessageId:(NSInteger)messageId
{
    for( ChatMessage *chatMessage in self.masterData){
        if (chatMessage.messageId == messageId) {
            return YES;
        }
    }
    return NO;
}

- (void)removeChatMessageWithMessageId:(NSInteger)msgId
{
    for(int index = 0 ; index < [self.masterData count] ; index++){
        ChatMessage *chatMessage = [self.masterData objectAtIndex:index];
        if (chatMessage.messageId == msgId) {
            [self.masterData removeObjectAtIndex:index];
        }
    }
}

@end
