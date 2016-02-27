//
//  LocalUser.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 3..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalUser : NSObject<UIAlertViewDelegate>

@property (nonatomic,strong) NSString *pushToken;
@property (nonatomic,strong) NSString *deviceUuid;
@property (nonatomic,strong) NSString *deviceModel;
@property (nonatomic,assign) NSInteger deviceOSVer;
@property (nonatomic,assign) BOOL retina;
@property (nonatomic,assign) BOOL currentLocation;

@property (nonatomic,readonly) NSString* sessionFilePath;
@property (nonatomic,strong) NSString* sessionKey;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) NSString* userName;
@property (nonatomic,strong) NSString* userImageUrl;

+ (LocalUser*)getInstance;
+ (void)singleton;

- (void)setLocalUserInfo;
- (void)setLoginToken:(NSDictionary*)loginToken;
- (void)logout;

@end
