//
//  ImageViewController.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingView;

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;

@property (nonatomic,strong) UIImage *originalImg;
@property (nonatomic,strong) LoadingView *loadingView;
@property (nonatomic,strong) NSString* imagePath;

- (IBAction)viewFullImage:(UITapGestureRecognizer *)sender;
@end
