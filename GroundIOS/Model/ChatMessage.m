//
//  ChatMessage.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ChatMessage.h"
#import "TeamHint.h"

@implementation ChatMessage

- (id)initWithData:(NSDictionary*)data
{
    if([data valueForKey:@"id"] != nil){
        _messageId = [[data valueForKey:@"id"] integerValue];
    }
    
    _matchId = [[data valueForKey:@"matchId"] integerValue];
    _teamId = [[data valueForKey:@"teamId"] integerValue];
    _teamName = [data valueForKey:@"teamName"];
    _teamImageUrl = [data valueForKey:@"teamImageUrl"];
    _message = [data valueForKey:@"msg"];
//    if ([[data valueForKey:@"ack"] integerValue]) {
//        _ACK = YES;
//    }else _ACK = NO;
    _ACK = [[data valueForKey:@"ack"] boolValue];
//    NSLog(@"ACK : %d", [[data valueForKey:@"ack"] boolValue]);
    
    return self;
}

- (id)initSendMessageWithMessage:(NSString *)msg messageId:(NSInteger)msgId matchId:(NSInteger)matchId teamHint:(TeamHint *)teamHint
{
    self = [super init];
    if (self) {
        _messageId = msgId;
        _matchId = matchId;
        _teamId = teamHint.teamId;
        _teamName = teamHint.name;
        _teamImageUrl = teamHint.imageUrl;
        _message = msg;
        _ACK = false;
    }
    return self;
}

- (void)setMessageData:(NSDictionary*)data
{
    if([data valueForKey:@"id"] != nil){
        self.messageId = [[data valueForKey:@"id"] integerValue];
    }
    
    self.matchId = [[data valueForKey:@"matchId"] integerValue];
    self.teamId = [[data valueForKey:@"teamId"] integerValue];
    self.teamName = [data valueForKey:@"teamName"];
    self.teamImageUrl = [data valueForKey:@"teamImageUrl"];
    self.message = [data valueForKey:@"msg"];
    self.ACK = [[data valueForKey:@"ack"] boolValue];
//    if ([[data valueForKey:@"ack"] integerValue]) {
//        self.ACK = YES;
//    }else self.ACK = NO;

}

@end
