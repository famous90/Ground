//
//  PopUpViewController.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 10. 21..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;
@class Ground;

@interface PopUpViewController : UIViewController

@property (weak) MapViewController *mapViewController;
@property (weak, nonatomic) IBOutlet UILabel *popUpMessage;
@property (weak, nonatomic) IBOutlet UITextField *groundName;
@property (strong, nonatomic) Ground *ground;
@property (strong, nonatomic) NSString* popUpTextStr;

- (IBAction)doRegisterGround:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)backgroundTab:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (void)setPopUpText:(NSString*)str;

@end
