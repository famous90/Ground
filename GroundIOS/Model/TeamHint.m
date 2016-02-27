//
//  MyTeams.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "TeamHint.h"
#import "TeamInfo.h"

@implementation TeamHint

- (id)initWithTeamId:(NSInteger)teamId TeamName:(NSString *)name teamImage:(NSString *)imageUrl isManager:(BOOL)isManager
{
    self = [super init];
    if(self){
        _teamId = teamId;
        _name = name;
        _imageUrl = imageUrl;
        _isManaged = isManager;
    }
    return self;
}

- (id)initWithTeamData:(id)teamData
{
    self = [super init];
    if(self){
        _teamId = [[teamData valueForKey:@"id"] intValue];
        _name = [teamData valueForKey:@"name"];
        _imageUrl = [teamData valueForKey:@"imageUrl"];
        _isManaged = [[teamData valueForKey:@"managed"] boolValue];
    }
    return self;
}

- (void)setTeamInfoWithData:(NSDictionary *)teamData
{
    self.teamId = [[teamData valueForKey:@"id"] integerValue];
    self.name = [teamData valueForKey:@"name"];
    self.imageUrl = [teamData valueForKey:@"imageUrl"];
    self.isManaged = [[teamData valueForKey:@"managed"] boolValue];
}

- (void)setTeamHintWithTeamInfo:(TeamInfo *)teamInfo
{
    self.teamId = [teamInfo teamId];
    self.name = [teamInfo name];
    self.imageUrl = [teamInfo imageUrl];
}

- (void)setTeamhintWithTeamId:(NSInteger)teamId name:(NSString *)name imageUrl:(NSString *)imageUrl
{
    self.teamId = teamId;
    self.name = name;
    self.imageUrl = imageUrl;
}

@end
