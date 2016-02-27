//
//  Comment.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 23..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userImageUrl;
@property (nonatomic, strong) NSString  *message;
@property (nonatomic, assign) NSTimeInterval createdAt;

- (id)initCommentWithData:(id)data;

@end
