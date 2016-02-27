//
//  Team.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *imageUrl;
@property (nonatomic, strong) NSNumber  *avgBirth;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger win;
@property (nonatomic, assign) NSInteger draw;
@property (nonatomic, assign) NSInteger lose;

- (id)initTeamWithData:(id)data;

@end
