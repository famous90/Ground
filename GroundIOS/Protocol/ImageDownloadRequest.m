//
//  ImageDownloadRequest.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 17..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "ImageDownloadRequest.h"

@implementation ImageDownloadRequest

- (ImageDownloadRequest*)init
{
    _protocolName = [[DefaultRequest getInstance] getProtocolName:@"download"];
    
    return self;
}

- (NSString*)getProtocolName
{
    return self.protocolName;
}

- (NSDictionary*)getInfoDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:self.imagePath forKey:@"path"];
    
    if(self.thumbnail){
        
        [dict setValue:@"true" forKey:@"thumbnail"];
    }
    else{
        
        [dict setValue:@"false" forKey:@"thumbnail"];
    }
    //[dict setValue:teamId forKey:@"teamId"];
    
    return dict;
}


@end
