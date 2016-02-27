//
//  PressingReplyViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PressingReplyViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "JoinUser.h"
#import "JoinUserDataController.h"

#import "GroundClient.h"

#import "Util.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation PressingReplyViewController
{
    JoinUserDataController *sendingPressUserDataController;
    NSArray *userDataController;
    NSArray *searchResults;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.noAnswerUserDataController = [[JoinUserDataController alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor, UIFontFixedFontWithSize(12), UITextAttributeFont, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x1B252E)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    sendingPressUserDataController = [[JoinUserDataController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToPressingReply"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [searchResults count];
    }else{
        return [self.noAnswerUserDataController countOfList];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        
        static NSString *CellIdentifier = @"SearchResultMemberCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        JoinUser *theJoinUser = [searchResults objectAtIndex:indexPath.row];

        UILabel *searchResultMemberNameLabel = (UILabel *)[cell viewWithTag:4805];
        UIImageView *searchResultMemberSelectedImageView = (UIImageView *)[cell viewWithTag:4806];
        UIImageView *searchResultMemberUnselectedImageView = (UIImageView *)[cell viewWithTag:4807];
        
        searchResultMemberNameLabel.text = theJoinUser.name;
        if([sendingPressUserDataController isJoinUserInListWithUserId:theJoinUser.userId]){
            searchResultMemberSelectedImageView.hidden = NO;
            searchResultMemberUnselectedImageView.hidden = YES;
        }else{
            searchResultMemberSelectedImageView.hidden = YES;
            searchResultMemberUnselectedImageView.hidden = NO;
        }
        
    }else{
        static NSString *CellIdentifier = @"NotReplyingMemberCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        JoinUser *theJoinUser = [self.noAnswerUserDataController objectInListAtIndex:indexPath.row];
        
        UILabel *notReplyMemberNameLabel = (UILabel *)[cell viewWithTag:4800];
        UIImageView *notReplyMemberSelectedImageView = (UIImageView *)[cell viewWithTag:4801];
        UIImageView *notReplyMemberUnselectedImageView = (UIImageView *)[cell viewWithTag:4802];
        
        notReplyMemberNameLabel.text = theJoinUser.name;
        if([sendingPressUserDataController isJoinUserInListWithUserId:theJoinUser.userId]){
            notReplyMemberSelectedImageView.hidden = NO;
            notReplyMemberUnselectedImageView.hidden = YES;
        }else{
            notReplyMemberSelectedImageView.hidden = YES;
            notReplyMemberUnselectedImageView.hidden = NO;
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JoinUser *theJoinUser;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        theJoinUser = [searchResults objectAtIndex:indexPath.row];
    }else{
        theJoinUser = [self.noAnswerUserDataController objectInListAtIndex:indexPath.row];
    }
    
    if([sendingPressUserDataController isJoinUserInListWithUserId:theJoinUser.userId]){
        [sendingPressUserDataController removeJoinUserWithUserId:theJoinUser.userId];
    }else{
        [sendingPressUserDataController addJoinUserWithJoinUser:theJoinUser];
    }
    [tableView reloadData];
    [self.tableView reloadData];
}

#pragma mark - search Implementation
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchText];
    NSArray *userDataList = [self.noAnswerUserDataController allJoinUserInList];
    searchResults = [[userDataList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
}

#pragma mark - Search Display Delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (IBAction)pressReplyButtonTapped:(id)sender
{
    LoadingView *loadingView = [LoadingView startLoading:@"독촉하고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] pushJoinTargettedSurveyWithMatchId:self.matchId teamId:self.teamHint.teamId pushIds:[sendingPressUserDataController allJoinUserIdInList] callback:^(BOOL result, NSDictionary *data){
        if (result) {
            // Tracking - 참가자조사 독촉
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"survey" action:@"demand" label:[NSString stringWithFormat:@"%d", self.teamHint.teamId] value:0] build]];
            [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@(%d)", self.teamHint.name, self.teamHint.teamId] action:@"survey" label:@"demand" value:0] build]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSLog(@"error to send pressing user in pressing reply");
            [Util showErrorAlertView:nil message:@"독촉하지 못했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}
@end
