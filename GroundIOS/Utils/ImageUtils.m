//
//  ImageUtils.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 10..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ImageUtils.h"
#import "LocalUser.h"

@implementation ImageUtils

static ImageUtils *instance;

+ (ImageUtils *)getInstance
{
    return instance;
}

+ (void)singleton
{
    instance = [[ImageUtils alloc] init];
}

+ (NSData*)compressImageToUpload:(UIImage *)image
{
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 50*1024;
    
//    float imageWidth = image.size.width;
//    float imageHeight = image.size.height;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    NSLog(@"compression = %f, filesize = %d", compression, [imageData length]);
    
    return imageData;
}

+ (UIImage*)scaleImage:(UIImage *)image ToSize:(CGSize)newSize
{
    CGRect rect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    
    if([LocalUser getInstance].retina){
        
        rect = CGRectMake(0.0, 0.0, newSize.width*2, newSize.height*2);
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*)scaleImageToUpload:(UIImage *)originalImage
{
    float actualWidth = originalImage.size.width;
    float actualHeight = originalImage.size.height;
    
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 640.0/1136.0;
    
    if(imgRatio != maxRatio){
        
        if(imgRatio > maxRatio){
            
            imgRatio = 640.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 1136.0;
        }
        else{
            
            imgRatio = 640.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 640.0;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [originalImage drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*)scaleImageToShow:(UIImage *)savedImage toSize:(CGSize)size
{
    float savedImageWidth = savedImage.size.width;
    float savedImageHeight = savedImage.size.height;
    
    float savedImgRatio = savedImageWidth/savedImageHeight;
    float scaleRatio = size.width/size.height;
    
    if(savedImgRatio != scaleRatio){
        
        if(savedImgRatio > scaleRatio){
            
            savedImgRatio = size.width / savedImageHeight;
            savedImageWidth = savedImgRatio * savedImage.size.width;
            savedImageHeight = size.height;
        }
        else{
            
            savedImgRatio = size.height / savedImageWidth;
            savedImageHeight = savedImgRatio * savedImage.size.height;
            savedImageWidth = size.width;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, savedImageWidth, savedImageHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [savedImage drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
