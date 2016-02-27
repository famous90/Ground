//
//  DetailPostAndCommentViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 25..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class Post;
@class Comment;
@class TeamHint;
@class TeamPostDataController;
@class CommentDataController;

@interface DetailPostAndCommentViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

// view
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIImageView *commentWriterImageView;
@property (weak, nonatomic) IBOutlet UITextField *commentContentTextField;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (nonatomic, strong) Post *post;
@property (nonatomic, assign) NSInteger postType;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *writerImage;
@property (nonatomic, strong) Comment *comment;
@property (nonatomic, strong) CommentDataController *commentDataController;

// method
- (IBAction)writeCommentButtonTapped:(id)sender;

@end
