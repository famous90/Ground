//
//  JoinMatchRequest.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "JoinMatchRequest.h"

@implementation JoinMatchRequest

- (JoinMatchRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"join_match"];
    
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
    
    if(self.join){
        
        [dict setValue:@"true" forKey:@"join"];
    }else{
        
        [dict setValue:@"false" forKey:@"join"];
    }
    
    return dict;
}

@end
