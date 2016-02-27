//
//  ImageUploadRequest.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 16..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "ImageUploadRequest.h"
#import "ImageUtils.h"

@implementation ImageUploadRequest

- (ImageUploadRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"upload"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

// 이미지 데이터 형태로 변환.
- (void)convertImageToData:(UIImage*)image
{
    self.imageData = [ImageUtils compressImageToUpload:image];
    
//    self.imageData = UIImageJPEGRepresentation(image, 1.0);
//    self.imageData = UIImagePNGRepresentation(image);
}

- (NSData*)getImageData
{
    return self.imageData;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    if(self.thumbnail){
        
        [dict setValue:@"true" forKey:@"thumbnail"];
    }
    else{
        
        [dict setValue:@"false" forKey:@"thumbnail"];
    }
    
    return dict;
}

@end
