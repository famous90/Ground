//
//  EditTeamProfileRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class TeamInfo;

@interface EditTeamProfileRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,strong) NSString* teamImageUrl;
@property (nonatomic,strong) NSString* teamAddress;
@property (nonatomic,strong) NSNumber* latitude;
@property (nonatomic,strong) NSNumber* longitude;
@property (nonatomic,strong) NSString* protocolName;

@property (nonatomic,strong) TeamInfo* teamInfo;

@end
