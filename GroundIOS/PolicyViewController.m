//
//  PolicyViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 29..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PolicyViewController.h"

@implementation PolicyViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.pageType == VIEW_WITH_SERVICE_POLICY) {
        self.title = @"서비스이용약관";
    }else if (self.pageType == VIEW_WITH_PRIVACY_POLICY){
        self.title = @"개인정보보호정책";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"CancelToShowPolicy"]) {
//        if (self.pageOriginType == VIEW_FROM_REGISTER) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}

@end
