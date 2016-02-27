//
//  VersionInfoViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define VERSION_INFO_SECTION    0
#define PROVISION_SECTION       1

#define APP_VERSION_ROW     0
#define NEW_VERSION_ROW     1

#define MEMBER_CLAUSE_ROW   0
#define PRIVACY_POLICY_ROW  1

#import "VersionInfoViewController.h"
#import "PolicyViewController.h"

#import "ViewUtil.h"

@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark -
#pragma mark - UI Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == VERSION_INFO_SECTION) {
        return 2;
        
    }else if (section == PROVISION_SECTION){
        return 2;
        
    }else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    static NSString *CellIdentifier = nil;
    NSString *mainTitle = nil;
    NSString *subTitle = nil;
    
    if (indexPath.section == VERSION_INFO_SECTION) {
        if (indexPath.row == APP_VERSION_ROW) {
            CellIdentifier = @"AppVersionCell";
            mainTitle = @"현재버전";
            subTitle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            
        }else if (indexPath.row == NEW_VERSION_ROW){
            CellIdentifier = @"NewVersionCell";
            mainTitle = @"최신버전";
            subTitle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            
        }
        
    }else if (indexPath.section == PROVISION_SECTION){
        if (indexPath.row == MEMBER_CLAUSE_ROW) {
            CellIdentifier = @"MemberClauseCell";
            mainTitle = @"이용약관";
            
        }else if (indexPath.row == PRIVACY_POLICY_ROW){
            CellIdentifier = @"PrivacyPolicyCell";
            mainTitle = @"개인정보취급방침";
        }
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = mainTitle;
    //    [cell.textLabel setFont:UIFontHelveticaBoldWithSize(16)];
    if (indexPath.section == VERSION_INFO_SECTION) {
        cell.detailTextLabel.text = subTitle;
        //        [cell.detailTextLabel setFont:UIFontHelveticaBoldWithSize(16)];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - UI Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    
    if (indexPath.section == PROVISION_SECTION) {
        PolicyViewController *childViewController = (PolicyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PolicyView"];
        childViewController.pageOriginType = VIEW_FROM_VERSION_INFO;
        
        if (indexPath.row == MEMBER_CLAUSE_ROW) {
            childViewController.pageType = VIEW_WITH_SERVICE_POLICY;
            
        }else if (indexPath.row == PRIVACY_POLICY_ROW){
            childViewController.pageType = VIEW_WITH_PRIVACY_POLICY;
        }
        
        [self.navigationController pushViewController:childViewController animated:YES];
    }
}

#pragma mark - IBAction
- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelToShowPolicy"]) {
    }
}
@end
