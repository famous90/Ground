//
//  Feed.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 23..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "Feed.h"
#import "SBJson.h"

@implementation Feed

- (id)initFeedWithData:(id)data
{
    self = [super init];
    if(self){
        _feedId = [[data valueForKey:@"id"] integerValue];
        _type = [[data valueForKey:@"type"] integerValue];
        NSMutableDictionary *messageData = [[[SBJsonParser alloc] init] objectWithString:[data valueForKey:@"message"]];
        _userId = [[messageData valueForKey:@"memberId"] integerValue];
        _userName = [messageData valueForKey:@"memberName"];
        _teamId = [[messageData valueForKey:@"teamId"] integerValue];
        _teamName = [messageData valueForKey:@"teamName"];
        _requestedTeamId = [[messageData valueForKey:@"requestedTeamId"] integerValue];
        _requestedTeamName = [messageData valueForKey:@"requestedTeamName"];
        _homeTeamName = [messageData valueForKey:@"homeTeamName"];
        _awayTeamName = [messageData valueForKey:@"awayTeamName"];
        _matchId = [[messageData valueForKey:@"matchId"] integerValue];
        _createdAt = [[data valueForKey:@"createdAt"] floatValue]/1000;
    }
    return self;
}

@end
