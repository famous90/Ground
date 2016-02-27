//
//  RemovePostRequest.h
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class Post;

@interface RemovePostRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger teamId;
@property (nonatomic,assign) NSInteger postId;
@property (nonatomic,strong) NSString* protocolName;

@property (nonatomic,strong) Post* post;

@end
