//
//  FacebookUtil.h
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 20..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void(^FacebookConnectionBlock)(BOOL, NSDictionary *);

@interface FacebookUtil : NSObject

+ (FacebookUtil *)getInstance;
+ (void)singleton;

- (void)openSessionWithCallback:(FacebookConnectionBlock)callback;
- (void)closeSession;

- (void)applicationDidBecomeActive;
- (BOOL)handleOpenUrl:(NSURL *)url;

@end;