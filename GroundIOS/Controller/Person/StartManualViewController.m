//
//  StartManualViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "StartManualViewController.h"
#import "LoginSelectViewController.h"

#import "ViewUtil.h"

@implementation StartManualViewController{
    NSArray *manualPageImageArray;
    NSInteger manualPageIndex;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.goBeforeButton setAlpha:0.6f];
    [self.goNextButton setAlpha:0.6f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    manualPageIndex = 0;
    manualPageImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"start_manual1"], [UIImage imageNamed:@"start_manual2"], [UIImage imageNamed:@"start_manual3"], [UIImage imageNamed:@"start_manual4"], nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setScreenName:@"StartManualView"];
}

- (void)goNextPage
{
    if (manualPageIndex < 3) {
        manualPageIndex++;
        self.manualImageView.image = [manualPageImageArray objectAtIndex:manualPageIndex];
        if (manualPageIndex == 3) {
            self.goNextButton.hidden = YES;
            self.goNextStepButton.hidden = NO;
        }
        if (manualPageIndex != 0) {
            self.goBeforeButton.hidden = NO;
        }
    }
}

- (void)goBeforePage
{
    if (manualPageIndex > 0) {
        manualPageIndex--;
        self.manualImageView.image = [manualPageImageArray objectAtIndex:manualPageIndex];
        if (manualPageIndex != 3) {
            self.goNextButton.hidden = NO;
            self.goNextStepButton.hidden = YES;
        }
        if (manualPageIndex == 0) {
            self.goBeforeButton.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)manualImageViewPanGestureRecognized:(UIPanGestureRecognizer *)sender
{
    UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)sender;
    
    UIView *view = [panRecognizer view];
    if (panRecognizer.state == UIGestureRecognizerStateBegan ) {
        
        CGPoint delta = [panRecognizer translationInView:view.superview];
        if (delta.x > 0) {
            [self goBeforePage];
        }else if (delta.x < 0){
            [self goNextPage];
        }

        [panRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (IBAction)goBeforeButtonTapped:(id)sender
{
    [self goBeforePage];
}

- (IBAction)goNextButtonTapped:(id)sender
{
    [self goNextPage];
}

- (IBAction)goNextStepButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    LoginSelectViewController *childViewController = (LoginSelectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginSelectView"];
    [self presentViewController:childViewController animated:YES completion:Nil];
}


@end
