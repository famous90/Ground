//
//  FullImageViewController.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingView;

@interface FullImageViewController : UIViewController

@property (nonatomic,strong) NSString* imagePath;
@property (nonatomic,strong) LoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *fullImage;


@end
