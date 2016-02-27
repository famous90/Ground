//
//  RegisterGroundRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class Ground;

@interface RegisterGroundRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSNumber* latitude;
@property (nonatomic,strong) NSNumber* longitude;
@property (nonatomic,strong) NSString* protocolName;

@property (nonatomic,strong) Ground* ground;

@end
