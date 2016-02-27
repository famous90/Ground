//
//  RegisterTeamRequest.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 20..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "DefaultRequest.h"

@class TeamInfo;

@interface RegisterTeamRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* teamName;
@property (nonatomic,strong) NSString* teamImageUrl;
@property (nonatomic,strong) NSString *teamAddress;
@property (nonatomic,strong) NSNumber* latitude;
@property (nonatomic,strong) NSNumber* longitude;
@property (nonatomic,strong) NSString* protocolName;

@property (nonatomic,strong) TeamInfo* teamInfo;

@end
