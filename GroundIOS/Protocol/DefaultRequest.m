//
//  DefaultRequest.m
//  HttpConnPrac
//
//  Created by Jet on 13. 6. 25..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "DefaultRequest.h"

@implementation DefaultRequest

static DefaultRequest* instance;
static NSDictionary* protocolList;

NSString* protocolName;

+ (DefaultRequest*)getInstance
{
    return instance;
}

+ (void)singleton
{
    instance = [[DefaultRequest alloc] init];
}

- (DefaultRequest*)init
{
    if( !protocolList )
    {
        [self getProtocolList];
    }
    
    return self;
}

// 객체 생성과 동시에 protocols.plist의 프로토콜목록을 불러옴.
- (void)getProtocolList
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *protocolPlist = [bundle URLForResource:@"protocols" withExtension:@"plist"];
    
    protocolList = [NSDictionary dictionaryWithContentsOfURL:protocolPlist];
}

// request에서 넘어오는 string값에 따라 protocol명 받아오기.
- (NSString*)getProtocolName:(NSString*)requestType
{
    for( id key in protocolList )
    {
        if( [requestType isEqualToString:key] )
        {
            protocolName = [protocolList objectForKey:key];
            break;
        }
    }
    
    //NSLog( @"protocol name = %@", protocolName );
    
    return protocolName;
}

@end
