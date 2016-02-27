//
//  ValidateEmailRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface ValidateEmailRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *protocolName;

@end
