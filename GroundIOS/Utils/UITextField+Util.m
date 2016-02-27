//
//  UITextField+Util.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "UITextField+Util.h"

@implementation UITextField(Util)

+ (void)setVerticalPaddingWithTextField:(UITextField *)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
    
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.rightView = paddingView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

@end
