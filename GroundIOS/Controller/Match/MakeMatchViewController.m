//
//  MakeMatchViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#import "MakeMatchViewController.h"
#import "DetailMatchViewController.h"
#import "SearchTeamForNewMatchViewController.h"
#import "SearchGroundForNewMatchViewController.h"
#import "LoadingView.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "Config.h"
#import "GroundClient.h"
#import "MyLocation.h"

#import "NSDate+Utils.h"
#import "Util.h"
#import "ViewUtil.h"
#import "UITextField+Util.h"

#import "LocalUser.h"
#import "User.h"
#import "TeamHint.h"
#import "Match.h"
#import "MatchInfo.h"
#import "Ground.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface MakeMatchViewController()
- (void)startTimeWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)endTimeWasSelected:(NSDate *)selectedDate element:(id)element;
@end

@implementation MakeMatchViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if([LocalUser getInstance].deviceOSVer < 7){
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor, UIFontFixedFontWithSize(10), UITextAttributeFont, nil] forState:UIControlStateNormal];
    }else{
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor, UIFontFixedFontWithSize(12), UITextAttributeFont, nil] forState:UIControlStateNormal];
    }
    
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x1B252E)];
    
    [UITextField setVerticalPaddingWithTextField:self.startTimeTextField];
    [UITextField setVerticalPaddingWithTextField:self.endTimeTextField];
    [UITextField setVerticalPaddingWithTextField:self.locationTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.selectedTime = [NSDate date];
    self.matchInfo = [[MatchInfo alloc] init];
    self.matchOpenCheckbox.selected = NO;
    
    [self setMatchMapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ground = [[Ground alloc] init];
    self.matchInfo = [[MatchInfo alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMatchMapView
{
    if(!self.mapView){
        self.mapView = [[MTMapView alloc] initWithFrame:[ViewUtil mapViewSizeInMakeMatchForiPhoneDeviceScreenHeight]];
        [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
        [self.mapView setUserInteractionEnabled:NO];
        self.mapView.currentLocationTrackingMode = NO;

        if(self.ground.groundId){
            float latitude = [self.ground.latitude floatValue];
            float longitude = [self.ground.longitude floatValue];
            
            self.poiItem = [MTMapPOIItem poiItem];
            self.poiItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latitude, longitude)];
            self.poiItem.markerType = MTMapPOIItemMarkerTypeBluePin;
            self.poiItem.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;
            self.poiItem.itemName = self.ground.name;
        }

        if(self.poiItem){
            [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:self.poiItem.mapPoint.mapPointGeo] zoomLevel:DAUM_MAP_ZOOM_LEVEL animated:YES];
            [self.mapView addPOIItem:self.poiItem];
            self.locationTextField.text = self.poiItem.itemName;
        }else{
//            MyLocation *theLocation = [[MyLocation alloc] init];
//            CLLocation *currentLocation = [theLocation getCurrentLocation];
//            [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)] animated:YES];
//            [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.53737528, 127.00557633)] zoomLevel:4 animated:YES];
            if([LocalUser getInstance].currentLocation){
                self.mapView.currentLocationTrackingMode = YES;
            }
        }
        
        [self.matchLocationView addSubview:self.mapView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"CancelMakeNewMatch"]){
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([[segue identifier] isEqualToString:@"SearchGroundToMakeNewMatch"]){
        SearchGroundForNewMatchViewController *childViewController = (SearchGroundForNewMatchViewController *)[segue destinationViewController];
        childViewController.makeMatchViewController = self;
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
    }
    
    if ([[segue identifier] isEqualToString:@"SearchTeamToMakeNewMatch"]) {
        SearchTeamForNewMatchViewController *childViewController = (SearchTeamForNewMatchViewController *)[segue destinationViewController];
        childViewController.originType = VIEW_FROM_MAKING_NEW_MATCH;
        childViewController.makeMatchViewController = self;
        childViewController.user = self.user;
        
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - IBAction
- (IBAction)selectedStartTime:(UIControl *)sender
{
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"시작시간 선택" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.selectedTime minimumDate:[NSDate date] target:self action:@selector(startTimeWasSelected:element:) origin:sender];
    [self.actionSheetPicker addCustomButtonWithTitle:@"담주" value:[[NSDate date] dateByAddingCalendarUnits:NSWeekCalendarUnit amount:1]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"담달" value:[[NSDate date] dateByAddingCalendarUnits:NSMonthCalendarUnit amount:1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)startTimeButtonTapped:(UIBarButtonItem *)sender
{
    [self selectedStartTime:sender];
}

- (IBAction)selectedEndTime:(UIControl *)sender
{
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"종료시간선택" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.selectedTime minimumDate:self.selectedTime target:self action:@selector(endTimeWasSelected:element:) origin:sender];
    [self.actionSheetPicker addCustomButtonWithTitle:@"1H" value:[self.selectedTime dateByAddingCalendarUnits:NSHourCalendarUnit amount:1]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"2H" value:[self.selectedTime dateByAddingCalendarUnits:NSHourCalendarUnit amount:2]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"3H" value:[self.selectedTime dateByAddingCalendarUnits:NSHourCalendarUnit amount:3]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)endTimeButtonTapped:(UIBarButtonItem *)sender
{
    [self selectedEndTime:sender];
}

- (IBAction)locationTextFieldTapped:(id)sender
{
    [self.mapView removeFromSuperview];
    self.mapView = NULL;
    
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    SearchGroundForNewMatchViewController *childViewController = (SearchGroundForNewMatchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchGroundForNewMatchView"];
    childViewController.makeMatchViewController = self;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.matchInfo setHomeTeamId:self.teamHint.teamId];
    [self.matchInfo setDescription:self.descriptionTextView.text];
    [self.matchInfo setOpen:[self.matchOpenCheckbox isSelected]];
    [self.matchInfo setGround:self.ground];
    [self.matchInfo setStartTime:self.selectedStartTime];
    [self.matchInfo setEndTime:self.selectedEndTime];
    [self.matchInfo setAwayTeamId:self.competitiveTeamId];
    
    if(!(self.matchInfo.startTime && self.matchInfo.endTime && self.ground.groundId)){
        [Util showAlertView:nil message:@"경기시간과 장소는 필수입력입니다"];
    }else{
        LoadingView *loadingView = [LoadingView startLoading:@"새로운 경기를 등록하고 있습니다" parentView:self.view];
        
        [[GroundClient getInstance] createMatchWithMatchInfo:self.matchInfo callback:^(BOOL result, NSDictionary *data){
            if(result){
                NSInteger matchId = [[data valueForKey:@"matchId"] integerValue];
                
                // GAI Tracking - 경기만들기
                [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match" action:@"make" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:0] build]];
                [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"match" label:@"make" value:0] build]];
                
                // GAI Tracking - 경기초대
                if(self.matchInfo.awayTeamId){
                    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"match" action:@"invite" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:0] build]];
                    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"match" label:@"invite" value:0] build]];
                }
                
                [self.mapView removeFromSuperview];
                self.mapView = NULL;
                
                [self dismissViewControllerAnimated:NO completion:nil];
                
                UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
                UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
                DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
                childViewController.user =  self.user;
                childViewController.teamHint = self.teamHint;
                childViewController.match.matchId = matchId;
                [self.matchsViewController presentViewController:navController animated:YES completion:nil];
                
            }else{
                NSLog(@"add new match error in make match");
                [Util showErrorAlertView:nil message:@"경기 등록에 실패했습니다"];
            }
            
            [loadingView stopLoading];
        }];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelSearchTeamForMatch"] || [[segue identifier] isEqualToString:@"CancelToSearchGround"]) {
    }
    if ([[segue identifier] isEqualToString:@"CancelToShowCompetitiveInfo"]) {
    }
}

- (IBAction)matchOpenCheckboxSelected:(id)sender
{
    if ([self.matchOpenCheckbox isSelected]) {
        [self.matchOpenCheckbox setSelected:NO];
    }else{
        [self.matchOpenCheckbox setSelected:YES];
    }
}

- (IBAction)desciptionTextViewTapped:(id)sender
{
    [self.descriptionTitleLabel setHidden:YES];
    [self.descriptionTextView becomeFirstResponder];
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - Implementation
- (void)startTimeWasSelected:(NSDate *)selectedDate element:(id)element
{
    self.matchInfo.startTime = [selectedDate timeIntervalSince1970];
    self.selectedStartTime = [selectedDate timeIntervalSince1970];
    self.selectedTime = selectedDate;
    self.startTimeTextField.text = [NSDate GeneralFormatDateFromNSTimeInterval:self.selectedStartTime format:9];
}

- (void)endTimeWasSelected:(NSDate *)selectedDate element:(id)element
{
    self.matchInfo.endTime = [selectedDate timeIntervalSince1970];
    self.selectedEndTime = [selectedDate timeIntervalSince1970];
    self.endTimeTextField.text = [NSDate GeneralFormatDateFromNSTimeInterval:self.selectedEndTime format:9];

}

- (void)keyboardWillShow:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:.1];
    [UIView setAnimationCurve:animationCurve];
    
    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect frame = self.view.frame;
        CGFloat diffHeight = (self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height) - keyboardTop;
        frame.origin.y -= diffHeight;
        self.view.frame = frame;
    } else {
        // Keyboard is going away (down) - restore original frame
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }
    
    [UIView commitAnimations];
}

@end
