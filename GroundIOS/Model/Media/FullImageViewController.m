//
//  FullImageViewController.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FullImageViewController.h"

#import "LoadingView.h"
#import "GroundClient.h"
#import "ImageUtils.h"

@implementation FullImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self getFullImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
- (void)getFullImage
 {
     self.loadingView = [LoadingView startLoading:@"이미지를 불러오는 중입니다." parentView:self.view];
     
     [[GroundClient getInstance] downloadProfileImage:self.imagePath thumbnail:FALSE callback:^(BOOL result, NSDictionary *data){
         
         if(result){
             
             self.fullImage.image = [data objectForKey:@"image"];
//             NSLog(@"image size = %f,%f", self.fullImage.image.size.width, self.fullImage.image.size.height);
            
             
             [self.loadingView stopLoading];
         }
     }];
 }

@end
