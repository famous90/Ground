//
//  LoadingView.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 8. 22..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

+ (LoadingView *)startLoading:(NSString *)loadingText parentView:(UIView *)parentView
{
    LoadingView *loadingView = [[[UINib nibWithNibName:@"LoadingView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    [loadingView setLoadingText:loadingText];
    [parentView addSubview:loadingView];
    loadingView.frame = parentView.frame;
    loadingView.displayView.center = loadingView.center;
    [loadingView.displayView.layer setCornerRadius:10];
    [loadingView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.3f animations:^(){
        
        [loadingView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
        
    }];
    
    return loadingView;
}

- (void)stopLoading
{
    [UIView animateWithDuration:0.3f animations:^(){
        
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)setLoadingText:(NSString*)loadingText
{
    self.loadingTextLabel.text = loadingText;
}

@end
