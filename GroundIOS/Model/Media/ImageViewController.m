//
//  ImageViewController.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ImageViewController.h"
#import "FullImageViewController.h"

#import "LoadingView.h"
#import "GroundClient.h"
#import "ImageUtils.h"

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"image path = %@", self.imagePath);
    
    [self.thumbImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [self loadingImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadingImage
{
    self.loadingView = [LoadingView startLoading:@"이미지를 불러오는 중입니다." parentView:self.view];
    
    [[GroundClient getInstance] downloadProfileImage:self.imagePath thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
        
        if(result){
            
            self.originalImg = [data objectForKey:@"image"];
//            NSLog(@"image size = %f,%f", tempImg.size.width, tempImg.size.height);
            
            self.thumbImage.image = [ImageUtils scaleImage:self.originalImg ToSize:CGSizeMake(self.thumbImage.frame.size.width, self.thumbImage.frame.size.height)];
//            NSLog(@"scaled image size = %f,%f", self.fullImage.image.size.width, self.fullImage.image.size.height);
            
            [self.loadingView stopLoading];
        }
    }];
}

- (IBAction)viewFullImage:(UITapGestureRecognizer *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jet_Storyboard" bundle:nil];
    FullImageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"FullImageViewController"];
    
    viewController.imagePath = self.imagePath;
    
    [self presentViewController:viewController animated:YES completion:NULL];
}

@end
