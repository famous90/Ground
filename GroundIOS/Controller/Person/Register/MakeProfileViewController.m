//
//  MakeProfileViewController.m
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define TAKING_A_PICTURE    0
#define PHOTO_ALBUM         1

#define MIN_BIRTHYEAR       1900
#define DEFAULT_BIRTHYEAR   1980
#define MIN_HEIGHT          120
#define MAX_HEIGHT          220
#define DEFAULT_HEIGHT      170
#define MIN_WEIGHT          30
#define MAX_WEIGHT          150
#define DEFAULT_WEIGHT      60

#define LEFT_FOOT   0   
#define RIGHT_FOOT  1

#import "MakeProfileViewController.h"
#import "EmailLoginViewController.h"
#import "MyNewsParentViewController.h"
#import "PhotoSelectViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "LocalUser.h"
#import "UserInfo.h"

#import "GroundClient.h"s[
#import "AbstractActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetStringDependantPicker.h"

#import "StringUtils.h"
#import "NSDate+Utils.h"
#import "Util.h"
#import "ViewUtil.h"
#import "UITextField+Util.h"

@interface MakeProfileViewController ()
- (void)locationWasSelected:(NSNumber *)selectedStateIndex selected:(NSNumber *)selectedCityIndex element:(id)element;
- (void)birthWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)occupationWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)positionWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)heightWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)weightWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)configureView;
@end

@implementation MakeProfileViewController{
    BOOL isPhoneNumberOpen;
    BOOL mainFootButtonIsOnRight;
    
    BOOL isProfileImageChanged;
    
    LoadingView *loadingView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.profile = [[UserInfo alloc]init];
}

- (void)setProfile:(UserInfo *)newProfile
{
    if(_profile != newProfile){
        _profile = newProfile;
    }
}

- (void)viewDidLayoutSubviews
{
    if (self.pageOriginType == VIEW_FROM_CHANGE_PROFILE) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.signInButton setTitle:@"선수정보 변경" forState:UIControlStateNormal];
    }
    
    [UITextField setVerticalPaddingWithTextField:self.myNameTextField];
    [UITextField setVerticalPaddingWithTextField:self.myBirthYearTextField];
    [UITextField setVerticalPaddingWithTextField:self.myPhoneNumberTextField];
    [UITextField setVerticalPaddingWithTextField:self.myPositionTextField];
    [UITextField setVerticalPaddingWithTextField:self.myHeightTextField];
    [UITextField setVerticalPaddingWithTextField:self.myWeightTextField];
    [UITextField setVerticalPaddingWithTextField:self.myLocationTextField];
    [UITextField setVerticalPaddingWithTextField:self.myOccupationTextField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isProfileImageChanged = NO;
    
    [self setPropertyListFactorInProfile];
    
    if (self.pageOriginType == VIEW_FROM_CHANGE_PROFILE) {
        [self getMyProfile];
        
    }else if(self.pageOriginType == VIEW_FROM_REGISTER){
        isPhoneNumberOpen = NO;
        mainFootButtonIsOnRight = YES;
        self.profile.mainFoot = RIGHT_FOOT;
        self.profile.birthYear = DEFAULT_BIRTHYEAR;
        self.profile.height = DEFAULT_HEIGHT;
        self.profile.weight = DEFAULT_WEIGHT;
        
        self.selectedBirthIndex = DEFAULT_BIRTHYEAR - MIN_BIRTHYEAR;
        self.selectedHeightIndex = DEFAULT_HEIGHT - MIN_HEIGHT;
        self.selectedWeightIndex = DEFAULT_WEIGHT - MIN_WEIGHT;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
}

- (void)setPropertyListFactorInProfile
{
    self.koreaAddr = [self getDictionaryListFromPropertyList:@"koreaAddr"];
    NSArray *allStates = [self.koreaAddr allKeys];
    self.states = [allStates sortedArrayUsingSelector:@selector(compare:)];
    self.cities = self.koreaAddr[self.states[0]];
    
    self.birthdays = [self getNumberListWithRangeFrom:MIN_BIRTHYEAR to:[NSDate extractCalendarUnitsFromNSDate:[NSDate date] calendarUnit:NSYearCalendarUnit]];
    self.occupations = [self getListFromPropertyList:@"occupations"];
    self.positions = [self getListFromPropertyList:@"positions"];
    self.heights = [self getNumberListWithRangeFrom:130 to:220];
    self.weights = [self getNumberListWithRangeFrom:30 to:150];
}

- (void)getMyProfile
{
    LoadingView *profileLoadingView = [LoadingView startLoading:@"내 정보를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getUserInfo:self.user.userId callback:^(BOOL result, NSDictionary *data){
        if (result) {
            UserInfo *theUserInfo = [[UserInfo alloc] initUserInfoWithData:[data objectForKey:@"userInfo"]];
            [self.profile addMyProfileWithProfile:theUserInfo];

            if (theUserInfo.profileImageUrl != (id)[NSNull null]) {
                
                [[GroundClient getInstance] downloadProfileImage:theUserInfo.profileImageUrl thumbnail:YES callback:^(BOOL result, NSDictionary *data){
                    if (result) {
                        UIImage *theImage = [data objectForKey:@"image"];
                        self.userImage = theImage;
                        self.myProfileImageView.image = theImage;
                        
                    }else{
                        NSLog(@"error to load my image to edit in make profile");
                        self.myProfileImageView.image = [UIImage imageNamed:@"profile_noImage"];
                    }
                }];
                
            }else{
                self.myProfileImageView.image = [UIImage imageNamed:@"profile_noImage"];
            }
            
            [self setProfileInfo];
            self.nameTextFieldTipLabel.hidden = YES;
        
        }else{
            NSLog(@"error to load my profile in make profile");
            [Util showErrorAlertView:nil message:@"내 정보를 불러오는 데 실패했습니다"];
        }
        
        [profileLoadingView stopLoading];
    }];
}

- (void)setProfileInfo
{
    // SET DEFAULT VALUE FOR NOT EXIST FACTOR
    if (self.profile.birthYear <= 0) {
        self.profile.birthYear = DEFAULT_BIRTHYEAR;
    }
    if (self.profile.height <= 0) {
        self.profile.height = DEFAULT_HEIGHT;
    }
    if (self.profile.weight <= 0) {
        self.profile.weight = DEFAULT_WEIGHT;
    }
    if (self.profile.occupation <= 0) {
        self.profile.occupation = 0;
    }
    if (self.profile.position <= 0) {
        self.profile.position = 0;
    }
    if (self.profile.mainFoot <= 0) {
        self.profile.mainFoot = RIGHT_FOOT;
    }
    
    self.selectedBirthIndex = self.profile.birthYear - MIN_BIRTHYEAR;
    self.selectedPositionIndex = self.profile.position;
    self.selectedHeightIndex = self.profile.height - MIN_HEIGHT;
    self.selectedWeightIndex = self.profile.weight - MIN_WEIGHT;
    self.selectedOccuIndex = self.profile.occupation;
    isPhoneNumberOpen = YES;
    
    [self configureMyProfileToEdit];
}

- (void)configureMyProfileToEdit
{
    self.myNameTextField.text = self.profile.name;
    self.myPhoneNumberTextField.text = self.profile.phoneNumber;
    
    self.myBirthYearTextField.text = [NSString stringWithFormat:@"%d 년생", self.profile.birthYear];
    self.myPositionTextField.text = [self.positions objectAtIndex:self.selectedPositionIndex];
    self.myHeightTextField.text = [NSString stringWithFormat:@"%d cm", self.profile.height];
    self.myWeightTextField.text = [NSString stringWithFormat:@"%d kg", self.profile.weight];
    if (self.profile.mainFoot == RIGHT_FOOT) {
        [self setMainFootToRight];
    }else if (self.profile.mainFoot == LEFT_FOOT){
        [self setMainFootToLeft];
    }
    if (self.profile.location1 != (id)[NSNull null]) {
        self.myLocationTextField.text = [NSString stringWithFormat:@"%@ %@", self.profile.location1, self.profile.location2];
    }
    self.myOccupationTextField.text = [self.occupations objectAtIndex:self.selectedOccuIndex];
}

//- (NSManagedObjectContext *)managedObjectContext
//{
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if([delegate performSelector:@selector(managedObjectContext)]){
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

- (BOOL)receivedProfileResponse:(BOOL)result data:(NSDictionary *)data
{
    NSString *session = [data objectForKey:@"sessionKey"];
    
    if(![[StringUtils getInstance] stringIsEmpty:session]){
        return YES;
    }else{
        NSLog(@"send my profile to the server error");
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelMakeProfile"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)backgroundTapped:(id)sender
{
    [self.myNameTextField resignFirstResponder];
    [self.myPhoneNumberTextField resignFirstResponder];
}

- (IBAction)userImageViewTapped:(id)sender
{
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"프로필사진등록" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    photoActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [photoActionSheet addButtonWithTitle:@"사진찍기"];
    [photoActionSheet addButtonWithTitle:@"사진첩"];
    [photoActionSheet addButtonWithTitle:@"취소"];
    [photoActionSheet dismissWithClickedButtonIndex:2 animated:YES];
    [photoActionSheet showInView:self.view];
}

- (IBAction)nameTextFieldTapped:(id)sender
{
    self.nameTextFieldTipLabel.hidden = YES;
}

- (IBAction)phoneNumberOpenButtonTapped:(id)sender
{
    if (isPhoneNumberOpen) {
        [self.phoneNumberOpenButton setBackgroundImage:[UIImage imageNamed:@"radioButton_off"] forState:UIControlStateNormal];
        isPhoneNumberOpen = NO;
    }else{
        [self.phoneNumberOpenButton setBackgroundImage:[UIImage imageNamed:@"radioButton_on"] forState:UIControlStateNormal];
        isPhoneNumberOpen = YES;
    }
}

- (IBAction)textFieldChanged:(id)sender
{
    self.profile.name = self.myNameTextField.text;
    self.profile.phoneNumber = self.myPhoneNumberTextField.text;
}

- (IBAction)selectBirthday:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"생일선택" rows:self.birthdays initialSelection:self.selectedBirthIndex target:self successAction:@selector(birthWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)birthdayButtonTapped:(UIBarButtonItem *)sender
{
    [self selectBirthday:sender];
}

- (IBAction)selectOccupation:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"직업선택" rows:self.occupations initialSelection:self.selectedOccuIndex target:self successAction:@selector(occupationWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)OccupationButtonTapped:(UIBarButtonItem *)sender
{
    [self selectOccupation:sender];
}

- (IBAction)selectPosition:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"포지션선택" rows:self.positions initialSelection:self.selectedPositionIndex target:self successAction:@selector(positionWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)positionButtonTapped:(UIBarButtonItem *)sender
{
    [self selectPosition:sender];
}

- (IBAction)selectHeight:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"키" rows:self.heights initialSelection:self.selectedHeightIndex target:self successAction:@selector(heightWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)heightButtonTapped:(UIBarButtonItem *)sender
{
    [self selectHeight:sender];
}

- (IBAction)selectWeight:(UIControl *)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"몸무게" rows:self.weights initialSelection:self.selectedWeightIndex target:self successAction:@selector(weightWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)weightButtonTapped:(UIBarButtonItem *)sender
{
    [self selectWeight:sender];
}

- (IBAction)selectLocation:(id)sender {
    [ActionSheetStringDependantPicker showPickerWithTitle:@"지역선택" parentDic:self.koreaAddr parentRows:self.states childRows:self.cities initialParentSelection:self.selectedStateIndex initialChildSelection:self.selectedCityIndex target:self successAction:@selector(locationWasSelected:selected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)locationButtonTapped:(UIBarButtonItem *)sender
{
    [self selectLocation:sender];
}

- (IBAction)mainFootButtonTapped:(id)sender
{
    if (mainFootButtonIsOnRight == YES) {
        [self setMainFootToLeft];
        
    }else if(mainFootButtonIsOnRight == NO){
        [self setMainFootToRight];
    }
}

- (IBAction)signInButtonTapped:(id)sender
{
    if (self.pageOriginType == VIEW_FROM_REGISTER) {
        [self doEmailRegister];
    }else if (self.pageOriginType == VIEW_FROM_CHANGE_PROFILE){
        [self editProfile];
    }
}

#pragma mark - Implementation
- (void)doEmailRegister
{
    if( (self.profile.name == NULL) || (self.profile.phoneNumber == NULL) ){
        [Util showAlertView:nil message:@"이름과 전화번호는 필수입니다"];
        
    }else if(!self.userImage){
        [Util showAlertView:nil message:@"사진을 넣어주세요"];
        
    }else{
        loadingView = [LoadingView startLoading:@"프로필 정보를 등록하고 있습니다" parentView:self.view];
        
        [[GroundClient getInstance] emailRegister:self.registerEmail withPw:self.registerPassword callback:^(BOOL result, NSDictionary *data){
             if(result){
                 self.profile.userId = [[data objectForKey:@"userId"] integerValue];
                 NSString* session = [data objectForKey:@"sessionKey"];
                 
                 if(session != nil){
                     [[LocalUser getInstance] setSessionKey:session];
                     
                 // SESSION ERROR
                 }else{
                     [Util showErrorAlertView:nil message:@"가입에 실패했습니다"];
                     return;
                 }
                 
                 if(isProfileImageChanged){
                     [[GroundClient getInstance] uploadProfileImage:self.userImage thumbnail:TRUE multipartCallback:^(BOOL result, NSDictionary *imagePath){
                         if(result){
                             NSString *theImagePath = [imagePath objectForKey:@"path"];
                             self.profile.profileImageUrl = theImagePath;
                             self.user.imageUrl = theImagePath;
                             
                             
                         }else{
                             NSLog(@"error to upload user profile image in make profile");
                             [Util showErrorAlertView:nil message:@"사진을 올리지 못했습니다"];
                         }
                         
                         [self editProfile];
                     }];
                     
                 }else{
                     [self editProfile];
                 }
                 
             }else{
                 NSInteger code = [[data valueForKey:@"code"] integerValue];
                 NSLog(@"error to register with error code : %d in make profile", code);
                 [Util showErrorAlertView:nil message:@"가입에 실패했습니다"];
                 
                 [loadingView stopLoading];
             }
         }];
    }
}

- (void)editProfile
{
    [[GroundClient getInstance] editProfile:self.profile callback:^(BOOL result, NSDictionary *data){
        if(result){
            
            if (self.pageOriginType == VIEW_FROM_REGISTER) {
                [Util showAlertView:nil message:@"새로운 플레이어가 등록되었습니다.\n팀을 만들거나 다른 팀에 가입해보세요"];
                
                NSMutableDictionary *loginToken = [[NSMutableDictionary alloc] init];
                [loginToken setValue:[NSNumber numberWithInteger:self.profile.userId ] forKey:@"userId"];
                [loginToken setValue:self.profile.name forKey:@"name"];
                [loginToken setValue:self.profile.profileImageUrl forKey:@"imageUrl"];
                [[LocalUser getInstance] setLoginToken:loginToken];
                
                self.user = [[User alloc] initWithUserId:self.profile.userId name:self.profile.name imageUrl:self.profile.profileImageUrl];
                
            }else if (self.pageOriginType == VIEW_FROM_CHANGE_PROFILE){
                [Util showAlertView:nil message:@"개인 프로필이 변경되었습니다"];
            }
            
            UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
            MyNewsParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
            childViewController.user = self.user;
            
            [self presentViewController:childViewController animated:YES completion:nil];
            
        }else{
            NSLog(@"edit user profile error");
            [Util showErrorAlertView:nil message:@"프로필 등록에 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)locationWasSelected:(NSNumber *)selectedStateIndex selected:(NSNumber *)selectedCityIndex element:(id)element
{
    self.selectedStateIndex = [selectedStateIndex intValue];
    self.selectedCityIndex = [selectedCityIndex intValue];
    NSString *location1 = [self.states objectAtIndex:self.selectedStateIndex];
    NSString *location2 = [self.koreaAddr[self.states[self.selectedStateIndex]] objectAtIndex:self.selectedCityIndex];
    self.myLocationTextField.text = [NSString stringWithFormat:@"%@ %@", location1, location2];
    self.profile.location1 = location1;
    self.profile.location2 = location2;
}

- (void)birthWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedBirthIndex = [selectedIndex intValue];
    NSString *birthday = [self.birthdays objectAtIndex:self.selectedBirthIndex];
    self.myBirthYearTextField.text = birthday;
    self.profile.birthYear = [birthday intValue];
}

- (void)occupationWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedOccuIndex = [selectedIndex intValue];
    NSString *occupation = [self.occupations objectAtIndex:self.selectedOccuIndex];
    self.myOccupationTextField.text = occupation;
    self.profile.occupation = self.selectedOccuIndex;
}

- (void)positionWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedPositionIndex = [selectedIndex intValue];
    NSString *position = [self.positions objectAtIndex:self.selectedPositionIndex];
    self.myPositionTextField.text = position;
    self.profile.position = self.selectedPositionIndex;
}

- (void)heightWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedHeightIndex = [selectedIndex intValue];
    NSString *height = [self.heights objectAtIndex:self.selectedHeightIndex];
    self.myHeightTextField.text = height;
    self.profile.height = [height intValue];
}

- (void)weightWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    self.selectedWeightIndex = [selectedIndex intValue];
    NSString *weight = [self.weights objectAtIndex:self.selectedWeightIndex];
    self.myWeightTextField.text = weight;
    self.profile.weight = [weight intValue];
}

- (void)setMainFootToRight
{
    [self.myMainFootButton setBackgroundImage:[UIImage imageNamed:@"profile_switch_right"] forState:UIControlStateNormal];
    //        [self.myMainFootButton setTitle:@"               오른발" forState:UIControlStateNormal];
    mainFootButtonIsOnRight = YES;
    self.profile.mainFoot = RIGHT_FOOT;
}

- (void)setMainFootToLeft
{
    [self.myMainFootButton setBackgroundImage:[UIImage imageNamed:@"profile_switch_left"] forState:UIControlStateNormal];
    //        [self.myMainFootButton setTitle:@"왼발                " forState:UIControlStateNormal];
    mainFootButtonIsOnRight = NO;
    self.profile.mainFoot = LEFT_FOOT;
}

#pragma mark - UITextFieldDelegate

- (void)actionPickerCancelled:(id)sender
{
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if((textField == self.myNameTextField) || (textField == self.myPhoneNumberTextField)){
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma makr - ActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PhotoSelectViewController *photoViewController = [[PhotoSelectViewController alloc] init];
    switch (buttonIndex) {
        case TAKING_A_PICTURE:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [self addChildViewController:photoViewController];
                [photoViewController pickPhotoFromSource:UIImagePickerControllerSourceTypeCamera];
            }
            break;
        }
        case PHOTO_ALBUM:
        {
            [self addChildViewController:photoViewController];
            [photoViewController pickPhotoFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Photo Select View Delegate Methods
- (void)setImage:(UIImage *)imageFromPicker
{
    isProfileImageChanged = YES;
    self.userImage = imageFromPicker;
    self.myProfileImageView.image = imageFromPicker;
}

- (CGSize)getImageSize
{
    return self.myProfileImageView.bounds.size;
}

#pragma mark - UI Picker View Data Source
- (NSString *)getStringifNotNull:(NSInteger)value
{
    if(!value){
        return NULL;
    }else{
        return [NSString stringWithFormat:@"%d", value];
    }
}

- (NSArray *)getListFromPropertyList:(NSString *)plistName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:plistName withExtension:@"plist"];
    NSArray *list = [NSArray arrayWithContentsOfURL:plistURL];
    return list;
}

- (NSDictionary *)getDictionaryListFromPropertyList:(NSString *)plistName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:plistName withExtension:@"plist"];
    NSDictionary *list = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    return list;
}

- (NSMutableArray *)getNumberListWithRangeFrom:(NSInteger)minimum to:(NSInteger)maximum
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for(int i=minimum; i<maximum ; i++){
        [list addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return list;
}

@end
