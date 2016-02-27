//
//  UserInfo.h
//  httpPrac
//
//  Created by Jet on 13. 6. 7..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger birthYear;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger mainFoot;
@property (nonatomic, strong) NSString  *location1;
@property (nonatomic, strong) NSString  *location2;
@property (nonatomic, assign) NSInteger occupation;
@property (nonatomic, strong) NSString  *phoneNumber;
@property (nonatomic, strong) NSString  *profileImageUrl;

// init
- (id)initUserInfoWithData:(id)data;
//- (id)initWithName:(NSString *)name wasBornIn:(NSInteger)birthYear andinPosition:(NSInteger)position inHeight:(NSInteger)height inWeight:(NSInteger)weight withMainFoot:(NSInteger)mainFoot andLiveIn:(NSString *)location1 andIn:(NSString *)location2 andDo:(NSInteger)occupation andHave:(NSString *)phoneNumber andLookLike:(NSString *)profileImageUrl;

// method
- (void)addMyProfileWithProfile:(UserInfo *)userInfo;
- (NSString *)changeIntegerPropertyToStringInPropertyListWithPListName:(NSString *)plistName propertyNumber:(NSInteger)number;
- (NSString *)mainFootWithPropertyMainFootNumber:(NSInteger)number;

@end
