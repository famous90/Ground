//
//  PhotoSelectViewController.m
//  GroundIOS_JET
//
//  Created by Jet on 13. 7. 25..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "PhotoSelectViewController.h"
#import "ImageUtils.h"

@implementation PhotoSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickPhotoFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0){
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        [picker setVideoQuality:3];
        [picker setWantsFullScreenLayout:YES];

        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:NO completion:NULL];
    }else{
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error accessing media" message:@"Device doesn't support that media source." delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles: nil];
        
        [alert show];
    }
}

#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     if([info[UIImagePickerControllerMediaType] isEqual:(NSString*)kUTTypeImage]){
         
         UIImage* chosenImage = info[UIImagePickerControllerEditedImage];
         
//         NSLog(@"chose Image size width = %f, size height = %f", chosenImage.size.width, chosenImage.size.height);
//         if(chosenImage.size.width != 640 || chosenImage.size.height != 1136){
//             
//             NSLog(@"chose Image size width = %f, size height = %f", chosenImage.size.width, chosenImage.size.height);
//             chosenImage = [ImageUtils scaleImageToUpload:chosenImage];
//             NSLog(@"compressed Image size width = %f, size height = %f", chosenImage.size.width, chosenImage.size.height);
//         }

         [((id<PhotoSelectViewDelegate>)self.parentViewController) setImage:chosenImage];
     }
     
     [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
