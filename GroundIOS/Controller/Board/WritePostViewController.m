//
//  WritePostViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 25..
//  Copyright (c) 2013년 AnB. All rights reserved.
//
#define POST            0

#import "WritePostViewController.h"
#import "LoadingView.h"

#import "Post.h"
#import "User.h"
#import "TeamHint.h"

#import "GroundClient.h"

#import "Util.h"

@implementation WritePostViewController{
    BOOL postWithImage;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.post = [[Post alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor, UIFontFixedFontWithSize(12), UITextAttributeFont, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x1B252E)];

}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setScreenName:NSStringFromClass([self class])];
    
    self.post.teamId = self.teamHint.teamId;
    self.post.userId = self.user.userId;
    self.post.userName = self.user.name;
    self.post.userImageUrl = self.user.imageUrl;
    self.post.type = POST;
}

- (void)viewDidLoad
{
    postWithImage = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"CancelNewPost"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 
#pragma mark - IBAction Methods
- (IBAction)backgroundTapped:(id)sender
{
    [self.postTextView resignFirstResponder];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [Util showAlertView:nil message:@"기기에 카메라가 없습니다\n확인하고 실행해 주시기 바랍니다"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)albumButtonTapped:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)postTextViewTapped:(UITapGestureRecognizer *)sender
{
    self.postTextViewMessageLabel.hidden = YES;
    [self.postTextView becomeFirstResponder];
}

- (IBAction)writePostDoneButtonPressed:(id)sender
{
    self.post.message = self.postTextView.text;
    
    LoadingView *loadingView = [LoadingView startLoading:@"게시물을 등록하고 있습니다" parentView:self.view];
    
    if(postWithImage){
        
        [[GroundClient getInstance] uploadProfileImage:self.postImageView.image thumbnail:FALSE multipartCallback:^(BOOL result, NSDictionary *data){
            self.post.postImageUrl = [data objectForKey:@"path"];
            if(result){
                [[GroundClient getInstance] wrtiePost:self.post callback:^(BOOL result, NSDictionary *data){
                    if(result){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        NSLog(@"error uploading post in writing post");
                        [Util showErrorAlertView:nil message:@"글쓰기에 실패했습니다"];
                    }
                }];
            }else{
                NSLog(@"error uploading post image in writing post");
                [Util showErrorAlertView:nil message:@"사진 전송에 실패했습니다"];
            }
            
            [loadingView stopLoading];
        }];
    }else{
        
        [[GroundClient getInstance] wrtiePost:self.post callback:^(BOOL result, NSDictionary *data){
            if(result){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSLog(@"error uploading post in writing post");
                [Util showErrorAlertView:nil message:@"글쓰기에 실패했습니다"];
            }
            
            [loadingView stopLoading];
        }];
    }
}

#pragma mark - Image Picker Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.postImageView.image = selectedImage;
    postWithImage = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.1];
    
    CGRect newFrame = self.postTextView.frame;
    newFrame.origin.y = self.postImageView.frame.origin.y + self.postImageView.frame.size.height + 8;
    self.postTextView.frame = newFrame;
    
    [UIView commitAnimations];
    [self.postTextView becomeFirstResponder];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Implementation Methods
- (void)keyboardWillShow:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:.1];
    [UIView setAnimationCurve:animationCurve];
    
    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect frame = self.postTextView.frame;
        frame.size.height = keyboardTop - self.postTextView.frame.origin.y - 2;
        self.postTextView.frame = frame;
        self.postTextBackgroundImageView.frame = frame;
    } else {
        // Keyboard is going away (down) - restore original frame
        CGRect frame = self.postTextView.frame;
        frame.size.height = self.view.frame.size.height - self.postTextView.frame.origin.y;
        self.postTextView.frame = frame;
        self.postTextBackgroundImageView.frame = frame;
    }
    
    [UIView commitAnimations];
}
@end
