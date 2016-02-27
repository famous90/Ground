//
//  HttpConnection.h
//  httpPrac
//
//  Created by Jet on 13. 6. 6..
//  Copyright (c) 2013년 Jet. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DefaultRequest.h"

@class HttpConnection;

@protocol HttpConnectionDelegate
- (void)connectionDidFail:(HttpConnection*)httpConn;
- (void)connectionDidFinish:(HttpConnection*)httpConn;

@end

@interface HttpConnection : NSObject

@property (nonatomic,readonly) NSString* serverUrl;
@property (nonatomic,readonly) int TIMEOUT_CONNECTION;
@property (nonatomic,readonly) id delegate;
@property (nonatomic,readonly) id context;

@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,assign) NSInteger statusCode;

- (id)initWithRequest:(id<DefaultRequestProtocol>)request delegate:(id)inDelegate context:(id)inContext method:(NSString*)method;

@end
