//
//  UserInfo.m
//  httpPrac
//
//  Created by Jet on 13. 6. 7..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initUserInfoWithData:(id)data
{
    self = [super init];
    if(self){
        _userId = [[data valueForKey:@"id"] integerValue];
        _name = [data valueForKey:@"name"];
        _birthYear = [[data valueForKey:@"birthYear"] integerValue];
        _position = [[data valueForKey:@"position"] integerValue];
        _height = [[data valueForKey:@"height"] integerValue];
        _weight = [[data valueForKey:@"weight"] integerValue];
        _mainFoot = [[data valueForKey:@"mainFoot"] integerValue];
        _location1 = [self checkNullAndChangeToHyphen:[data valueForKey:@"location1"]];
        _location2 = [self checkNullAndChangeToHyphen:[data valueForKey:@"location2"]];
        _occupation = [[data valueForKey:@"occupation"] integerValue];
        _phoneNumber = [self checkNullAndChangeToHyphen:[data valueForKey:@"phoneNumber"]];
        _profileImageUrl = [data valueForKey:@"profileImageUrl"];
    }
    return self;
}

//- (id)initWithName:(NSString *)name wasBornIn:(NSInteger)birthYear andinPosition:(NSInteger)position inHeight:(NSInteger)height inWeight:(NSInteger)weight withMainFoot:(NSInteger)mainFoot andLiveIn:(NSString *)location1 andIn:(NSString *)location2 andDo:(NSInteger)occupation andHave:(NSString *)phoneNumber andLookLike:(NSString *)profileImageUrl
//{
//    self = [super init];
//    if(self){
//        _name = name;
//        _birthYear = birthYear;
//        _position = position;
//        _height = height;
//        _weight = weight;
//        _mainFoot = mainFoot;
//        _location1 = location1;
//        _location2 = location2;
//        _occupation = occupation;
//        _phoneNumber = phoneNumber;
//        _profileImageUrl = profileImageUrl;
//        
//        return self;
//    }
//    return nil;
//}

- (void)addMyProfileWithProfile:(UserInfo *)userInfo
{
    _name = userInfo.name;
    _birthYear = userInfo.birthYear;
    _position = userInfo.position;
    _height = userInfo.height;
    _weight = userInfo.weight;
    _mainFoot = userInfo.mainFoot;
    _location1 = userInfo.location1;
    _location2 = userInfo.location2;
    _occupation = userInfo.occupation;
    _phoneNumber = userInfo.phoneNumber;
    _profileImageUrl = userInfo.profileImageUrl;
}

- (NSString *)changeIntegerPropertyToStringInPropertyListWithPListName:(NSString *)plistName propertyNumber:(NSInteger)number
{
    if(number != -1){
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *plistURL = [bundle URLForResource:plistName withExtension:@"plist"];
        NSArray *list = [NSArray arrayWithContentsOfURL:plistURL];
        return [list objectAtIndex:number];
    }
    return @"-";
}

- (NSString *)mainFootWithPropertyMainFootNumber:(NSInteger)number
{
    if(number == 0){
        return @"왼발";
    }else if(number == 1){
        return @"오른발";
    }else{
        return @"-";
    }
}

- (NSString *)checkNullAndChangeToHyphen:(NSString *)string
{
    if([string isEqual:[NSNull null]])
        return @"-";
    else return string;
}

@end
