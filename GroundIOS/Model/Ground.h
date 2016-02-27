//
//  Ground.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 11..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ground : NSObject

@property (nonatomic, assign) NSInteger groundId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSNumber  *latitude;
@property (nonatomic, strong) NSNumber  *longitude;

- (id)initGroundWithData:(id)data;
- (id)initWithGround:(Ground *)ground;

@end
