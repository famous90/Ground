//
//  Post.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userImageUrl;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger teamFeedType;
@property (nonatomic, strong) NSString  *message;
@property (nonatomic, strong) NSString  *postImageUrl;
@property (nonatomic, assign) NSTimeInterval createdAt;
@property (nonatomic, assign) NSInteger commentCount;

- (id)initInTeam:(NSInteger)teamId byWriterId:(NSInteger)userId byWriterName:(NSString *)userName withWriterImage:(NSString *)userImageUrl aboutMessage:(NSString *)message withExtra:(NSString *)extra;
- (id)initPostWithData:(id)postData;
- (BOOL)isPostImageInPost;

@end
