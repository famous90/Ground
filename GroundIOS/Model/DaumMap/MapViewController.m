//
//  MapViewController.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 10. 17..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define REGISTER_TEAM 0
#define REGISTER_GROUND 1
#define SEARCH_TEAM 2

#import "MapViewController.h"
#import "PopUpViewController.h"

#import "LocalUser.h"
#import "GroundClient.h"
#import "MyLocation.h"
#import "Ground.h"
#import "Util.h"
#import "Config.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = screenSize.width; // 320(iPhone) 768(iPad)
    CGFloat screenHeight = screenSize.height; // 480(iPhone) 1024(iPad) 568(iPhone5)
    CGRect mapViewFrame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    [MTMapView setMapTilePersistentCacheEnabled:YES];
    
    self.mapView = [[MTMapView alloc] initWithFrame:mapViewFrame];
    [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
    self.mapView.baseMapType = MTMapTypeStandard;
    self.mapView.delegate = self;
    
    // 기존에 선택된 위치(POI ITEM)가 있을 경우, 그것을 맵의 중심으로 하여 표시.
    if(self.poiItem){
        [self.mapView setMapCenterPoint:self.poiItem.mapPoint zoomLevel:4 animated:YES];
        [self.mapView addPOIItem:self.poiItem];
        [self.mapView selectPOIItem:self.poiItem animated:YES];
        self.mapView.currentLocationTrackingMode = NO;
    }else{
        if([LocalUser getInstance].currentLocation){
            self.mapView.currentLocationTrackingMode = YES;
        }
        
//        [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.53737528, 127.00557633)] zoomLevel:4 animated:YES];
//        MyLocation *theLocation = [[MyLocation alloc] init];
//        CLLocation *currentLocation = [theLocation getCurrentLocation];
//        [self.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)] animated:YES];
    }
    
    [self.view addSubview:self.mapView];
        
    // 왼쪽 버튼과 오른쪽 버튼 네비게이션바에 추가.
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStylePlain target:self.mapView.delegate action:@selector(cancel)];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"선택" style:UIBarButtonItemStylePlain target:self.mapView.delegate action:@selector(done)];
    if(self.groundTag == REGISTER_GROUND){
        rightButton.title = @"등록";
    }
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if(self.groundTag == REGISTER_GROUND){
        self.ground = [[Ground alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    NSLog(@"POI ITEM = %@", ((MTMapPOIItem*)self.mapView.poiItems.lastObject));
    
    if(((MTMapPOIItem*)self.mapView.poiItems.lastObject) == nil)
    {
        if(self.groundTag == REGISTER_GROUND){
            [Util showAlertView:self message:@"운동장을 먼저 선택해주세요." title:@"확인"];
        }else{
            [Util showAlertView:self message:@"위치를 먼저 선택해주세요." title:@"확인"];
        }
    }else{
        if(self.groundTag == REGISTER_GROUND){
            [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n위 주소를 새로운 운동장으로 등록하시겠습니까?", ((MTMapPOIItem*)self.mapView.poiItems.lastObject).itemName] title:nil];
        }else{
            [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n 위 주소를 선택하시겠습니까?", ((MTMapPOIItem*)self.mapView.poiItems.lastObject).itemName] title:nil];
        }
    }
}

- (void)cancel
{
    [self.popUpView removeFromSuperview];
    [self.mapView removeFromSuperview];
    self.mapView = NULL;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PopUpView"]){
        PopUpViewController *childViewController = (PopUpViewController *)[segue destinationViewController];
        [childViewController setPopUpTextStr:@"새로운 운동장명을 입력하세요.\r\n등록과 동시에 이 운동장이 선택됩니다."];
        childViewController.mapViewController = self;
    }
}

#pragma mark popUpViewController Actions
- (void)doRegisterGround:(NSString*)groundName
{
    [self.ground setName:groundName];
    [self.ground setLatitude:[NSNumber numberWithDouble:((MTMapPOIItem*)self.mapView.poiItems.lastObject).mapPoint.mapPointGeo.latitude]];
    [self.ground setLongitude:[NSNumber numberWithDouble:((MTMapPOIItem*)self.mapView.poiItems.lastObject).mapPoint.mapPointGeo.longitude]];
    [self.ground setAddress:((MTMapPOIItem*)self.mapView.poiItems.lastObject).itemName];
    
    [[GroundClient getInstance] registerGround:self.ground callback:^(BOOL result, NSDictionary *data) {
        
        if(result){
            
            [self receivedRegisterGroundResponse:data];
        }else{
//            NSInteger code = [[data valueForKey:@"code"] integerValue];
//            NSLog(@"code = %d", code);
        }
    }];
}

- (void)receivedRegisterGroundResponse:(NSDictionary*)data
{
    [self.ground setGroundId:[[data valueForKey:@"groundId"] integerValue]];
    
    // 맵에서 선택한 POI ITEM 정보를 Ground객체에 담아 MakeMatchViewController의 것으로 복사.
    [[self.navigationController.viewControllers objectAtIndex:0] setGround:self.ground];
    
    // 다움맵은 하나의 객체만 허용함 - DaumMapViewController에서 부른 다움맵 객체 제거.
    [self.mapView removeFromSuperview];
    self.mapView = NULL;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    self.poiItem = self.mapView.poiItems.lastObject;
//    [[self.navigationController.viewControllers objectAtIndex:0] setMapPOI:self.poiItem];
//    NSLog(@"ground name = %@, ground latitude = %f, ground longitude = %f, ground address = %@, ground id = %d", self.ground.name, [self.ground.latitude doubleValue], [self.ground.longitude doubleValue], self.ground.address, self.ground.groundId);
}

// Map View Event
#pragma mark MTMapViewDelegate

// 맵을 한번 탭한 경우.
// 맵에 POI ITEM이 없을 때는 새로 하나 생성.
// 있을 때는 기존의 POI ITEM의 위치만 현재 탭한 위치로 바꿈.
- (void)MTMapView:(MTMapView*)mapView singleTapOnMapPoint:(MTMapPoint*)mapPoint
{
    [mapView removeAllPOIItems];
    
    MTMapPOIItem *poiItem = [MTMapPOIItem poiItem];
    poiItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:mapPoint.mapPointGeo];
    poiItem.markerType = MTMapPOIItemMarkerTypeBluePin;
    poiItem.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;
    poiItem.draggable = YES;
    
    // POI ITEM의 위치에 따른 한글 주소를 받아 item name에 저장.
    NSString *address = [MTMapReverseGeoCoder findAddressForMapPoint:mapPoint withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"];
    poiItem.itemName = address;
    NSLog(@"POI ITEM ADDRESS = %@", address);
    
    [mapView addPOIItem:poiItem];
    [mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:poiItem.mapPoint.mapPointGeo] zoomLevel:mapView.zoomLevel animated:YES];
    
    // POI ITEM이 선택됨을 표시. 주소가 위에 나타남.
    [mapView selectPOIItem:poiItem animated:YES];
    mapView.currentLocationTrackingMode = NO;
}

// Map을 두번 탭했을 때 Zoom in.
- (void)MTMapView:(MTMapView*)mapView doubleTapOnMapPoint:(MTMapPoint*)mapPoint
{
    //[mapView zoomInAnimated:YES];
}

// POI ITEM이 터치되었을 때, 말풍선을 보여주고자 하면 YES를 리턴.
- (BOOL)MTMapView:(MTMapView*)mapView selectedPOIItem:(MTMapPOIItem*)poiItem
{
    return YES;
}

// POI ITEM의 말풍선이 터치되었을 때
- (void)MTMapView:(MTMapView*)mapView touchedCalloutBalloonOfPOIItem:(MTMapPOIItem*)poiItem
{
    
    [self done];
//    // 운동장 등록하는 중 맵 POI ITEM의 말풍선 선택시
//    if(self.registerTag == REGISTER_GROUND){
//        [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n위 주소를 새로운 운동장으로 등록하시겠습니까?", poiItem.itemName] title:nil];
//        // 기타 나머지 경우 맵 POI ITEM의 말풍선 선택시
//    }else{
//        [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n 위 주소를 선택하시겠습니까?", poiItem.itemName] title:nil];
//    }
}

// 이동가능한(draggable) POI ITEM의 위치가 이동되었을 때 이동된 곳의 위치로 옮긴 후, POI ITEM의 위치와 주소 새로 받음.
- (void)MTMapView:(MTMapView*)mapView draggablePOIItem:(MTMapPOIItem*)poiItem movedToNewMapPoint:(MTMapPoint*)newMapPoint
{
    NSString* address = [MTMapReverseGeoCoder findAddressForMapPoint:newMapPoint  withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"];
    poiItem.itemName = address;
    
    [mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:newMapPoint.mapPointGeo] zoomLevel:mapView.zoomLevel animated:YES];
    [mapView selectPOIItem:poiItem animated:YES];
}

- (void)MTMapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy
{
    [mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(location.mapPointGeo.latitude, location.mapPointGeo.longitude)] animated:YES];
	NSLog(@"MTMapView updateCurrentLocation (%f,%f) accuracy (%f)",
          location.mapPointGeo.latitude, location.mapPointGeo.longitude, accuracy);
}
     
// Alert view Delegate
#pragma mark UIAlertViewDelegate
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.firstOtherButtonIndex){
        if(self.groundTag == REGISTER_GROUND){
            [self.view bringSubviewToFront:self.popUpView];
            [self.mapView setUserInteractionEnabled:NO];
            
            self.mapView.opaque = NO;
            self.mapView.alpha = 0.5;
            self.mapView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        }else{
//            NSLog(@"view controller = %@", [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObjectIdenticalTo:self]-1]);
            self.poiItem = self.mapView.poiItems.lastObject;
            
            // 맵에서 선택한 POI ITEM을 이 뷰컨트롤러 바로 전 뷰컨트롤러로 복사.
            [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObjectIdenticalTo:self]-1] setMapPOI:self.poiItem];
            
            // 다움맵은 하나의 객체만 허용함 - DaumMapViewController에서 부른 다움맵 객체 제거.
            [self.mapView removeFromSuperview];
            self.mapView = NULL;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
