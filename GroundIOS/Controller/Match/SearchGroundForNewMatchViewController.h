//
//  SearchGroundForNewMatchViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 26..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "MakeMatchViewController.h"

@interface SearchGroundForNewMatchViewController : UITableViewController<UISearchBarDelegate, UITextFieldDelegate>

@property (weak) MakeMatchViewController *makeMatchViewController;

@end
