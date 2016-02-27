//
//  MapViewController_backup.m
//  GroundIOS_JET
//
//  Created by Jet on 13. 7. 30..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#define REGISTER_TEAM 0
#define REGISTER_GROUND 1

#import "MapViewController_backup.h"
#import "PopUpViewController.h"
#import "LocalUser.h"
#import "PopUpView.h"
#import "Ground.h"
#import "Util.h"
#import "Config.h"

@implementation MapViewController_backup

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
//    
//    if(!self.poiItem)
//    {
//        [self.mapViewController.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.53737528, 127.00557633)] zoomLevel:4 animated:YES];
//    }else{
//        [self.mapViewController.mapView selectPOIItem:self.poiItem animated:YES];
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self.mapViewController.mapView removeFromSuperview];
//    self.mapViewController.mapView = NULL;
//    self.poiItem = NULL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDaumMapView:(MTMapPOIItem*)poiItem
{
    self.ground = [[Ground alloc] init];
    self.mapViewController = [[DaumMapViewController alloc] init];
    self.mapViewController.mapView.delegate = self;
    
    // 기존에 선택된 위치(POI ITEM)가 있을 경우, 그것을 DaumMapViewController에서 맵의 중심으로 하여 표시.
    if(!poiItem){
        
//         if([LocalUser getInstance].currentLocation){
//             self.mapViewController.mapView.currentLocationTrackingMode = YES;
//         }
        
        [self.mapViewController.mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.53737528, 127.00557633)] zoomLevel:4 animated:YES];
    }else{
        self.poiItem = poiItem;
        
        [self.mapViewController.mapView setMapCenterPoint:poiItem.mapPoint zoomLevel:4 animated:YES];
        [self.mapViewController.mapView addPOIItem:poiItem];
        [self.mapViewController.mapView selectPOIItem:poiItem animated:YES];
    }
    
    // 네비게이션 설정.
    UINavigationController* naviController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
    [self presentViewController:naviController animated:NO completion:NULL];
}

- (void)done
{
    if(self.registerTag == REGISTER_GROUND){
        [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n위 주소를 새로운 운동장으로 등록하시겠습니까?", self.poiItem.itemName] title:nil];
    }else{
        [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n 위 주소를 선택하시겠습니까?", self.poiItem.itemName] title:nil];
    }
}

- (void)cancel
{
    [self.mapViewController.mapView removeFromSuperview];
    self.mapViewController.mapView = NULL;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Map View Event
#pragma mark MTMapViewDelegate

// 맵을 한번 탭한 경우.
// 맵에 POI ITEM이 없을 때는 새로 하나 생성.
// 있을 때는 기존의 POI ITEM의 위치만 현재 탭한 위치로 바꿈.
- (void)MTMapView:(MTMapView*)mapView singleTapOnMapPoint:(MTMapPoint*)mapPoint
{
    NSString* address = nil;
    
    if(!self.poiItem){
        
        self.poiItem = [MTMapPOIItem poiItem];
        self.poiItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:mapPoint.mapPointGeo];
        self.poiItem.markerType = MTMapPOIItemMarkerTypeBluePin;
        self.poiItem.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;
        self.poiItem.draggable = YES;
        
        [self.ground setLatitude:[NSNumber numberWithDouble:self.poiItem.mapPoint.mapPointGeo.latitude]];
        [self.ground setLongitude:[NSNumber numberWithDouble:self.poiItem.mapPoint.mapPointGeo.longitude]];
    }else{
        
        [mapView removeAllPOIItems];
        self.poiItem.mapPoint = mapPoint;
    }
    
    // POI ITEM의 위치에 따른 한글 주소를 받아 item name에 저장.
    address = [MTMapReverseGeoCoder findAddressForMapPoint:mapPoint withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"];
    
    self.poiItem.itemName = address;
    [self.ground setAddress:address];
    
    [mapView addPOIItem:self.poiItem];
    [mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:mapPoint.mapPointGeo] zoomLevel:mapView.zoomLevel animated:YES];
    
    // POI ITEM이 선택됨을 표시. 주소가 위에 나타남.
    [mapView selectPOIItem:self.poiItem animated:YES];
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
    // 운동장 등록하는 중 맵 POI ITEM의 말풍선 선택시
    if(self.registerTag == REGISTER_GROUND){
        [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n위 주소를 새로운 운동장으로 등록하시겠습니까?", self.poiItem.itemName] title:nil];
    // 기타 나머지 경우 맵 POI ITEM의 말풍선 선택시
    }else{
        [Util showConfirmAlertView:self message:[NSString stringWithFormat:@"%@\r\n 위 주소를 선택하시겠습니까?", self.poiItem.itemName] title:nil];
    }
}

// 이동가능한(draggable) POI ITEM의 위치가 이동되었을 때 이동된 곳의 위치로 옮긴 후, POI ITEM의 위치와 주소 새로 받음.
- (void)MTMapView:(MTMapView*)mapView draggablePOIItem:(MTMapPOIItem*)poiItem movedToNewMapPoint:(MTMapPoint*)newMapPoint
{
    NSString* address = [MTMapReverseGeoCoder findAddressForMapPoint:newMapPoint  withOpenAPIKey:@"DAUM_LOCAL_DEMO_APIKEY"];
    
    self.poiItem.mapPoint = newMapPoint;
    self.poiItem.itemName = address;
    poiItem.itemName = address;
    
    [mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:newMapPoint.mapPointGeo] zoomLevel:mapView.zoomLevel animated:YES];
    [mapView selectPOIItem:poiItem animated:YES];
}

- (void)MTMapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy
{
    MTMapPointGeo currentLocationPointGeo = location.mapPointGeo;
	NSLog(@"MTMapView updateCurrentLocation (%f,%f) accuracy (%f)",
          currentLocationPointGeo.latitude, currentLocationPointGeo.longitude, accuracy);
}

// 주소 받아오는 Delegate
#pragma mark MTMapReverseGeoCoderDelegate

- (void)MTMapReverseGeoCoder:(MTMapReverseGeoCoder*)rGeoCoder foundAddress:(NSString*)addressString
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
														message:[NSString stringWithFormat:@"Center Point Address = [%@]", addressString]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
    
	self.reverseGeoCoder = nil;
}

- (void)MTMapReverseGeoCoder:(MTMapReverseGeoCoder*)rGeoCoder failedToFindAddressWithError:(NSError*)error
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
														message:[NSString stringWithFormat:@"Reverse Geo-Coding Failed with Error : %@", error.localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
    
	self.reverseGeoCoder = nil;
}

// Alert view Delegate
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.firstOtherButtonIndex){

        if(self.registerTag == REGISTER_GROUND){
            [self.mapViewController.mapView deselectPOIItem:self.poiItem];
            [self.mapViewController.view addSubview:self.mapViewController.popUpView];
            [self.mapViewController.mapView bringSubviewToFront:self.mapViewController.popUpView];
            
//            self.popUpView = [PopUpView popUp:@"새로운 운동장명을 입력하세요" parentView:self.mapViewController.mapView];
//            self.popUpView.ground = self.ground;
//            
//            while(self.popUpView != nil){
//                
//                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            }
            
            // 맵에서 선택한 POI ITEM을 MakeNewTeamViewController의 것으로 복사.
//            [self.ground setAddress:self.poiItem.itemName];
//            [self.ground setGroundId:self.poiItem.tag];
//            
//            [(id)self.parentViewController.navigationController.childViewControllers.firstObject setGround:self.ground];
//            
//            [self.mapViewController.mapView removeFromSuperview];
//            self.mapViewController.mapView = NULL;
//            
//            [self dismissViewControllerAnimated:NO completion:NULL];
//            [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            // 맵에서 선택한 POI ITEM을 RegisterTeamViewController의 것으로 복사.
//            [((id<MapViewDelegate>)self.parentViewController) setMapPOI:self.poiItem];
            // 다움맵은 하나의 객체만 허용함 - DaumMapViewController에서 부른 다움맵 객체 제거.
            [self.mapViewController.mapView removeFromSuperview];
            self.mapViewController.mapView = NULL;
            
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

@end
