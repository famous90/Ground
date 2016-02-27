//
//  FirstSectionInMyMenuViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface FirstSectionInMyMenuViewController : UIViewController

// view
@property (weak, nonatomic) IBOutlet UIImageView *myProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;

// data
@property (nonatomic, strong) User *myInfo;

// method
- (IBAction)myNewsButtonTapped:(id)sender;
@end
