//
//  KakaotalkUtil.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KakaotalkUtil : NSObject
{
    @private
}

///Returns whether the application can open kakaolink URLs.
+ (BOOL)canOpenKakaoLink;

// Opens kakaolink with parameters.
+ (BOOL)openKakaoLinkWithURL:(NSString *)referenceURLString
				  appVersion:(NSString *)appVersion
				 appBundleID:(NSString *)appBundleID
					 appName:(NSString *)appName
					 message:(NSString *)message;

// Opens kakaoApplink with parameters.
+ (BOOL)openKakaoAppLinkWithMessage:(NSString *)message
								URL:(NSString *)referenceURLString
						appBundleID:(NSString *)appBundleID
						 appVersion:(NSString *)appVersion
							appName:(NSString *)appName
					  metaInfoArray:(NSArray *)metaInfoArray;

@end