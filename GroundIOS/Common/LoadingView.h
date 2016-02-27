//
//  LoadingView.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 22..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadingView : UIView

@property (weak,nonatomic) IBOutlet UILabel *loadingTextLabel;
@property (weak, nonatomic) IBOutlet UIView *displayView;

+ (LoadingView *)startLoading:(NSString *)loadingText parentView:(UIView *)parentView;
- (void)stopLoading;

@end
