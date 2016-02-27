//
//  EditManagerViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 15..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define MANAGER_SECTION     0
#define NORMAL_USER_SECTION 1

#import "EditManagerViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "UserDataController.h"

#import "GroundClient.h"
#import "LocalUser.h"

#import "Util.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation EditManagerViewController{
    UserDataController *newManagerList;
    UserDataController *oldManagerList;
    UserDataController *changeManagerList;
    NSArray *userList;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.managerUserList = [[UserDataController alloc] init];
    self.normarUserList = [[UserDataController alloc] init];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    newManagerList = [[UserDataController alloc] init];
    oldManagerList = [[UserDataController alloc] init];
    changeManagerList = [[UserDataController alloc] init];
    
    userList = [[NSArray alloc] initWithObjects:self.managerUserList, self.normarUserList, nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToEditManager"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[userList objectAtIndex:section] countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *CellIdentifierArray = [[NSArray alloc] initWithObjects:@"ManagerUserCell", @"NormalUserCell", nil];
    NSArray *tagArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:521], [NSNumber numberWithInt:523], nil];
    NSInteger tag = [[tagArray objectAtIndex:indexPath.section] intValue];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifierArray objectAtIndex:indexPath.section] forIndexPath:indexPath];
    
    User *theUser = [[userList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:tag];
    userNameLabel.text = theUser.name;
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == MANAGER_SECTION ? @"매니져": @"일반멤버";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    User *theUser = [[User alloc] initWithUser:[[userList objectAtIndex:indexPath.section] objectInListAtIndex:indexPath.row]];
    
    if([changeManagerList isUserInListWithUserId:theUser.userId]){
        [changeManagerList removeUserWithUserId:theUser.userId];
    }else{
        [changeManagerList addUserWithUser:theUser];
    }
    
    if(indexPath.section == MANAGER_SECTION){
        [self.normarUserList addUserWithUser:theUser];
        [self.managerUserList removeUserWithUserId:theUser.userId];
    }else{
        [self.managerUserList addUserWithUser:theUser];
        [self.normarUserList removeUserWithUserId:theUser.userId];
    }
    
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == MANAGER_SECTION){
        UIView *managerSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
        headerImageView.image = [UIImage imageNamed:@"bar_labelWithLine_green_upper"];
        [managerSectionHeaderView addSubview:headerImageView];
        UILabel *headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 120, 15)];
        headerNameLabel.text = @"현재 매니져";
        [headerNameLabel setBackgroundColor:[UIColor clearColor]];
        headerNameLabel.font = UIFontFixedFontWithSize(12);
        headerNameLabel.textColor = UIColorFromRGB(0xffffff);
        headerNameLabel.textAlignment = NSTextAlignmentCenter;
        [managerSectionHeaderView addSubview:headerNameLabel];
        
        return managerSectionHeaderView;
    }else{
        UIView *normalUserSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
        headerImageView.image = [UIImage imageNamed:@"bar_labelWithLine_black_upper"];
        [normalUserSectionHeaderView addSubview:headerImageView];
        UILabel *headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 120, 15)];
        headerNameLabel.text = @"일반 멤버";
        [headerNameLabel setBackgroundColor:[UIColor clearColor]];
        headerNameLabel.font = UIFontFixedFontWithSize(12);
        headerNameLabel.textColor = UIColorFromRGB(0xffffff);
        headerNameLabel.textAlignment = NSTextAlignmentCenter;
        [normalUserSectionHeaderView addSubview:headerNameLabel];
        
        return normalUserSectionHeaderView;
    }
}

#pragma mark - IBAction Methods
- (IBAction)editManagerButtonTapped:(id)sender
{
    if([changeManagerList countOfList]){
        LoadingView *loadingView = [LoadingView startLoading:@"매니져를 변경하고 있습니다" parentView:self.view];
        
        [changeManagerList changeIsManager];
        [newManagerList addUserListWithUserList:[changeManagerList filteredUserListAboutFilteringNumber:YES]];
        [oldManagerList addUserListWithUserList:[changeManagerList filteredUserListAboutFilteringNumber:NO]];
        NSArray *newManagers = [newManagerList allUserIdInList];
        NSArray *oldManagers = [oldManagerList allUserIdInList];
        
        [[GroundClient getInstance] changeManager:self.teamHint.teamId newManagerId:newManagers oldManagerId:oldManagers callback:^(BOOL result, NSDictionary *data){
            if(result){
                [Util showAlertView:nil message:[NSString stringWithFormat:@"변경내용\n새로운매니져%d명\n매니져제외:%d명", [newManagers count], [oldManagers count]]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"error to change manager in edit manager");
                [Util showErrorAlertView:nil message:@"매니져를 변경하지 못했습니다"];
            }
            
            [loadingView stopLoading];
        }];        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
