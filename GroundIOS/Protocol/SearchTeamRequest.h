//
//  SearchTeamRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface SearchTeamRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* protocolName;

@end
