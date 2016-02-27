//
//  HttpMultipartConnection.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 16..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultRequest.h"

@class HttpMultipartConnection;

@protocol HttpMultipartConnectionDelegate
- (void)connectionDidFail:(HttpMultipartConnection*)httpConn;
- (void)connectionDidFinish:(HttpMultipartConnection*)httpConn;

@end

@interface HttpMultipartConnection : NSObject

@property (nonatomic,readonly) NSString* serverUrl;
@property (nonatomic,readonly) int TIMEOUT_CONNECTION;
@property (nonatomic,readonly) id delegate;
@property (nonatomic,readonly) id context;

@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,assign) NSInteger statusCode;

- (id)initWithRequest:(id<DefaultRequestProtocol>)request delegate:(id)inDelegate context:(id)inContext method:(NSString*)method;


@end
