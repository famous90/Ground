//
//  DaumMapViewController.m
//  GroundIOS_JET
//
//  Created by Jet on 13. 7. 25..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "DaumMapViewController.h"
#import "Config.h"

@implementation DaumMapViewController

- (id)init
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = screenSize.width; // 320(iPhone) 768(iPad)
    CGFloat screenHeight = screenSize.height; // 480(iPhone) 1024(iPad) 568(iPhone5)
    CGRect mapViewFrame = CGRectMake(0, 0, screenWidth, screenHeight - 44 - 20);
    
    [MTMapView setMapTilePersistentCacheEnabled:YES];
    
    self.mapView = [[MTMapView alloc] initWithFrame:mapViewFrame];
    [self.mapView setDaumMapApiKey:DAUM_MAP_APIKEY];
    self.mapView.baseMapType = MTMapTypeStandard;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    
    // 왼쪽 버튼과 오른쪽 버튼 네비게이션바에 추가.
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStylePlain target:self.mapView.delegate action:@selector(cancel)];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"선택" style:UIBarButtonItemStylePlain target:self.mapView.delegate action:@selector(done)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
