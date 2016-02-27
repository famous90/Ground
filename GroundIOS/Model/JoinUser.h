//
//  JoinUser.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinUser : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *imageUrl;
@property (nonatomic, assign) NSInteger join;

- (id)initJoinUserWithData:(id)data;
- (id)initWithUser:(NSInteger)userId name:(NSString *)name imageUrl:(NSString *)imageUrl join:(NSInteger)join;

@end
