//
//  main.m
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "LocalUser.h"
#import "GroundClient.h"
#import "DefaultRequest.h"
#import "FacebookUtil.h"
#import "StringUtils.h"
#import "ImageUtils.h"

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        [DefaultRequest singleton];
        [GroundClient singleton];
        [FacebookUtil singleton];
        [LocalUser singleton];
        [StringUtils singleton];
        [ImageUtils singleton];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
