//
//  EmailLoginViewController.h
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailLoginViewController : UIViewController

// view
@property (strong, nonatomic) IBOutlet UISegmentedControl *loginOrRegisterSelectSegment;
@property (weak, nonatomic) IBOutlet UIView *EmailLoginView;
@property (weak, nonatomic) IBOutlet UIView *RegisterView;

// data

// method
- (IBAction)segmentChanged:(UISegmentedControl *)sender;

- (IBAction)cancel:(UIStoryboardSegue *)segue;
@end
