//
//  ChangeManagerRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface ChangeManagerRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,strong) NSArray* theManagerId;
@property (nonatomic,strong) NSArray* oldManagerId;
@property (nonatomic,strong) NSString* protocolName;

@end
