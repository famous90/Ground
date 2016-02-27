//
//  FacebookLoginRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface FacebookLoginRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* imageUrl;
@property (nonatomic,strong) NSString* protocolName;

@end
