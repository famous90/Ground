//
//  PopUpView.h
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>

@class Ground;

@interface PopUpView : UIView

@property (strong, nonatomic) Ground *ground;
@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UILabel *popUpMessage;
@property (weak, nonatomic) IBOutlet UILabel *groundNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *groundName;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

+ (PopUpView *)popUp:(NSString *)message parentView:(UIView *)parentView;

- (IBAction)doRegisterGround:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTab:(id)sender;

@end
