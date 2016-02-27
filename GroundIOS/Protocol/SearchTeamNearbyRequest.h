//
//  SearchTeamNearbyRequest.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 6..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface SearchTeamNearbyRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic, strong) NSString *protocolName;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longituge;
@property (nonatomic, assign) NSInteger distance;

@end
