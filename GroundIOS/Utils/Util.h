//
//  Util.h
//  httpPrac
//
//  Created by Jet on 13. 5. 30..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString*)message;
+ (void)showErrorAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString*)message;
+ (void)showAlertViewWithTag:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title tag:(NSInteger)alertTag;
+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title;
+ (void)showConfirmAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title;

@end
