//
//  Util.m
//  httpPrac
//
//  Created by Jet on 13. 5. 30..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString*)message
{
    if( message == nil )
        return;
    
    [self showAlertView:delegate message:message title:@"확인"];
}

+ (void)showErrorAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message
{
    if( message == nil )
        return;
    
    [self showAlertView:delegate message:[NSString stringWithFormat:@"%@\n다시 시도해주세요\n불편을 드려 죄송합니다", message] title:@"확인"];
}

+ (void)showAlertViewWithTag:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title tag:(NSInteger)alertTag
{
    if ( message == nil || [message isKindOfClass:[NSNull class]] )
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:nil
										  otherButtonTitles:@"확인", nil];
    alert.tag = alertTag;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
	[alert show];
}

+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title
{
    if ( message == nil || [message isKindOfClass:[NSNull class]] )
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:message
												   delegate:delegate
										  cancelButtonTitle:title
										  otherButtonTitles:nil];
    
	[alert show];
}

+ (void)showConfirmAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title
{
    if ( message == nil || [message isKindOfClass:[NSNull class]] )
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:nil
										  otherButtonTitles:@"확인", @"취소", nil];
    
    [alert dismissWithClickedButtonIndex:1 animated:YES];
    
	[alert show];
}

@end
