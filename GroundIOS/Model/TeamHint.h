//
//  MyTeams.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeamInfo;

@interface TeamHint : NSObject

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *imageUrl;
@property (nonatomic, assign) BOOL      isManaged;

- (id)initWithTeamId:(NSInteger)teamId TeamName:(NSString *)name teamImage:(NSString *)imageUrl isManager:(BOOL)isManager;
- (id)initWithTeamData:(id)teamData;
- (void)setTeamInfoWithData:(NSDictionary *)teamData;
- (void)setTeamHintWithTeamInfo:(TeamInfo *)teamInfo;
- (void)setTeamhintWithTeamId:(NSInteger)teamId name:(NSString *)name imageUrl:(NSString *)imageUrl;

@end
