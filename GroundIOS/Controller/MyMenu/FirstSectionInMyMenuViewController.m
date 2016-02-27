//
//  FirstSectionInMyMenuViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FirstSectionInMyMenuViewController.h"
#import "MyNewsParentViewController.h"
#import "User.h"
#import "GroundClient.h"

#import "StringUtils.h"
#import "ViewUtil.h"

@interface FirstSectionInMyMenuViewController ()
- (void)configureView;
@end

@implementation FirstSectionInMyMenuViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.myInfo = [[User alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureView
{
    if([[StringUtils getInstance] IsStringNull:self.myInfo.name])
        self.myInfo.name = @"이름없음";
    self.myNameLabel.text = self.myInfo.name;
    
    if(![[StringUtils getInstance] IsStringNull:self.myInfo.imageUrl]){
        
//        if ([ViewUtil isImagePathUrl:self.myInfo.imageUrl]) {
//            self.myProfileImageView.image = [ViewUtil imageFromImagePathUrl:self.myInfo.imageUrl];
//        }else{
            [[GroundClient getInstance] downloadProfileImage:self.myInfo.imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
                if(result){
                    self.myProfileImageView.image = [data objectForKey:@"image"];
                    NSLog(@"IMAGE IN DATA : %@", [data objectForKey:@"image"]);
                }
                else
                    NSLog(@"load my profile image error in my menu");
            }];
//        }
    }else{
        self.myProfileImageView.image = [UIImage imageNamed:@"profile_noImage"];
    }
}

#pragma mark -
#pragma mark - IBAction Methods
- (IBAction)myNewsButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    MyNewsParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
    childViewController.user = self.myInfo;
    [self presentViewController:childViewController animated:YES completion:nil];
}
@end
