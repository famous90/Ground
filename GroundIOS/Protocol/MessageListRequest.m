//
//  MessageListRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 6..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "MessageListRequest.h"

@implementation MessageListRequest

- (MessageListRequest*)init
{
   _protocolName = [[DefaultRequest getInstance] getProtocolName:@"message_list"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSNumber numberWithInteger:self.matchId] forKey:@"matchId"];
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setValue:[NSNumber numberWithInteger:self.cur] forKey:@"cur"];
    
    return dict;
}

@end
