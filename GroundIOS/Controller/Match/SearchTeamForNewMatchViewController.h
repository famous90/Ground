//
//  SearchTeamForNewMatchViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MakeMatchViewController.h"

@class User;
@class TeamHint;

@interface SearchTeamForNewMatchViewController : UITableViewController<UIActionSheetDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

// view
@property (weak) MakeMatchViewController *makeMatchViewController;
@property (strong, nonatomic) IBOutlet UITableView *searchTeamTableView;

// data
@property (nonatomic, assign) NSInteger originType;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger distance;

- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
