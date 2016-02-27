//
//  ViewUtil.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 9. 22..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
}

+ (UIImage *)circleMaskImageWithImage:(UIImage *)image
{
    UIImage *imageFrame = [UIImage imageNamed:@"detailMatch_teamImage_bg"];
    UIImage *theImage = [self maskImage:image withMask:[UIImage imageNamed:@"circleImageFrame"]];
    
    CGSize newImageSize = CGSizeMake(theImage.size.width, theImage.size.height);
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 1);
    }else{
        UIGraphicsBeginImageContext(newImageSize);
    }
//    [theImage drawAtPoint:CGPointMake(roundf((newImageSize.width - theImage.size.width)/2), roundf((newImageSize.height - theImage.size.height)/2))];
    CGFloat frameWidth = 2;
    [theImage drawInRect:CGRectMake(frameWidth, frameWidth, newImageSize.width - frameWidth*2, newImageSize.height - frameWidth*2)];
    [imageFrame drawInRect:CGRectMake(0, 0, theImage.size.width, theImage.size.height)];
//    [imageFrame drawAtPoint:CGPointMake(roundf((newImageSize.width - imageFrame.size.width)/2), roundf((newImageSize.height - imageFrame.size.height)/2))];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CGRect)adjustViewHeightForEditingWithView:(UIView *)view toFrame:(CGRect)textFieldFrame
{
    CGRect newFrame = view.frame;
    CGRect textFieldNewFrame = textFieldFrame;
    
    CGFloat keyboardPoint = textFieldNewFrame.origin.y + textFieldNewFrame.size.height;
    CGFloat textFieldDiffFromBottom = newFrame.size.height - keyboardPoint;
    if(textFieldDiffFromBottom < HEIGHT_OF_KEYBOARD){
        newFrame.origin.y -= (HEIGHT_OF_KEYBOARD - textFieldDiffFromBottom);
    }
    return newFrame;
}

+ (CGRect)adjustViewHeightForEndEdtingWithView:(UIView *)view toFrame:(CGRect)textFieldFrame
{
    CGRect newFrame = view.frame;
    CGRect textFieldNewFrame = textFieldFrame;
    
    CGFloat keyboardPoint = textFieldNewFrame.origin.y + textFieldNewFrame.size.height;
    CGFloat textFieldDiffFromBottom = newFrame.size.height - keyboardPoint;
    if(textFieldDiffFromBottom < HEIGHT_OF_KEYBOARD){
        newFrame.origin.y += (HEIGHT_OF_KEYBOARD - textFieldDiffFromBottom);
    }
    return newFrame;
}

+ (UIStoryboard *)storyboardForiPhoneDeviceScreenHeight
{
    UIStoryboard *storyboard;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == ScreenSizeForiPhone35) {
        storyboard = [UIStoryboard storyboardWithName:StoryboardNameForiPhone35 bundle:nil];
    }else if(iOSDeviceScreenSize.height == ScreenSizeForiPhone4){
        storyboard = [UIStoryboard storyboardWithName:StoryboardNameForiPhone4 bundle:nil];
    }
    
    return storyboard;
}

+ (CGRect)mapViewSizeInMakeTeamForiPhoneDeviceScreenHeight
{
    CGRect mapViewRect;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == ScreenSizeForiPhone35) {
        mapViewRect = CGRectMake(0, 0, 286, 143);
    }else if(iOSDeviceScreenSize.height == ScreenSizeForiPhone4){
        mapViewRect = CGRectMake(0, 0, 286, 190);
    }
    
    return mapViewRect;
}

+ (CGRect)mapViewSizeInMakeMatchForiPhoneDeviceScreenHeight
{
    CGRect mapViewRect;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == ScreenSizeForiPhone35) {
        mapViewRect = CGRectMake(0, 0, 286, 139);
    }else if(iOSDeviceScreenSize.height == ScreenSizeForiPhone4){
        mapViewRect = CGRectMake(0, 0, 286, 175);
    }
    
    return mapViewRect;
}

+ (CGRect)mapViewSizeInDetailMatchForiPhoneDeviceScreenHeight
{
    CGRect mapViewRect;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == ScreenSizeForiPhone35) {
        mapViewRect = CGRectMake(0, 0, 286, 73);
    }else if(iOSDeviceScreenSize.height == ScreenSizeForiPhone4){
        mapViewRect = CGRectMake(0, 0, 286, 105);
    }
    
    return mapViewRect;
}

+ (CGRect)mapViewSizeInMatchResultForiPhoneDeviceScreenHeight
{
    CGRect mapViewRect;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == ScreenSizeForiPhone35) {
        mapViewRect = CGRectMake(0, 0, 286, 108);
    }else if(iOSDeviceScreenSize.height == ScreenSizeForiPhone4){
        mapViewRect = CGRectMake(0, 0, 286, 155);
    }
    
    return mapViewRect;
}

+ (CGRect)mapViewSizeInEditTeamInfoForiPhoneDeviceScreenHeight
{
    CGRect mapViewRect;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == ScreenSizeForiPhone35) {
        mapViewRect = CGRectMake(0, 0, 286, 153);
    }else if(iOSDeviceScreenSize.height == ScreenSizeForiPhone4){
        mapViewRect = CGRectMake(0, 0, 286, 158);
    }
    
    return mapViewRect;
}

+ (BOOL)isImagePathUrl:(NSString *)imagePath
{
    if (imagePath != (id)[NSNull null]) {
        
        NSString *frontImagePath = [imagePath substringWithRange:NSMakeRange(0, 4)];

        if ([frontImagePath isEqualToString:@"http"]) {
            return YES;
        }
    }
    return NO;
}

+ (CGRect)height:(NSString *)string labelObject:(UILabel *)labelName
{
    CGSize maximumLabelSize = CGSizeMake(labelName.frame.size.width, MAXFLOAT);
    CGSize expectedLabelSize = [string sizeWithFont:labelName.font constrainedToSize:maximumLabelSize lineBreakMode:labelName.lineBreakMode];
    
    CGRect newFrame = labelName.frame;
    newFrame.size.height = expectedLabelSize.height;
    return newFrame;
}
@end
