//
//  WritePostRequest.h
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 14..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@class Post;

@interface WritePostRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userImageUrl;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString   *extra;
@property (nonatomic, assign) NSInteger createdAt;

@property (nonatomic, strong) NSString *protocolName;

@property (nonatomic,strong) Post* post;

@end
