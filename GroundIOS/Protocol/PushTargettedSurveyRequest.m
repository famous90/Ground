//
//  PushTargettedSurveyRequest.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PushTargettedSurveyRequest.h"

@implementation PushTargettedSurveyRequest

- (PushTargettedSurveyRequest *)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"push_targetted_survey"];
    _pushUserIds = [[NSArray alloc] init];
    
    return self;
}

- (NSString *)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary *)getInfoDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSNumber numberWithInteger:self.matchId] forKey:@"matchId"];
    [dict setValue:[NSNumber numberWithInteger:self.teamId] forKey:@"teamId"];
    [dict setObject:self.pushUserIds forKey:@"pushIds"];
    
    return dict;
}

@end
