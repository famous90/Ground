//
//  ViewUtil.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 22..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtil : NSObject

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage *)circleMaskImageWithImage:(UIImage *)image;

+ (CGRect)adjustViewHeightForEditingWithView:(UIView *)view toFrame:(CGRect)textFieldFrame;
+ (CGRect)adjustViewHeightForEndEdtingWithView:(UIView *)view toFrame:(CGRect)textFieldFrame;
+ (UIStoryboard *)storyboardForiPhoneDeviceScreenHeight;

+ (CGRect)mapViewSizeInMakeTeamForiPhoneDeviceScreenHeight;
+ (CGRect)mapViewSizeInMakeMatchForiPhoneDeviceScreenHeight;
+ (CGRect)mapViewSizeInDetailMatchForiPhoneDeviceScreenHeight;
+ (CGRect)mapViewSizeInMatchResultForiPhoneDeviceScreenHeight;
+ (CGRect)mapViewSizeInEditTeamInfoForiPhoneDeviceScreenHeight;

+ (BOOL)isImagePathUrl:(NSString *)imagePath;

+ (CGRect)height:(NSString *)string labelObject:(UILabel *)labelName;
@end
