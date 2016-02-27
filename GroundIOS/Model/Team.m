//
//  Team.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 12..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "Team.h"

@implementation Team

- (id)initTeamWithData:(id)data
{
    self = [super init];
    if(self){
        _teamId = [[data valueForKey:@"id"] integerValue];
        _name = [data valueForKey:@"name"];
        _imageUrl = [data valueForKey:@"imageUrl"];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        NSInteger year = [components year];
        _avgBirth = [NSNumber numberWithFloat:(year - [[data valueForKey:@"avgBirth"] floatValue])];
        _score = [[data valueForKey:@"score"] integerValue];
        _win = [[data valueForKey:@"win"] integerValue];
        _draw = [[data valueForKey:@"draw"] integerValue];
        _lose = [[data valueForKey:@"lose"] integerValue];
    }
    return self;
}

@end
