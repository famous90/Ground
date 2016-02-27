//
//  TeamInfo.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 20..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "TeamInfo.h"

@implementation TeamInfo

- (id)initTeamInfoWithData:(id)data
{
    self = [super init];
    if(self){
        _teamId = [[data valueForKey:@"id"] integerValue];
        _name = [data valueForKey:@"name"];
        _imageUrl = [data valueForKey:@"imageUrl"];
        _address = [data valueForKey:@"address"];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        NSInteger year = [components year];
        _avgBirth = [NSNumber numberWithFloat:(year - [[data valueForKey:@"avgBirth"] floatValue])];
        _score = [[data valueForKey:@"score"] integerValue];
        _win = [[data valueForKey:@"win"] integerValue];
        _draw = [[data valueForKey:@"draw"] integerValue];
        _lose = [[data valueForKey:@"lose"] integerValue];
        _membersCount = [[data valueForKey:@"membersCount"] integerValue];
        _latitude = [data valueForKey:@"latitude"];
        _longitude = [data valueForKey:@"longitude"];
    }
    return self;
}

@end
