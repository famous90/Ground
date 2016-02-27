//
//  ImageUploadRequest.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 16..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "DefaultRequest.h"

@interface ImageUploadRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSData* imageData;
@property (nonatomic,assign) BOOL thumbnail;
@property (nonatomic,strong) NSString* protocolName;

- (void)convertImageToData:(UIImage*)image;

@end
