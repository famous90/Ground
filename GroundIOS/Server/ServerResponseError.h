//
//  ServerResponseError.h
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 4..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResponseError : NSObject

+ (void)emailLoginError:(NSInteger)code delegate:(id)delegate;
+ (void)emailValidateError:(NSInteger)code delegate:(id)delegate;
+ (void)forgotPasswordError:(NSInteger)code delegate:(id)delegate;

@end
