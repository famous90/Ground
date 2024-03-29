//
//  RemoveCommentRequest.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 19..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "DefaultRequest.h"

@interface RemoveCommentRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,assign) NSInteger postId;
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,strong) NSString* protocolName;

@end
