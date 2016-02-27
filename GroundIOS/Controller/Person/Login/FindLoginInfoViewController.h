//
//  FindLoginInfoViewController.h
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FindLoginInfoViewController : GAITrackedViewController

//label
@property (strong, nonatomic) IBOutlet UILabel *message;

//text
@property (strong, nonatomic) IBOutlet UITextField *email;

//button
@property (strong, nonatomic) IBOutlet UIButton *findPswdButton;

//button action
- (IBAction)findPswdButtonPressed:(UIButton *)sender;

@end
