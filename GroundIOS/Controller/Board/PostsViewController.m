//
//  PostsViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define POST            0
#define POST_WITH_IMAGE 1
#define POST_WITH_FEED  2

#define TEAM_FEED       1

#define ACCEPT_MEMBER       1
#define LEAVE_TEAM          4
#define MATCHING_COMPLETE   7
#define SCORE_COMPLETE      12

#define REGISTER    0
#define REQUESTED   1
#define COMPLETE    2

#define TEAM_TAB_TEAMMAIN   3

#define PADDING 9
#define HEIGHT_OF_TEXT_POST         102
#define HEIGHT_OF_POST_WITH_IMAGE   302
#define HEIGHT_OF_TEAM_FEED         59
#define HEIGHT_OF_NO_POST           150

#import "PostsViewController.h"
#import "WritePostViewController.h"
#import "DetailPostAndCommentViewController.h"
#import "DetailMatchViewController.h"
#import "MatchResultViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "Post.h"
#import "TeamHint.h"
#import "TeamPostDataController.h"
#import "ImageDataController.h"
#import "Match.h"

#import "GroundClient.h"

#import "Util.h"
#import "StringUtils.h"
#import "NSDate+Utils.h"
#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

static BOOL isMenuOn;

@implementation PostsViewController{
    NSMutableDictionary *heightCache;
    BOOL isLastPost;
    
    UITapGestureRecognizer *singleFingerTap;

//    LoadingView *loadingView;
//    UIView *noDataView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self doMenuSlideBack];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
//    [self setTableViewBackGroundForNoData];
    
    self.bottomPostId = 0;
    isLastPost = NO;
    self.postDataController = [[TeamPostDataController alloc] init];
    self.postImageDataController = [[ImageDataController alloc] init];
    self.userImageDataController = [[ImageDataController alloc] init];
    heightCache = [[NSMutableDictionary alloc] init];

    [self getTeamPost];
}

- (void)getTeamPost
{
    LoadingView *loadingView = [LoadingView startLoading:@"게시물을 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getPostList:self.teamHint.teamId lastPostId:self.bottomPostId callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *thePostArray = [data objectForKey:@"postList"];
            for(id object in thePostArray){
                Post *thePost = [[Post alloc] initPostWithData:object];
                if([thePost isPostImageInPost]){
                    [self getPostImageWithImageUrl:thePost.postImageUrl postId:thePost.postId];
                }
                [self.postDataController addNewPostWithPost:thePost];
                if(![self.userImageDataController isIdInListWithId:thePost.userId]){
                    if([thePost.userImageUrl isEqual:[NSNull null]]){
                        [self.userImageDataController addObjectWithImage:[UIImage imageNamed:@"profile_noImage"] withId:thePost.userId];
                    }else{
                        [self getUserImageWithImageUrl:thePost.userImageUrl userId:thePost.userId];
                    }
                }
            }
            [self.postDataController sortDecendingPostwithPostId];
            if (self.bottomPostId == [self.postDataController getBottomPostId]) {
                isLastPost = YES;
            }else{
                self.bottomPostId = [self.postDataController getBottomPostId];
            }
            [self.teamBoardTableView reloadData];
            
        }else{
            NSLog(@"error to load my team post in team board main");
//            [Util showErrorAlertView:nil message:@"팀 게시물을 불러오는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)getPostImageWithImageUrl:(NSString *)imageUrl postId:(NSInteger)postId
{
    [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:FALSE callback:^(BOOL result, NSDictionary *data){
        if(result) {
            UIImage *postImage = [data objectForKey:@"image"];
            [self.postImageDataController addObjectWithImage:postImage withId:postId];
            [self.teamBoardTableView reloadData];
        }else{
            NSLog(@"Error to load post image in board main");
//            [Util showErrorAlertView:nil message:@"글의 사진을 불러오는데 실패했습니다"];
        }
    }];
}

- (void)getUserImageWithImageUrl:(NSString *)imageUrl userId:(NSInteger)userId
{
    [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:TRUE callback:^(BOOL result, NSDictionary *data){
        if(result){
            UIImage *userImage = [data objectForKey:@"image"];
            [self.userImageDataController addObjectWithImage:userImage withId:userId];
            [self.teamBoardTableView reloadData];
        }else{
            NSLog(@"Error to load writer image in board main");
//            [Util showErrorAlertView:nil message:@"글쓴이의 사진을 불러오는데 실패했습니다"];
        }
    }];
}

//- (void)setTableViewBackGroundForNoData
//{
//    noDataView = [[UIView alloc] init];
//    [noDataView setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
//    [noDataLabel setFont:UIFontHelveticaBoldWithSize(15)];
//    [noDataLabel setTextColor:UIColorFromRGB(0xd6d6d6)];
//    [noDataLabel setNumberOfLines:1];
//    [noDataLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [noDataLabel setShadowColor:[UIColor lightTextColor]];
//    [noDataLabel setBackgroundColor:[UIColor clearColor]];
//    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
//    [noDataLabel setText:@"등록된 게시물이 없습니다"];
//    
//    [noDataView setHidden:YES];
//    [noDataView addSubview:noDataLabel];
//    [self.tableView insertSubview:noDataView belowSubview:self.tableView];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"writeNewPost"]){
        WritePostViewController *childViewController = (WritePostViewController *)[segue destinationViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        
        childViewController.hidesBottomBarWhenPushed = YES;
    }
    if(([[segue identifier] isEqualToString:@"ShowPostDetail"] || [[segue identifier] isEqualToString:@"ShowPostDetailWithImage"])){
        DetailPostAndCommentViewController *childViewController = (DetailPostAndCommentViewController *)[segue destinationViewController];
        Post *thePost = [self.postDataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        childViewController.post = thePost;
        childViewController.writerImage = [self.userImageDataController imageWithId:thePost.userId];
        if(![[StringUtils getInstance] IsStringNull:thePost.userImageUrl]){
            childViewController.writerImage = [self.userImageDataController imageWithId:thePost.userId];
        }
        if([[segue identifier] isEqualToString:@"ShowPostDetailWithImage"]){
            childViewController.contentImage = [self.postImageDataController imageWithId:thePost.postId];
            childViewController.postType = POST_WITH_IMAGE;
        }else{
            childViewController.postType = POST;
        }
        childViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - 
#pragma mark - Menu slide implementation methods
- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    [self doMenuSlideBack];
}

- (void)doMenuSlide
{
    isMenuOn = [_teamTabbarParentViewController slide];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.coverView = [[UIView alloc] initWithFrame:screenRect];
    [self.coverView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.coverView addGestureRecognizer:singleFingerTap];
    [self.view addSubview:self.coverView];
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    [self.tableView setScrollEnabled:NO];
}

- (void)doMenuSlideBack
{
    isMenuOn = [_teamTabbarParentViewController slideBack];
    [singleFingerTap removeTarget:self action:@selector(handleSingleTap:)];
    [self.coverView removeFromSuperview];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.tableView setScrollEnabled:YES];
}


#pragma mark - IBAction Methods
- (IBAction)slide:(id)sender
{
    if(!isMenuOn){
        [self doMenuSlide];
    }else{
        [self doMenuSlideBack];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
}

#pragma mark -
#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([self.postDataController countOfList]) {
//        [noDataView setHidden:YES];
//    }else [noDataView setHidden:NO];
    
    if ([self.postDataController countOfList]) {
        return [self.postDataController countOfList];
    }else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.postDataController countOfList]) {
        Post *postAtIndex = [self.postDataController objectInListAtIndex:indexPath.row];
        
        if (postAtIndex.type == POST) {
            
            NSArray *CellIdentifier = [[NSArray alloc] initWithObjects:@"TeamPostsCell", @"TeamPostsCellWithImage",nil];
            NSInteger cellType;
            if([postAtIndex isPostImageInPost]){
                cellType = POST_WITH_IMAGE;
            }else{
                cellType = POST;
            }
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CellIdentifier objectAtIndex:cellType]];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CellIdentifier objectAtIndex:cellType]];
            }
            
            UIImageView *postWriterImageView = (UIImageView *)[cell viewWithTag:300+cellType*10];
            UILabel *postWriterNameLabel = (UILabel *)[cell viewWithTag:301+cellType*10];
            UILabel *postDateLabel = (UILabel *)[cell viewWithTag:302+cellType*10];
            UILabel *postContentLabel = (UILabel *)[cell viewWithTag:303+cellType*10];
            [postContentLabel setLineBreakMode:NSLineBreakByWordWrapping];
            UILabel *postCommentCountLabel = (UILabel *)[cell viewWithTag:304+cellType*10];
            UIImageView *postBgImageView = (UIImageView  *)[cell viewWithTag:306+cellType*10];
            
            postWriterImageView.image = [self.userImageDataController imageWithId:postAtIndex.userId];
            postWriterNameLabel.text = postAtIndex.userName;
            postDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:postAtIndex.createdAt format:13];
            postContentLabel.text = postAtIndex.message;
            postCommentCountLabel.text = [NSString stringWithFormat:@"%d", postAtIndex.commentCount];
            
            if(cellType == POST_WITH_IMAGE){
                
                UIImage *theImage = [self.postImageDataController imageWithId:postAtIndex.postId];
                if (theImage) {
                    
                    UIImageView *postContentImageView = (UIImageView *)[cell viewWithTag:315];
                    float contentImageRatio = theImage.size.width / theImage.size.height;
                    float imageViewRatio = postContentImageView.frame.size.width / postContentImageView.frame.size.height;
                    
                    postContentImageView.image = theImage;
                    if (contentImageRatio > imageViewRatio) {
                        
                        /* WIDE PICTURE HANDLING LIKE FACEBOOK */
                        //                    CGRect postContentImageViewNewFrame = postContentImageView.frame;
                        //                    postContentImageViewNewFrame.origin.x = 0;
                        //                    postContentImageViewNewFrame.size = CGSizeMake(self.view.frame.size.width, postContentImageView.frame.size.height);
                        //                    postContentImageView.frame = postContentImageViewNewFrame;
                        
                        [postContentImageView setContentMode:UIViewContentModeScaleAspectFill];
                        [postContentImageView setClipsToBounds:YES];
                    }else{
                        [postContentImageView setContentMode:UIViewContentModeScaleAspectFit];
                    }
                }
            }
            
            CALayer *layer = postBgImageView.layer;
            layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
            layer.shadowColor = [[UIColor blackColor] CGColor];
            layer.shadowRadius = 2.0f;
            layer.shadowOpacity = 0.3f;
            layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
            
            return cell;
            
        }else if(postAtIndex.type == TEAM_FEED){
            
            static NSString *CellIdentifier = @"TeamFeedCell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UIImageView *teamFeedIconImageView = (UIImageView *)[cell viewWithTag:320];
            UILabel *teamFeedDateLabel = (UILabel *)[cell viewWithTag:321];
            UILabel *teamFeedContentLabel = (UILabel *)[cell viewWithTag:322];
            UIImageView *teamFeedBgImageView = (UIImageView *)[cell viewWithTag:323];
            
            NSArray *feedIconImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"postBox_registered_icon"], [UIImage imageNamed:@"postBox_alarm_icon"], [UIImage imageNamed:@"postBox_complete_icon"], nil];
            
            NSString *feedContent = nil;
            NSInteger feedIconNumber = 0;
            switch (postAtIndex.teamFeedType) {
                case ACCEPT_MEMBER:{
                    feedContent = [NSString stringWithFormat:@"%@ 님이 팀의 일원이 되었습니다", postAtIndex.userName];
                    feedIconNumber = REGISTER;
                    break;
                }
                case LEAVE_TEAM:{
                    feedContent = [NSString stringWithFormat:@"%@ 님이 팀을 떠났습니다", postAtIndex.userName];
                    feedIconNumber = COMPLETE;
                    break;
                }
                case MATCHING_COMPLETE:{
                    feedContent = [NSString stringWithFormat:@"경기가 등록되었습니다"];
                    feedIconNumber = COMPLETE;
                    break;
                }
                case SCORE_COMPLETE:{
                    feedContent = [NSString stringWithFormat:@"경기 결과가 등록되었습니다"];
                    feedIconNumber = COMPLETE;
                    break;
                }
                default:
                    NSLog(@"feed type error in team feed of post list");
                    break;
            }
            CALayer *layer = teamFeedBgImageView.layer;
            layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
            layer.shadowColor = [[UIColor blackColor] CGColor];
            layer.shadowRadius = 2.0f;
            layer.shadowOpacity = 0.3f;
            layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
            
            teamFeedIconImageView.image = [feedIconImageArray objectAtIndex:feedIconNumber];
            teamFeedDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:postAtIndex.createdAt format:13];
            teamFeedContentLabel.text = feedContent;
            
            return cell;
            
        }else{
            return nil;
        }
    
    }else{
        static NSString *CellIdentifier = @"noPostCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((isLastPost == NO) && (indexPath.row == [self.postDataController countOfList] - 1)) {
        [self getTeamPost];
    }
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.postDataController countOfList]) {
        Post *postAtIndex = [self.postDataController objectInListAtIndex:indexPath.row];
        if (postAtIndex.type == TEAM_FEED) {
            return HEIGHT_OF_TEAM_FEED;
        }
        if([postAtIndex isPostImageInPost]){
            return HEIGHT_OF_POST_WITH_IMAGE;
        }
        return HEIGHT_OF_TEXT_POST;
        
    }else{
        return HEIGHT_OF_NO_POST;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Post *thePost = [self.postDataController objectInListAtIndex:indexPath.row];
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    
    if ((thePost.teamFeedType == ACCEPT_MEMBER)||(thePost.teamFeedType == LEAVE_TEAM)) {
    
        [self.tabBarController setSelectedIndex:TEAM_TAB_TEAMMAIN];
        
    }else if (thePost.teamFeedType == MATCHING_COMPLETE){
    
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
        DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        [childViewController.match setMatchId:thePost.matchId];
        [self presentViewController:navController animated:YES completion:Nil];
        
    }else if (thePost.teamFeedType == SCORE_COMPLETE){
        
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MatchResultNavigationViewController"];
        MatchResultViewController *childViewController = (MatchResultViewController *)[navController topViewController];
        childViewController.user = self.user;
        childViewController.teamHint = self.teamHint;
        [childViewController.match setMatchId:thePost.matchId];
        [self presentViewController:navController animated:YES completion:nil];
        
    }
}
@end
