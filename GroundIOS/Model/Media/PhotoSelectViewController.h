//
//  PhotoSelectViewController.h
//  GroundIOS_JET
//
//  Created by Jet on 13. 7. 25..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

//@class PhotoSelectViewController;

@protocol PhotoSelectViewDelegate
- (void)setImage:(UIImage*)imageFromPicker;
@end

@interface PhotoSelectViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)pickPhotoFromSource:(UIImagePickerControllerSourceType)sourceType;

@end
