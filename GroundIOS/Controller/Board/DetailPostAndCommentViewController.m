//
//  DetailPostAndCommentViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 25..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define POST            0
#define POST_WITH_IMAGE 1

#define POST_SECTION    0
#define COMMENT_SECTION 1

#define POST_WRITER_ROW     0
#define POST_CONTENT_ROW    1

#define PADDING_COMMENT 9

#import "DetailPostAndCommentViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "Post.h"
#import "Comment.h"
#import "TeamPostDataController.h"
#import "CommentDataController.h"
#import "ImageDataController.h"

#import "GroundClient.h"

#import "Util.h"
#import "NSDate+Utils.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation DetailPostAndCommentViewController{
    ImageDataController *commentWriterImageDataController;
    NSMutableArray *commentTableCellRowHeightArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.post = [[Post alloc] init];
    self.writerImage = [[UIImage alloc] init];
    self.contentImage = [[UIImage alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.commentDataController = [[CommentDataController alloc] init];
    commentWriterImageDataController = [[ImageDataController alloc] init];
    commentTableCellRowHeightArray = [[NSMutableArray alloc] init];
    
    [self getCommentWithThePost];
    [self getUserImage];
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.commentTableView reloadData];
}

- (void)getCommentWithThePost
{
    LoadingView *loadingView = [LoadingView startLoading:@"댓글을 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getCommentListWithTeamId:self.teamHint.teamId withPostId:self.post.postId callback:^(BOOL result, NSDictionary *data){
        if(result){
            NSArray *commentList = [data objectForKey:@"commentList"];
            for( id object in commentList){
                Comment *theComment = [[Comment alloc] initCommentWithData:object];
                [self.commentDataController addNewCommentWithComment:theComment];
                if (![theComment.userImageUrl isEqual:[NSNull null]]) {
                    [self getUserImageWithImageUrl:theComment.userImageUrl withWriterId:theComment.userId];
                }
            }
            [self.commentDataController sortCommentListByDate];
            [self.commentTableView reloadData];
        }else{
            NSLog(@"error load comment in the post");
            [Util showErrorAlertView:nil message:@"댓글을 불러오는데 실패했습니다"];
        }
        
        [loadingView stopLoading];
    }];
}

- (void)getUserImageWithImageUrl:(NSString *)imageUrl withWriterId:(NSInteger)userId
{
    if (![commentWriterImageDataController isIdInListWithId:userId]) {
        [[GroundClient getInstance] downloadProfileImage:imageUrl thumbnail:YES callback:^(BOOL result, NSDictionary *data){
            if (result) {
                UIImage *theImage = [data objectForKey:@"image"];
                [commentWriterImageDataController addObjectWithImage:theImage withId:userId];
                [self.commentTableView reloadData];
            }else {
                NSLog(@"error to download comment writer image in detail post and comments");
            }
        }];
    }
}

- (void)getUserImage
{
    if (self.user.imageUrl) {
        [[GroundClient getInstance] downloadProfileImage:self.user.imageUrl thumbnail:YES callback:^(BOOL result, NSDictionary *data){
            if (result) {
                UIImage *theImage = [data objectForKey:@"image"];
                self.commentWriterImageView.image = theImage;
            }else{
                NSLog(@"error to download user image in detail post and comments");
                self.commentWriterImageView.image = [UIImage imageNamed:@"profile_noImage"];
            }
        }];
    }else{
        self.commentWriterImageView.image = [UIImage imageNamed:@"profile_noImage"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelToShowDetailPost"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.commentDataController countOfList])
        return 2;
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == POST_SECTION)
        return 2;
    else return [self.commentDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == POST_SECTION) {
        
        NSArray *CellIdentifierArray = [[NSArray alloc] initWithObjects:@"PostWriterCell", @"PostCell", nil];
        Post *thePost = self.post;

        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CellIdentifierArray objectAtIndex:indexPath.row]];
        if (cell == Nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.row]];
        }
        
        if (indexPath.row == POST_WRITER_ROW) {
            
            UIImageView *postWriterImageView = (UIImageView *)[cell viewWithTag:3210];
            UILabel *postWriterNameLabel = (UILabel *)[cell viewWithTag:3211];
            UILabel *postDateLabel = (UILabel *)[cell viewWithTag:3212];
            
            postWriterImageView.image = self.writerImage;
            postWriterNameLabel.text = thePost.userName;
            postDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:thePost.createdAt format:13];
            
        }else if (indexPath.row == POST_CONTENT_ROW){
            
            UITextView *postContentTextView = (UITextView *)[cell viewWithTag:3213];
            UIImageView *postContentImageView = (UIImageView *)[cell viewWithTag:3214];
            UIImageView *postBoxBgImageView = (UIImageView *)[cell viewWithTag:3215];
            UIImageView *postBoxBgBottomImageVeiw = (UIImageView *)[cell viewWithTag:3216];
            
            postContentTextView.text = thePost.message;
            
            CGSize postContentTextViewSize = [thePost.message sizeWithFont:UIFontHelveticaWithSize(13) constrainedToSize:CGSizeMake(postContentTextView.frame.size.width - PADDING_COMMENT*1.2, 5000) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect postContentBoxBgImageNewFrame = postBoxBgBottomImageVeiw.frame;
            CGRect postContentBoxBgBottomImageNewFrame = postBoxBgImageView.frame;
            CGRect postContentTextViewNewFrame = postContentTextView.frame;
            
            postContentTextViewNewFrame.origin.y = postContentTextView.frame.origin.y;
            postContentTextViewNewFrame.size = CGSizeMake(postContentTextView.frame.size.width, postContentTextViewSize.height + PADDING_COMMENT*2);
            postContentBoxBgImageNewFrame.size.height = postContentTextViewNewFrame.size.height;
            postContentBoxBgImageNewFrame.origin.y = postBoxBgImageView.frame.origin.y;
            postContentBoxBgBottomImageNewFrame.origin.y = postContentBoxBgImageNewFrame.origin.y + postContentBoxBgImageNewFrame.size.height;
            postContentBoxBgBottomImageNewFrame.size = CGSizeMake(postContentBoxBgImageNewFrame.size.width, postBoxBgBottomImageVeiw.frame.size.height);
            
            if(self.postType == POST_WITH_IMAGE){
                float contentImageScalingRatio = postContentImageView.frame.size.width / self.contentImage.size.width;
                CGFloat contentImageViewHeight = self.contentImage.size.height * contentImageScalingRatio;
                
                CGRect postImageViewNewFrame = postContentImageView.frame;
                postImageViewNewFrame.size = CGSizeMake(postContentImageView.frame.size.width, contentImageViewHeight);
                
                postImageViewNewFrame.origin.y = PADDING_COMMENT;
                postContentTextViewNewFrame.origin.y = postImageViewNewFrame.origin.y + postImageViewNewFrame.size.height;
                postContentBoxBgImageNewFrame.size.height = postContentTextViewNewFrame.origin.y + postContentTextViewNewFrame.size.height;
                postContentBoxBgBottomImageNewFrame.origin.y = postContentBoxBgImageNewFrame.origin.y + postContentBoxBgImageNewFrame.size.height;
                postContentImageView.frame = postImageViewNewFrame;
                
                postContentImageView.image = self.contentImage;
            }
            postBoxBgBottomImageVeiw.frame = postContentBoxBgBottomImageNewFrame;
            postBoxBgImageView.frame = postContentBoxBgImageNewFrame;
            postContentTextView.frame = postContentTextViewNewFrame;
            
        }
        return cell;
    }
    else{
        
        static NSString *CellIdentifier = @"PostCommentCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == Nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Comment *theComment = [self.commentDataController objectInListAtIndex:indexPath.row];
        UIImageView *commentWriterImageView = (UIImageView *)[cell viewWithTag:3200];
        UILabel *commentWriterNameLabel = (UILabel *)[cell viewWithTag:3201];
        UITextView *commentContentTextView = (UITextView *)[cell viewWithTag:3202];
        UILabel *commentDateLabel = (UILabel *)[cell viewWithTag:3203];
        UIImageView *commentBgImageView = (UIImageView *)[cell viewWithTag:3204];
        
        CGSize nameLabelSize = [theComment.userName sizeWithFont:UIFontHelveticaWithSize(12)];
        CGRect nameLabelNewFrame = commentWriterNameLabel.frame;
        nameLabelNewFrame.size.width = nameLabelSize.width;
        commentWriterNameLabel.frame = nameLabelNewFrame;
        
        CGRect dateLabelNewFrame = commentDateLabel.frame;
        dateLabelNewFrame.origin.x = nameLabelNewFrame.origin.x + nameLabelNewFrame.size.width;
        commentDateLabel.frame = dateLabelNewFrame;

        commentContentTextView.text = theComment.message;
        CGRect contentTextViewNewFrame = commentContentTextView.frame;
        CGSize contentTextViewSize = [theComment.message sizeWithFont:UIFontHelveticaWithSize(12) constrainedToSize:CGSizeMake(230, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        contentTextViewNewFrame.origin.y = commentContentTextView.frame.origin.y;
        contentTextViewNewFrame.size.height = contentTextViewSize.height + PADDING_COMMENT*2;
        commentContentTextView.frame = contentTextViewNewFrame;
        
        CGRect bgImageViewNewFrame = commentBgImageView.frame;
        bgImageViewNewFrame.size.height = contentTextViewNewFrame.origin.y + contentTextViewNewFrame.size.height;
        commentBgImageView.frame = bgImageViewNewFrame;
        
        if ([commentWriterImageDataController isIdInListWithId:theComment.userId]) {
            commentWriterImageView.image = [commentWriterImageDataController imageWithId:theComment.userId];
        }else{
            commentWriterImageView.image = [UIImage imageNamed:@"profile_noImage"];
        }
        commentWriterNameLabel.text = theComment.userName;
        commentDateLabel.text = [NSDate GeneralFormatDateFromNSTimeInterval:theComment.createdAt format:13];
        
        return cell;
        
    }
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.commentContentTextField resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == POST_SECTION) {
        
        if (indexPath.row == POST_WRITER_ROW) {
            
            return 56;
            
        }else if(indexPath.row == POST_CONTENT_ROW){
            
            NSString *text = self.post.message;
            CGSize constraint = CGSizeMake(284 - PADDING_COMMENT*1.2, 5000);
            CGSize size = [text sizeWithFont:UIFontHelveticaWithSize(13) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat textViewheight = size.height + PADDING_COMMENT*2;
            CGFloat height = textViewheight + 16;
            
            if (self.postType == POST) {
                return height;
            }else{
                float contentImageScalingRatio = 284 / self.contentImage.size.width;
                CGFloat contentImageViewHeight = self.contentImage.size.height * contentImageScalingRatio;
                return contentImageViewHeight + height + PADDING_COMMENT;
            }
        }
        return 0;
        
    }else{
        
        NSString *text = [self.commentDataController objectInListAtIndex:indexPath.row].message;
        CGSize constraint = CGSizeMake(230, 1000);
        CGSize size = [text sizeWithFont:UIFontHelveticaWithSize(12) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat textViewheight = size.height + PADDING_COMMENT*2;
        CGFloat height = textViewheight + 23;
        return height;
    }
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.commentContentTextField){
        [self.commentContentTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - IBAction Methods
- (IBAction)writeCommentButtonTapped:(id)sender
{
    if(self.commentContentTextField.text){
        LoadingView *loadingView = [LoadingView startLoading:@"댓글을 등록하고 있습니다" parentView:self.view];

        [[GroundClient getInstance] addCommentWithTeam:self.teamHint.teamId withPost:self.post.postId comment:self.commentContentTextField.text callback:^(BOOL result, NSDictionary *data){
            if(result){
                [self getCommentWithThePost];
                self.commentContentTextField.text = nil;
                [self.commentContentTextField resignFirstResponder];
//                [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.commentDataController countOfList]-1 inSection:COMMENT_SECTION] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }else{
                NSLog(@"error to write comment in detail post and comment");
                [Util showErrorAlertView:nil message:@"댓글을 등록하는데 실패했습니다"];
            }
            
            [loadingView stopLoading];
        }];
    }
}
@end
