//
//  SearchMatchRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface SearchMatchRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,strong) NSNumber* latitude;
@property (nonatomic,strong) NSNumber* longitude;
@property (nonatomic,assign) NSInteger distance;
@property (nonatomic,strong) NSString* protocolName;

@end
