//
//  PopUpViewController.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 10. 21..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PopUpViewController.h"
#import "MapViewController.h"

@implementation PopUpViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.popUpTextStr = [[NSString alloc] init];
}

- (void)viewDidLayoutSubviews
{
    CGSize labelSize = [self.popUpTextStr sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 400) lineBreakMode:NSLineBreakByWordWrapping];
    
//    CGSize labelSize = [self.popUpTextStr sizeWithFont:UIFontFixedFontWithSize(12)];
    CGRect labelFrame = CGRectMake((self.view.frame.size.width - labelSize.width)/2, self.popUpMessage.frame.origin.y, labelSize.width, labelSize.height+10);
    self.popUpMessage.frame = labelFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popUpMessage.font = UIFontFixedFontWithSize(13);
    [self setPopUpText:self.popUpTextStr];
}

- (IBAction)doRegisterGround:(id)sender
{
    [_mapViewController doRegisterGround:self.groundName.text];
}

- (IBAction)cancel:(id)sender
{
    self.groundName.text = NULL;
    _mapViewController.mapView.opaque = YES;
    _mapViewController.mapView.alpha = 1.0;
    _mapViewController.mapView.backgroundColor = [UIColor whiteColor];
    [_mapViewController.mapView setUserInteractionEnabled:YES];
    [_mapViewController.view sendSubviewToBack:_mapViewController.popUpView];
}

- (IBAction)backgroundTab:(id)sender
{
    [self.groundName resignFirstResponder];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)setPopUpText:(NSString*)str
{
    self.popUpMessage.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
