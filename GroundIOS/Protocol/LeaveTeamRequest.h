//
//  LeaveTeamRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface LeaveTeamRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) NSString *protocolName;

@end
