//
//  DefaultRequest.h
//  HttpConnPrac
//
//  Created by Jet on 13. 6. 25..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DefaultRequest;

@protocol DefaultRequestProtocol<NSObject>
@required
- (NSString*)getProtocolName;
@optional
- (NSDictionary*)getInfoDictionary;
- (NSData*)getImageData;
@end

@interface DefaultRequest : NSObject

+ (DefaultRequest*)getInstance;
+ (void)singleton;

- (NSString*)getProtocolName:(NSString*)requestType;
- (void)getProtocolList;
@end
