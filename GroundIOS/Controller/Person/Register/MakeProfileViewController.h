//
//  MakeProfileViewController.h
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

#import "AbstractActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "PhotoSelectViewController.h"
#import "GAITrackedViewController.h"

@class User;
@class UserInfo;
@class AbstractActionSheetPicker;

@interface MakeProfileViewController : GAITrackedViewController<UITextFieldDelegate, UIActionSheetDelegate, PhotoSelectViewDelegate>

// view
@property (weak, nonatomic) IBOutlet UIImageView *myProfileImageView;
@property (weak, nonatomic) IBOutlet UITextField *myNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameTextFieldTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *myBirthYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *myPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberOpenButton;
@property (weak, nonatomic) IBOutlet UITextField *myLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *myOccupationTextField;
@property (weak, nonatomic) IBOutlet UITextField *myPositionTextField;
@property (weak, nonatomic) IBOutlet UITextField *myHeightTextField;
@property (weak, nonatomic) IBOutlet UITextField *myWeightTextField;
@property (weak, nonatomic) IBOutlet UIButton *myMainFootButton;

// action sheet
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

// data
@property (nonatomic, strong) UserInfo *profile;
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger pageOriginType;
@property (nonatomic, strong) NSString* registerEmail;
@property (nonatomic, strong) NSString* registerPassword;

@property (nonatomic, strong) NSDictionary *koreaAddr;
@property (nonatomic, strong) NSArray *states;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, assign) NSInteger selectedStateIndex;
@property (nonatomic, assign) NSInteger selectedCityIndex;

@property (nonatomic, strong) NSArray *birthdays;
@property (nonatomic, assign) NSInteger selectedBirthIndex;

@property (nonatomic, strong) NSArray *occupations;
@property (nonatomic, assign) NSInteger selectedOccuIndex;

@property (nonatomic, strong) NSArray *positions;
@property (nonatomic, assign) NSInteger selectedPositionIndex;

@property (nonatomic, strong) NSMutableArray *heights;
@property (nonatomic, assign) NSInteger selectedHeightIndex;

@property (nonatomic, strong) NSMutableArray *weights;
@property (nonatomic, assign) NSInteger selectedWeightIndex;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

// method
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)userImageViewTapped:(id)sender;
- (IBAction)nameTextFieldTapped:(id)sender;
- (IBAction)phoneNumberOpenButtonTapped:(id)sender;
- (IBAction)mainFootButtonTapped:(id)sender;

// action sheet
- (IBAction)textFieldChanged:(id)sender;

- (IBAction)selectBirthday:(id)sender;
- (IBAction)birthdayButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)selectOccupation:(id)sender;
- (IBAction)OccupationButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)selectPosition:(id)sender;
- (IBAction)positionButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)selectHeight:(id)sender;
- (IBAction)heightButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)selectWeight:(id)sender;
- (IBAction)weightButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)selectLocation:(id)sender;
- (IBAction)locationButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)signInButtonTapped:(id)sender;
@end
