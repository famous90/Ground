//
//  HttpMultipartConnection.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 16..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "HttpMultipartConnection.h"
#import "LocalUser.h"
#import "SBJson.h"

@implementation HttpMultipartConnection

- (id)initWithRequest:(id<DefaultRequestProtocol>)request delegate:(id)inDelegate context:(id)inContext method:(NSString *)method
{
    NSLog(@"http Multipart connection begins..");
    
    _serverUrl = [NSString stringWithFormat:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ServerUrl"], NSLocalizedString(@"subdomain", @"subdomain")];
    _TIMEOUT_CONNECTION = (int)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TimeoutConnection"];
    
    if( self = [super init] )
	{
        // delegate
        _delegate = inDelegate;
		_context = inContext;
        
        _receivedData = [NSMutableData data];
        _statusCode = 0;
        
        NSString* urlStr = [NSString stringWithFormat:@"%@%@", self.serverUrl, [request getProtocolName]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5000];
        
        // http 헤더 설정
        [urlRequest setHTTPMethod:method];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest addValue:[LocalUser getInstance].sessionKey forHTTPHeaderField:@"sessionKey"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // http 바디 설정
        if(request){
            
            NSDictionary* requestBody = [request getInfoDictionary];
            NSString *thumbnail = [requestBody valueForKey:@"thumbnail"];
            
            // 이미지 파일형태로 추가
            NSMutableData *body = [NSMutableData new];
            
            // http 바디에 이미지를 filebody형태로 저장하는 부분
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;  name=\"%@\"\r\n\r\n%@", @"thumbnail", thumbnail] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"thumbnail=%@\r\n", thumbnail] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"profile_photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            // 데이터 형태로 변환된 이미지 httpbody안으로 추가
            [body appendData:[NSData dataWithData:[request getImageData]]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [urlRequest setHTTPBody:body];
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
#pragma clang diagnostic pop
    }
    
    return self;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response respondsToSelector:@selector(statusCode)])
    {
        self.statusCode = [((NSHTTPURLResponse *)response) statusCode];
    }
    
	// this method is called when the server has determined that it
	// has enough information to create the NSURLResponse
	// it can be called multiple times, for example in the case of a
	// redirect, so each time we reset the data.
	// receivedData is declared as a method instance elsewhere
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// append the new data to the receivedData
	// receivedData is declared as a method instance elsewhere
	[self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([self.delegate respondsToSelector:@selector(connectionDidFail:)])
	{
		[self.delegate connectionDidFail:self];
	}
	
	// receivedData is declared as a method instance elsewhere
	self.receivedData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(connectionDidFinish:)])
	{
        if (self.statusCode >= 400)
        {
            [self.delegate connectionDidFail:self];
        }
        else
        {
	        [self.delegate connectionDidFinish:self];
        }
    }
	
	self.receivedData = nil;
}

@end
