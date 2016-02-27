//
//  ServerResponseError.m
//  GroundIOS
//
//  Created by Z's iMac on 2013. 11. 4..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define EMAIL_NOT_EXIST 102
#define DUPLICATED_EMAIL 200
#define WRONG_PASSWORD 201
#define WRONG_EMAIL 202

#import "ServerResponseError.h"
#import "Util.h"

@implementation ServerResponseError

+ (void)emailLoginError:(NSInteger)code delegate:(id)delegate
{
    switch (code){
        case WRONG_PASSWORD:
            [Util showAlertView:delegate message:@"비밀번호가 일치하지 않습니다.\r\n확인 후, 다시 입력해주세요."];
            break;
        case EMAIL_NOT_EXIST:
            [Util showAlertView:delegate message:@"존재하지 않는 이메일입니다.\r\n회원가입을 해주세요."];
            break;
        default:
            ;
    }
}

+ (void)emailValidateError:(NSInteger)code delegate:(id)delegate
{
    switch (code){
        case DUPLICATED_EMAIL:
            [Util showAlertView:delegate message:@"이미 등록되어 있는 이메일입니다.\r\n지금 바로 로그인하세요."];
            break;
        default:
            ;
    }
}

+ (void)forgotPasswordError:(NSInteger)code delegate:(id)delegate
{
    switch (code){
        case WRONG_EMAIL:
            [Util showAlertView:delegate message:@"이메일을 잘못 입력하셨습니다.\r\n확인 후 재입력해주세요."];
            break;
        default:
            ;
    }
}

@end
