//
//  StringUtils.h
//  HttpConnPrac
//
//  Created by Jet on 13. 7. 3..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (StringUtils *)getInstance;
+ (void)singleton;

- (BOOL)IsStringNull:(NSString *)str;
- (BOOL)stringIsEmpty:(NSString*)str;

- (BOOL)stringHasDot:(NSString*)str;
- (BOOL)stringIsEmailFormat:(NSString*)str;

- (NSString *)JSONString:(NSString *)aString;

@end
