//
//  MakeNewTeamViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 18..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define TAKING_A_PICTURE    0
#define PHOTO_ALBUM         1

#import "MakeNewTeamViewController.h"
#import "PhotoSelectViewController.h"
#import "TeamTabbarParentViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "TeamInfo.h"

#import "GroundClient.h"
#import "Config.h"
#import "LocalUser.h"

#import "Util.h"
#import "ViewUtil.h"
#import "StringUtils.h"
#import "UITextField+Util.h"

@implementation MakeNewTeamViewController{
    BOOL teamNameTextFieldTapped;
    
    CLLocationManager *locationManager;
    NSNumber *currentLatitude;
    NSNumber *currentLongitude;
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
    
    [UITextField setVerticalPaddingWithTextField:self.teamNameTextField];
    [UITextField setVerticalPaddingWithTextField:self.teamLocationTextfield];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user =[[User alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
    
    self.teamImageView.image = [ViewUtil circleMaskImageWithImage:[UIImage imageNamed:@"detailMatch_noCompetitive_logo"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
    
    teamNameTextFieldTapped = NO;
    self.myTeamInfo = [[TeamInfo alloc] init];
    [self setDaumMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setDaumMapView
{
    if(!self.mapView){
        self.mapView = [[MTMapView alloc] initWithFrame:[ViewUtil mapViewSizeInMakeTeamForiPhoneDeviceScreenHeight]];
        [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
        [self.mapView setUserInteractionEnabled:NO];
        self.mapView.currentLocationTrackingMode = NO;
        
        if(self.poiItem){
            [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:self.poiItem.mapPoint.mapPointGeo] zoomLevel:3 animated:YES];
            [self.mapView addPOIItem:self.poiItem];
            self.myTeamInfo.latitude = [NSNumber numberWithDouble:self.poiItem.mapPoint.mapPointGeo.latitude];
            self.myTeamInfo.longitude = [NSNumber numberWithDouble:self.poiItem.mapPoint.mapPointGeo.longitude];
            self.teamLocationTextfield.text = self.poiItem.itemName;
            self.myTeamInfo.address = self.poiItem.itemName;
        }else{
//            MyLocation *theLocation = [[MyLocation alloc] init];
//            CLLocation *currentLocation = [theLocation getCurrentLocation];
//            [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)] animated:YES];
//            [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.53737528, 127.00557633)] zoomLevel:4 animated:YES];

            if([LocalUser getInstance].currentLocation){
                self.mapView.currentLocationTrackingMode = YES;
            }
        }
        [self.teamMapView addSubview:self.mapView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"CancelMakeNewTeam"]){
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - 
#pragma mark - IBAction Methods
- (IBAction)teamImageViewSelected:(UITapGestureRecognizer *)sender
{
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"팀사진등록" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    photoActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [photoActionSheet addButtonWithTitle:@"사진찍기"];
    [photoActionSheet addButtonWithTitle:@"사진첩"];
    [photoActionSheet addButtonWithTitle:@"취소"];
    [photoActionSheet dismissWithClickedButtonIndex:2 animated:YES];
    
    [photoActionSheet showInView:self.view];
}


- (IBAction)teamLocationSelected:(UITapGestureRecognizer *)sender
{
    [self.mapView removeFromSuperview];
    self.mapView = NULL;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jet_Storyboard" bundle:nil];
    MapViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    if(self.poiItem){
        [childViewController setPoiItem:self.poiItem];
    }
    childViewController.groundTag = 0;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.teamNameTextField resignFirstResponder];
}

- (IBAction)makeTeamButtonTapped:(id)sender
{
    if (self.myTeamInfo.address == NULL) {
        self.myTeamInfo.latitude = currentLatitude;
        self.myTeamInfo.longitude = currentLongitude;
        
        MTMapPoint *mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([currentLatitude floatValue], [currentLongitude floatValue])];
        self.myTeamInfo.address = [MTMapReverseGeoCoder findAddressForMapPoint:mapPoint withOpenAPIKey:MAP_OPEN_API_KEY];
    }
    
    if ([[StringUtils getInstance] stringIsEmpty:self.teamNameTextField.text]) {
        
        [Util showAlertView:nil message:@"팀이름을 입력해주세요"];
        
    }else{

        self.myTeamInfo.name = self.teamNameTextField.text;
        
        // WITH IMAGE
        if (self.teamImage == nil) {
            [self makeNewTeam];
            
        // WITHOUT IMAGE
        }else{
            [[GroundClient getInstance] uploadProfileImage:self.teamImage thumbnail:TRUE multipartCallback:^(BOOL result, NSDictionary *imagePath){
                if(result){
                    self.myTeamInfo.imageUrl = [imagePath valueForKey:@"path"];
                    [self makeNewTeam];
                }else{
                    NSLog(@"upload team image error");
                    [Util showAlertView:nil message:@"엠블렘 업로드에 에러가 발생했습니다.\n다시 시도해 주시기 바랍니다.\n불편을 드려 죄송합니다."];
                }
            }];
        }
    }
}

- (void)makeNewTeam
{
    LoadingView *loadingView = [LoadingView startLoading:@"팀을 만들고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] registerTeam:self.myTeamInfo callback:^(BOOL result, NSDictionary *data){
        if(result){
            [self.mapView removeFromSuperview];
            self.mapView = NULL;
            NSInteger newTeamId = [[data valueForKey:@"teamId"] integerValue];
            UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
            TeamTabbarParentViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
            childViewController.user = self.user;
            TeamHint *theTeamHint = [[TeamHint alloc] initWithTeamId:newTeamId TeamName:self.myTeamInfo.name teamImage:self.myTeamInfo.imageUrl isManager:YES];
            childViewController.teamHint = theTeamHint;
            
            [self presentViewController:childViewController animated:YES completion:nil];
        }else{
            NSLog(@"register new team error");
            [Util showErrorAlertView:nil message:@"팀 등록을 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (IBAction)teamNameTextFieldTapped:(id)sender
{
    if (!teamNameTextFieldTapped) {
        teamNameTextFieldTapped = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        self.view.frame = [ViewUtil adjustViewHeightForEditingWithView:self.view toFrame:self.teamNameTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)teamNameTextFieldResignResponder:(id)sender
{
    if (teamNameTextFieldTapped) {
        teamNameTextFieldTapped = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        self.view.frame = [ViewUtil adjustViewHeightForEndEdtingWithView:self.view toFrame:self.teamNameTextField.frame];
        [UIView commitAnimations];
    }
}

- (IBAction)teamLocationTextFieldTapped:(id)sender
{
    [self.mapView removeFromSuperview];
    self.mapView = NULL;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jet_Storyboard" bundle:nil];
    MapViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    if(self.poiItem){
        [childViewController setPoiItem:self.poiItem];
    }
    childViewController.groundTag = 0;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - ActionSheet Delegate Methods
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

#pragma mark - PhotoSelectView Delegate Methods
- (void)setImage:(UIImage *)imageFromPicker
{
    self.teamImage = [[UIImage alloc] init];
    self.teamImage = imageFromPicker;
    self.teamImageView.image = [ViewUtil circleMaskImageWithImage:self.teamImage];
}

- (CGSize)getImageSize
{
    return self.teamImageView.bounds.size;
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.teamNameTextField){
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Map View Delegate Methods
- (void)setMapPOI:(MTMapPOIItem *)poiItem
{
    self.poiItem = poiItem;
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error to load my location in make new match");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)newLocations
{
    CLLocation *currentLocation = [newLocations objectAtIndex:0];
    
    if (currentLocation != nil) {
        currentLatitude = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
        currentLongitude = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
    }
    
    [locationManager stopUpdatingLocation];
}

@end
