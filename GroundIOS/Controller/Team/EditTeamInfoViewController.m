//
//  EditTeamInfoViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 9..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define TAKING_A_PICTURE    0
#define PHOTO_ALBUM         1

#define TEAM_TAB_TEAMMAIN   3

#import "EditTeamInfoViewController.h"
#import "TeamMainInfoViewController.h"
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
#import "UITextField+Util.h"

@implementation EditTeamInfoViewController{
    BOOL isImageChanged;
    BOOL isTeamInfoChanged;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.myTeamInfo = [[TeamInfo alloc] init];
    self.teamImage = [[UIImage alloc] init];
}

- (void)viewDidLayoutSubviews
{
    if([LocalUser getInstance].deviceOSVer < 7){
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor, UIFontFixedFontWithSize(12), UITextAttributeFont, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x1B252E)];
    
    [UITextField setVerticalPaddingWithTextField:self.teamNameTextField];
    [UITextField setVerticalPaddingWithTextField:self.teamLocationTextField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTeamInfoView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
    
    [self setDaumMapView];
}

- (void)configureTeamInfoView
{
    isImageChanged = NO;
    isTeamInfoChanged = NO;
    
    self.teamImageView.image = [ViewUtil circleMaskImageWithImage:self.teamImage];
    self.teamDetailInfoLabel.text = [NSString stringWithFormat:@"나이: %.1f세 \n팀원: %d명 \n클럽점수: %d점", [self.myTeamInfo.avgBirth floatValue], self.myTeamInfo.membersCount, self.myTeamInfo.score];
    self.teamNameTextField.text = self.myTeamInfo.name;
    self.teamLocationTextField.text = self.myTeamInfo.address;
    
    [self setDaumMapView];
}

- (void)setDaumMapView
{
    if(!self.mapView){
        self.mapView = [[MTMapView alloc] initWithFrame:[ViewUtil mapViewSizeInEditTeamInfoForiPhoneDeviceScreenHeight]];
        [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
        [self.mapView setUserInteractionEnabled:NO];
        self.mapView.currentLocationTrackingMode = NO;
        
        if(!self.poiItem){
            self.poiItem = [[MTMapPOIItem alloc] init];
            [self.poiItem setMapPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([self.myTeamInfo.latitude doubleValue], [self.myTeamInfo.longitude doubleValue])]];
            [self.poiItem setItemName:[MTMapReverseGeoCoder findAddressForMapPoint:self.poiItem.mapPoint withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"]];
            self.myTeamInfo.address = self.poiItem.itemName;
        }
        
        self.teamLocationTextField.text = self.myTeamInfo.address;
        [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:self.poiItem.mapPoint.mapPointGeo] zoomLevel:DAUM_MAP_ZOOM_LEVEL animated:YES];
        [self.mapView addPOIItem:self.poiItem];
        [self.teamLocationMapView addSubview:self.mapView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)uploadTeamInfo
{
    LoadingView *loadingView = [LoadingView startLoading:@"팀 정보를 수정하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] editTeamProfile:self.myTeamInfo callback:^(BOOL result, NSDictionary *data){
        if(result){
            
            [self.mapView removeFromSuperview];
            self.mapView = NULL;
            
            UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
            TeamTabbarParentViewController *childViewController = (TeamTabbarParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
            childViewController.user = self.user;
            childViewController.teamHint = self.teamHint;
            childViewController.tabbarSelectedIndex = TEAM_TAB_TEAMMAIN;
            [self presentViewController:childViewController animated:YES completion:nil];
            
        }else{
            NSLog(@"error to edit team info in edit team info");
            [Util showErrorAlertView:nil message:@"팀 정보를 수정하지 못했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToEditTeamInfo"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 
#pragma mark - IBAction Methods
- (IBAction)editTeamProfileButtonPressed:(id)sender
{
    self.myTeamInfo.name = self.teamNameTextField.text;
    
    if(isTeamInfoChanged){

        if(isImageChanged){

            [[GroundClient getInstance] uploadProfileImage:self.teamImage thumbnail:TRUE multipartCallback:^(BOOL result, NSDictionary *imagePath){
                if(result){
                    NSString *theImagePath = [imagePath valueForKey:@"path"];
                    self.myTeamInfo.imageUrl = theImagePath;
                    self.teamHint.imageUrl = theImagePath;
                    [self uploadTeamInfo];
                }else{
                    NSLog(@"error to edit team image in edit team info");
                    [Util showErrorAlertView:nil message:@"팀 사진을 수정하는데 실패했습니다"];
                }
            }];
            
        }else{
            
            [self uploadTeamInfo];
        }
    }else{
        [self.mapView removeFromSuperview];
        self.mapView = NULL;
        
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)teamImageViewTapped:(UITapGestureRecognizer *)sender
{
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"팀사진등록" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    photoActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [photoActionSheet addButtonWithTitle:@"사진찍기"];
    [photoActionSheet addButtonWithTitle:@"사진첩"];
    [photoActionSheet addButtonWithTitle:@"취소"];
    [photoActionSheet dismissWithClickedButtonIndex:2 animated:YES];
    
    [photoActionSheet showInView:self.view];
}

- (IBAction)teamLocationMapViewTapped:(UITapGestureRecognizer *)sender
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

#pragma mark - Map View Delegate Methods
- (void)setMapPOI:(MTMapPOIItem *)poiItem
{
    self.poiItem = poiItem;
    isTeamInfoChanged = YES;
    
    self.myTeamInfo.latitude = [NSNumber numberWithDouble:self.poiItem.mapPoint.mapPointGeo.latitude];
    self.myTeamInfo.longitude = [NSNumber numberWithDouble:self.poiItem.mapPoint.mapPointGeo.longitude];
    self.myTeamInfo.address = self.poiItem.itemName;
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
    isImageChanged = YES;
    isTeamInfoChanged = YES;
    
    self.teamImage = imageFromPicker;
    self.teamImageView.image = [ViewUtil circleMaskImageWithImage:self.teamImage];
    [self.teamImageView setNeedsDisplay];
}

- (CGSize)getImageSize
{
    return self.teamImageView.bounds.size;
}

@end
