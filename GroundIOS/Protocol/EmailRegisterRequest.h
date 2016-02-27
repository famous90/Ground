//
//  EmailRegisterRequest.h
//  GroundIOS
//
//  Created by Jet on 13. 7. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultRequest.h"

@interface EmailRegisterRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* protocolName;

@end
