//
//  TeamInfo.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 20..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamInfo : NSObject

@property (nonatomic,assign) NSInteger  teamId;
@property (nonatomic,strong) NSString   *name;
@property (nonatomic,strong) NSString   *imageUrl;
@property (strong,nonatomic) NSString   *address;
@property (nonatomic,strong) NSNumber   *avgBirth;
@property (nonatomic,assign) NSInteger  score;
@property (nonatomic,assign) NSInteger  win;
@property (nonatomic,assign) NSInteger  draw;
@property (nonatomic,assign) NSInteger  lose;
@property (nonatomic,assign) NSInteger  membersCount;
@property (nonatomic,strong) NSNumber   *latitude;
@property (nonatomic,strong) NSNumber   *longitude;

- (id)initTeamInfoWithData:(id)data;

@end