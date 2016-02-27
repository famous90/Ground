//
//  IMRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 5..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "IMRequest.h"
#import "TeamHint.h"
#import "ChatMessage.h"

@implementation IMRequest

- (IMRequest*)init
{
    self.teamHint = [[TeamHint alloc] init];
    self.message = [NSString new];
    
    return self;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.messageId] forKey:@"id"];
    [dict setValue:[NSNumber numberWithInteger:self.matchId] forKey:@"matchId"];
    [dict setValue:[NSNumber numberWithInteger:self.teamHint.teamId] forKey:@"teamId"];
    [dict setValue:self.teamHint.name forKey:@"teamName"];
    [dict setValue:self.teamHint.imageUrl forKey:@"teamImageUrl"];
    [dict setValue:self.message forKey:@"msg"];
    [dict setValue:[NSNumber numberWithBool:self.ACK] forKey:@"ack"];
    
    return dict;
}

- (void)setWithChatMessage:(ChatMessage *)chatMessage
{
    _messageId = chatMessage.messageId;
    _matchId = chatMessage.matchId;
    _message = chatMessage.message;
    TeamHint *teamHint = [[TeamHint alloc] init];
    teamHint.teamId = chatMessage.teamId;
    teamHint.name = chatMessage.teamName;
    teamHint.imageUrl = chatMessage.teamImageUrl;
    _teamHint = teamHint;
    _ACK = chatMessage.ACK;
}

@end
