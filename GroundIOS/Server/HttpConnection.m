//
//  HttpConnection.m
//  httpPrac
//
//  Created by Jet on 13. 6. 6..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "HttpConnection.h"
#import "LocalUser.h"
#import "Config.h"
#import "SBJson.h"

@implementation HttpConnection

- (id)initWithRequest:(id<DefaultRequestProtocol>)request delegate:(id)inDelegate context:(id)inContext method:(NSString*)method
{
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
        
        [urlRequest setHTTPMethod:method];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[request setValue:[NSString stringWithFormat:@"%@, iOS %@ (compatible;)", self.platform, [UIDevice currentDevice].systemVersion] forHTTPHeaderField:@"User-Agent"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlRequest addValue:[LocalUser getInstance].sessionKey forHTTPHeaderField:@"sessionKey"];
        
        if(request)
        {
            NSDictionary* requestBody = [request getInfoDictionary];
            NSLog(@"request body = %@", requestBody);
            
            NSData* jsonBody = [[SBJsonWriter new] dataWithObject:requestBody];
            
            [urlRequest setValue:[NSString stringWithFormat:@"%d",[jsonBody length]] forHTTPHeaderField:@"Content-Length"];
            [urlRequest setHTTPBody:jsonBody];
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
/*
 - (void)connectionDidFinish:(HttpConnection *)httpConn
 {
 [self respondToRequestWithResult:YES httpConnection:httpConn];
 }
 
 - (void)respondToRequestWithResult:(BOOL)result httpConnection:(HttpConnection *)httpConn
 {
 HttpConnectionBlock callback = (HttpConnectionBlock)httpConn.context;
 if (callback)
 {
 NSDictionary *dataDictionary = nil;
 
 if (httpConn.receivedData)
 {
 NSString *dataJson = [[NSString alloc] initWithData:httpConn.receivedData encoding:NSUTF8StringEncoding];
 
 dataDictionary = [[[SBJsonParser alloc]init] objectWithString:dataJson];
 }
 callback(result, dataDictionary);
 }
 }
 - (NSDictionary*)execute:(NSDictionary*)loginParams
 {
 
 //create the request object with a url
 NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serverUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.TIMEOUT_CONNECTION];
 
 NSString* jsonRequest = [loginParams JSONRepresentation];
 //NSLog(@"jsonRequest = %@", jsonRequest);
 
 NSData* requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
 //NSLog(@"requestData = %@", requestData);
 
 [request setHTTPMethod:@"POST"];
 [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
 [request addValue:@"SessionKey" forHTTPHeaderField:@"SessionKey"];
 //set the string we created as the body
 [request setHTTPBody: requestData];
 
 //NSLog( @"%@", [request HTTPBody] );
 
 NSOperationQueue *queue = [[NSOperationQueue alloc] init];
 //id jsonResponse = nil;
 
 [NSURLConnection
 sendAsynchronousRequest:request
 queue:queue
 completionHandler:^(NSURLResponse *response,
 NSData *data,
 NSError *error)
 {
 if ([data length] >0 && error == nil)
 {
 //process the JSON response
 //use the main queue so that we can interact with the screen
 dispatch_async(dispatch_get_main_queue(), ^
 {
 NSString *myData = [[NSString alloc] initWithData:data
 encoding:NSUTF8StringEncoding];
 NSLog(@"JSON data = %@", myData);
 
 NSError *nsError = nil;
 
 id jsonObject = [NSJSONSerialization
 JSONObjectWithData:data
 options:NSJSONReadingAllowFragments
 error:&nsError];
 
 NSLog(@"jsonObject = %@", jsonObject);
 
 if (jsonObject != nil && nsError == nil){
 NSLog(@"Successfully deserialized...");
 }
 
 });
 }
 else if ([data length] == 0 && error == nil)
 {
 NSLog(@"Empty Response, not sure why?");
 }
 else if (error != nil)
 {
 NSLog(@"Not again, what is the error = %@", error);
 }
 }];
 
 NSURLResponse* response;
 NSError* error;
 NSMutableData* responseData = (NSMutableData*)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 
 
 NSLog( @"response=%@", response );
 NSLog( @"responseData=%@", responseData );
 
 SBJsonWriter* writer = [SBJsonWriter new];
 NSString* jsonResponse = [writer stringWithObject:response];
 
 NSLog( @"jsonResponse = %@", jsonResponse );
 
 NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
 
 if (! error)
 {
 NSLog(@"%@",jsonDict);
 }
 else
 {
 NSLog(@"%@",error.localizedDescription);
 }
 
 //SBJsonParser* jsonParser = [SBJsonParser new];
 //NSDictionary* jsonResponse = [jsonParser objectWithData:responseData];
 
 
 NSLog( @"jsonResponse = %@", jsonResponse );
 
 if( jsonResponse )
 NSLog( @"Server Access Success...!!" );
 
 SBJsonParser* jsonParser = [SBJsonParser new];
 NSDictionary* jsonResponse_ = [jsonParser objectWithString:jsonResponse error:nil];
 
 
 NSLog( @"jsonResponse = %@", jsonResponse );
 
 NSString* aaa = [jsonResponse objectForKey:@"Sessionkey"];
 
 if( aaa )
 NSLog( @"aaa = %@", aaa );
 */

//return nil;


/*
 NSURLResponse* response;
 NSData* responseData;
 NSError* error;
 NSDictionary* jsonResponse;
 
 responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 
 //print to console the result
 NSString *strData = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
 NSLog(@"strData = %@",strData);
 
 //SBJsonParser *jsonParser = [SBJsonParser new];
 
 jsonResponse = [strData JSONValue];
 
 // Parse the JSON into an Object
 //NSLog(@"returen value = %@",[jsonParser objectWithString:strData]);
 NSLog(@"jsonResponse = %@", jsonResponse );
 
 return jsonResponse;
 
 }
 */

@end
