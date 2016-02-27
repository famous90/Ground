//
//  LocalUser.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 3..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "LocalUser.h"
#import "GroundClient.h"
#import "FacebookUtil.h"
#import "StringUtils.h"
#import "Util.h"
#import "sys/utsname.h"

@implementation LocalUser

static LocalUser* instance;

+ (LocalUser*)getInstance
{
    return instance;
}

+ (void)singleton
{
    instance = [[LocalUser alloc] init];
}

- (LocalUser*)init
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    _sessionFilePath = [documentsDirectory stringByAppendingPathComponent:@"AnB.dat"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // AnB.dat 파일에 있는 로그인 정보를 각 변수에 저장.
    if ([fileManager fileExistsAtPath:self.sessionFilePath]){
        
        NSMutableData *theData = [NSData dataWithContentsOfFile:self.sessionFilePath];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
        //our decoder allows us to easily access information inside our "theData" object.
        
        _sessionKey = [decoder decodeObjectForKey:@"sessionKey"];
        _userId = [[decoder decodeObjectForKey:@"userId"] integerValue];
        [decoder finishDecoding];
        
        NSLog(@"sessionkey = %@, userId = %d", self.sessionKey, self.userId);
    }
    
    return self;
}

- (void)setLocalUserInfo
{
    __block BOOL ready = NO;

    // 디바이스 Uuid 등록.
    _deviceUuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;

    if(self.sessionKey){

        [[GroundClient getInstance] getUserInfo:self.userId callback:^(BOOL result, NSDictionary *data) {

            if(result){

                _userName = [[data objectForKey:@"userInfo"] valueForKey:@"name"];
                _userImageUrl = [[data objectForKey:@"userInfo"] valueForKey:@"profileImageUrl"];

                ready = YES;
            }else {
                NSLog(@"error to set local user info in local user");
                [self logout];
            }
        }];

        while(ready == NO){

            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }else{

        self.sessionKey = nil;
    }
    
    // 햔제위치 트래킹 수락여부.
    _currentLocation = YES;
    // 디바이스 모델명 등록.
    [self setDeviceModel];
}

- (void)setDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    // device os version
    _deviceOSVer = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    NSString *deviceInfo = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if([[deviceInfo substringToIndex:1] isEqualToString:@"i"]){
        // devicemodel 등록.
        _deviceModel = [[UIDevice currentDevice] model];
        
        // iphone or ipad 구분.
        if([[deviceInfo substringWithRange:NSMakeRange(1, 6)] isEqualToString:@"iPhone"]){
            
            if([[deviceInfo substringWithRange:NSMakeRange(6, 1)] intValue] >= 3){
                _retina = YES;
                
            }else{
                _retina = NO;
            }
        }
        else if([[deviceInfo substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"iPad"]){
            
            // iPad 등록관련 코드.
        }
    }
    else{
        
        NSLog(@"iphone simulator...");
    }
}

- (void)setLoginToken:(NSDictionary*)loginToken
{
    if(!self.sessionKey){
        self.sessionKey = [loginToken valueForKey:@"sessionKey"];
    }
    self.userId = [[loginToken valueForKey:@"userId"] integerValue];
    self.userName = [loginToken valueForKey:@"name"];
    self.userImageUrl = [loginToken valueForKey:@"imageUrl"];
    
    [self saveLoginInfo];
}

// 로그인 정보 파일에 암호화된 형태로 저장.
- (void)saveLoginInfo
{
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
    
    [encoder encodeObject:self.sessionKey forKey:@"sessionKey"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [encoder finishEncoding];
    
    [theData writeToFile:self.sessionFilePath atomically:YES];
}

- (void)logout
{
    __block BOOL ready = NO;
    
    [[GroundClient getInstance] logout:self.deviceUuid callback:^(BOOL result, NSDictionary *data) {
        if(result){
            ready = YES;
            
        }else{
            NSLog(@"Failed to delete deviceUuid!!!!!");
            [Util showAlertView:self message:@"로그아웃 도중 심각한 에러가 발생했습니다\n앱을 강제종료합니다"];
        }
    }];
    
    while(!ready)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    //Push Unregister
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    // facebook session 닫기
    [[FacebookUtil getInstance] closeSession];
    
    // Local에 저장된 정보 삭제
    self.sessionKey = NULL;
    self.userId = 0;
    self.userName = NULL;
    self.userImageUrl = NULL;
    
    // Device에 저장된 파일 삭제
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSError* error;
    
    if ([fileMgr removeItemAtPath:self.sessionFilePath error:&error] != YES){
        
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        //Push Unregister
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
        // facebook session 닫기
        [[FacebookUtil getInstance] closeSession];
        
        // Local에 저장된 정보 삭제
        self.sessionKey = NULL;
        self.userId = 0;
        self.userName = NULL;
        self.userImageUrl = NULL;
        
        // Device에 저장된 파일 삭제
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        NSError* error;
        
        if ([fileMgr removeItemAtPath:self.sessionFilePath error:&error] != YES){
            
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
        
        exit(0);
    }
}

/*
 - (User *)initUser{
 if ((self = [super init]))
 {
 [self setUId:0];
 [self setPassWord:nil];
 [self setUserName:nil];
 }
 return self;
 }
 
 //when using the class this will be called: creates one instance
 + (User *) getInstance{
 // Persistent instance.
 static User *_default = nil;
 
 // Small optimization to avoid wasting time after the
 // singleton being initialized.
 if (_default != nil)
 {
 return _default;
 }
 
 #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
 // Allocates once with Grand Central Dispatch (GCD) routine.
 // It's thread safe.
 static dispatch_once_t safer;
 dispatch_once(&safer, ^(void)
 {
 _default = [[User alloc] initUser];
 });
 #else
 // Allocates once using the old approach, it's slower.
 // It's thread safe.
 @synchronized([User class])
 {
 // The synchronized instruction will make sure,
 // that only one thread will access this point at a time.
 if (_default == nil)
 {
 _default = [[User alloc] initUser];
 }
 }
 #endif
 return _default;
 }
 */

@end
