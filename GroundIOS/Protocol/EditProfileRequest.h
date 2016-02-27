//
//  EditProfileRequest.h
//  GroundIOS
//
//  Created by Jet on 13. 7. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultRequest.h"

@class UserInfo;

@interface EditProfileRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* location1;
@property (nonatomic,strong) NSString* location2;
@property (nonatomic,strong) NSString* phoneNumber;
@property (nonatomic,strong) NSString* profileImageUrl;
@property (nonatomic,strong) NSString* protocolName;

@property (nonatomic,assign) NSInteger birthYear;
@property (nonatomic,assign) NSInteger position;
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,assign) NSInteger weight;
@property (nonatomic,assign) NSInteger mainFoot;
@property (nonatomic,assign) NSInteger occupation;

@property (nonatomic,strong) UserInfo* userInfo;

@end