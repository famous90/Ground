//
//  WritePostViewController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 25..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class User;
@class TeamHint;
@class Post;

@interface WritePostViewController : GAITrackedViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// view
@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIImageView *postTextBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *postTextViewMessageLabel;

// data
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) TeamHint *teamHint;
@property (strong, nonatomic) Post *post;

// method
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)albumButtonTapped:(id)sender;
- (IBAction)postTextViewTapped:(UITapGestureRecognizer *)sender;
- (IBAction)writePostDoneButtonPressed:(id)sender;
@end
