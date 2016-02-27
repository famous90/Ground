//
//  FindLoginInfoViewController.m
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FindLoginInfoViewController.h"

@interface FindLoginInfoViewController ()

@end

@implementation FindLoginInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)findPswdButtonPressed:(UIButton *)sender {
    
    // code to request for the server to send the temporarily pswd

}
@end
