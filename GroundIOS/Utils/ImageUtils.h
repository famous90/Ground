//
//  ImageUtils.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

+ (ImageUtils *)getInstance;
+ (void)singleton;

+ (NSData*)compressImageToUpload:(UIImage *)originalImage;
+ (UIImage*)scaleImage:(UIImage *)image ToSize:(CGSize)newSize;
+ (UIImage*)scaleImageToUpload:(UIImage*)originalImage;
+ (UIImage*)scaleImageToShow:(UIImage*)savedImage toSize:(CGSize)size;

@end
