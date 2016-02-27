//
//  LoginRequest.h
//  httpPrac
//
//  Created by Jet on 13. 6. 5..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultRequest.h"

@interface LoginRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* protocolName;

@end
