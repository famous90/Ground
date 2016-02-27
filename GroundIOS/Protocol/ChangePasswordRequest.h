//
//  ChangePasswordRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface ChangePasswordRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* thePassword;
@property (nonatomic,strong) NSString* protocolName;

@end
