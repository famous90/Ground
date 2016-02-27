//
//  SearchMatchResultViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 31..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import <CoreLocation/CoreLocation.h>
#import "TeamTabbarParentViewController.h"

@class User;
@class TeamHint;
@class SearchMatchDataController;

@interface SearchMatchResultViewController : UITableViewController <UIActionSheetDelegate, MTMapViewDelegate, CLLocationManagerDelegate>

// view
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@property (assign) NSInteger pickerCellRowHeight;
@property (weak) TeamTabbarParentViewController *teamTabbarParentViewController;
@property (nonatomic, strong) UIView *coverView;

// Data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (strong, nonatomic) SearchMatchDataController *dataController;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (nonatomic, retain) MTMapPOIItem *poiItem;

@property (nonatomic, strong) NSDate *selectedStartTime;
@property (nonatomic, strong) NSDate *selectedEndTime;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSNumber *searchLatitude;
@property (nonatomic, strong) NSNumber *searchLongitude;
@property (nonatomic, strong) NSString *searchLocation;
@property (nonatomic, assign) NSInteger distance;

- (IBAction)slide:(id)sender;
- (IBAction)dateAction:(id)sender;
- (IBAction)doneAction:(id)sender;
- (IBAction)searchMatchButtonTapped:(id)sender;

@end
