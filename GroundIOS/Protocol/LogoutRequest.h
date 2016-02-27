//
//  LogoutRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface LogoutRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic, strong) NSString *deviceUuid;
@property (nonatomic, strong) NSString *protocolName;

@end
