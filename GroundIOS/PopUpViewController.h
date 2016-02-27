//
//  PopUpViewController.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 10. 16..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;
@class Ground;

@interface PopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *popUpMessage;
@property (weak, nonatomic) IBOutlet UILabel *groundNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *groundName;

@property (strong, nonatomic) Ground *ground;

@end
