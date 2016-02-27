//
//  ImageDownloadRequest.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 17..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "DefaultRequest.h"

@interface ImageDownloadRequest : DefaultRequest<DefaultRequestProtocol>

@property (nonatomic,strong) NSString* imagePath;
@property (nonatomic,assign) BOOL thumbnail;
@property (nonatomic,strong) NSString* protocolName;

@end
