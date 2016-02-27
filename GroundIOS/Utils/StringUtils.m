//
//  StringUtils.m
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 3..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

static StringUtils* instance;

+ (StringUtils *)getInstance
{
    return instance;
}

+ (void)singleton
{
    instance = [[StringUtils alloc] init];
}

- (BOOL)IsStringNull:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil ){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)stringIsEmpty:(NSString*)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([str isEqual:[NSNull null]] || str == nil || [str length] == 0){
        return YES;
    }else{
        return NO;
    }
}

// is there a dot in the sentence
- (BOOL)stringHasDot:(NSString *)str
{
    NSRange rangeOfDot = [str rangeOfString:@"."];
    
    if (rangeOfDot.location == NSNotFound) {
        
        return NO;
    }else{
        
        return YES;
    }
}

// is right email format
- (BOOL)stringIsEmailFormat:(NSString *)str
{
    // to find the first '@'
    NSRange rangeOfAtSign = [str rangeOfString:@"@"];
    NSString *subString = [str substringFromIndex:(unsigned)rangeOfAtSign.location];
    // to find the second '@' sign
    NSRange secondRangeOfAtSign = [subString rangeOfString:@"@"];
    
    if( rangeOfAtSign.location == NSNotFound && [self stringHasDot:subString]){
        
        return NO;
    }else if( secondRangeOfAtSign.location == NSNotFound){
        
        return YES;
    }else{
        
        return NO;
    }
}

- (NSString *)JSONString:(NSString *)aString
{
    NSMutableString *jsonString = [NSMutableString stringWithString:aString];
    [jsonString replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    [jsonString replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    [jsonString replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    [jsonString replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    [jsonString replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    [jsonString replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    [jsonString replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [jsonString length])];
    
    return [NSString stringWithString:jsonString];
    
}

@end
