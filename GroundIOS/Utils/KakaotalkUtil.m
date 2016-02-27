//
//  KakaotalkUtil.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "KakaotalkUtil.h"
#import "SBJson.h"

static NSString *StringByAddingPercentEscapesForURLArgument(NSString *string)
{
	NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				  (CFStringRef)string,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8));
    
    return escapedString;
}

static NSString *HTTPArgumentsStringForParameters(NSDictionary *parameters)
{
    NSMutableArray *arguments = [NSMutableArray array];
    
	for (NSString *key in parameters)
    {
		NSString *parameter = [NSString stringWithFormat:@"%@=%@", key, StringByAddingPercentEscapesForURLArgument([parameters objectForKey:key])];
		[arguments addObject:parameter];
	}
        
	return [arguments componentsJoinedByString:@"&"];
}

static NSString *const KakaoLinkApiVerstion = @"2.0";
static NSString *const KakaoLinkURLBaseString = @"kakaolink://sendurl";
/*
static NSString *const StoryLinkApiVersion = @"1.0";
static NSString *const StoryLinkURLBaseString = @"storylink://posting";
*/

@implementation KakaotalkUtil

#pragma mark -

+ (NSString *)URLStringForParameters:(NSDictionary *)parameters baseString:(NSString *)baseString
{
    NSString *argumentsString = HTTPArgumentsStringForParameters(parameters);
	NSString *URLString = [NSString stringWithFormat:@"%@?%@", baseString, argumentsString];
    
	return URLString;
}

// for KakaoLink

+ (NSString *)kakaoLinkURLStringForParameters:(NSDictionary *)parameters
{
    return [self URLStringForParameters:parameters baseString:KakaoLinkURLBaseString];
}

+ (BOOL)openKakaoLinkWithParams:(NSDictionary *)params
{
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:params];
    [_params setObject:KakaoLinkApiVerstion forKey:@"apiver"];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self kakaoLinkURLStringForParameters:_params]] sourceApplication:[[NSBundle mainBundle] bundleIdentifier] annotation:[[NSBundle mainBundle] pathForResource:@"towns" ofType:@"plist"]];
    
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self kakaoLinkURLStringForParameters:_params]]];
}

/*
// for StoryLink
+ (NSString *)storyLinkURLStringForParameters:(NSDictionary *)parameters {
	return [self URLStringForParameters:parameters baseString:StoryLinkURLBaseString];
}

+ (BOOL)openStoryLinkWithParams:(NSDictionary *)params {
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:params];
    [_params setObject:StoryLinkApiVersion forKey:@"apiver"];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self storyLinkURLStringForParameters:_params]]];
}
 */

#pragma mark -

+ (BOOL)canOpenKakaoLink {
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:KakaoLinkURLBaseString]];
}

+ (BOOL)openKakaoLinkWithURL:(NSString *)referenceURLString
				  appVersion:(NSString *)appVersion
				 appBundleID:(NSString *)appBundleID
                     appName:(NSString *)appName
					 message:(NSString *)message {
	if (!referenceURLString || !message || !appVersion || !appBundleID ||!appName)
		return NO;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                referenceURLString, @"url",
                                message, @"msg",
                                appVersion, @"appver",
                                appBundleID, @"appid",
                                appName, @"appname",
                                @"link", @"type",
                                nil];
    
	return [self openKakaoLinkWithParams:parameters];
}


+ (BOOL)openKakaoAppLinkWithMessage:(NSString *)message
								URL:(NSString *)referenceURLString
						appBundleID:(NSString *)appBundleID
						 appVersion:(NSString *)appVersion
							appName:(NSString *)appName
					  metaInfoArray:(NSArray *)metaInfoArray {
    
    BOOL avalibleAppLink = !message || !appVersion || !appBundleID || !appName || !metaInfoArray || [metaInfoArray count] > 0;
	if (!avalibleAppLink)
		return NO;
    
    NSString *appDataString = [[SBJsonWriter new] stringWithObject:[NSDictionary dictionaryWithObject:metaInfoArray forKey:@"metainfo"]];
    if ( appDataString == nil )
        return NO;
    
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       referenceURLString, @"url",
                                       message, @"msg",
                                       appVersion, @"appver",
                                       appBundleID, @"appid",
                                       appName, @"appname",
                                       @"app", @"type",
                                       appDataString, @"metainfo",
                                       nil];
    
	return [self openKakaoLinkWithParams:parameters];
}
@end