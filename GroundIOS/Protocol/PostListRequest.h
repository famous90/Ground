//
//  PostListRequest.h
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface PostListRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,assign) NSInteger lastPostId;
@property (nonatomic,strong) NSString* protocolName;

@end
