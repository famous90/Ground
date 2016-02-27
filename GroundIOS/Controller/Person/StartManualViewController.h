//
//  StartManualViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface StartManualViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UIImageView *manualImageView;
@property (weak, nonatomic) IBOutlet UIButton *goBeforeButton;
@property (weak, nonatomic) IBOutlet UIButton *goNextButton;
@property (weak, nonatomic) IBOutlet UIButton *goNextStepButton;

- (IBAction)manualImageViewPanGestureRecognized:(UIPanGestureRecognizer *)sender;
- (IBAction)goBeforeButtonTapped:(id)sender;
- (IBAction)goNextButtonTapped:(id)sender;
- (IBAction)goNextStepButtonTapped:(id)sender;

@end
