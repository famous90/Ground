//
//  PopUpView.m
//  GroundIOS
//
//  Created by Z's iMac on 13. 9. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "PopUpView.h"
#import "Ground.h"
#import "GroundClient.h"
#import "Util.h"

@implementation PopUpView

+ (PopUpView *)popUp:(NSString *)message parentView:(UIView *)parentView
{
    PopUpView *popUpView = [[[UINib nibWithNibName:@"PopUpView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    popUpView.popUpMessage.text = message;
    popUpView.frame = parentView.frame;
    
    popUpView.displayView.center = popUpView.center;
    [popUpView.displayView.layer setCornerRadius:10];
    popUpView.displayView.userInteractionEnabled = YES;

    [parentView addSubview:popUpView];
    
    return popUpView;
}

- (IBAction)doRegisterGround:(id)sender
{
    [self.ground setName:self.groundName.text];
    
    [[GroundClient getInstance] registerGround:self.ground callback:^(BOOL result, NSDictionary *data) {
        
        if(result){
            
            [self receivedRegisterGroundResponse:data];
        }else{
            
            NSInteger code = [[data valueForKey:@"code"] integerValue];
            NSLog(@"code = %d", code);
        }
    }];
    
    [[((MTMapView*)self.superview).poiItems objectAtIndex:0] setItemName:self.groundName.text];
    [((MTMapView*)self.superview) selectPOIItem:[((MTMapView*)self.superview).poiItems objectAtIndex:0] animated:YES];
}

- (IBAction)cancel:(id)sender
{
    [((MTMapView*)self.superview) selectPOIItem:[((MTMapView*)self.superview).poiItems objectAtIndex:0] animated:YES];
    
    [self removeFromSuperview];
}

- (void)receivedRegisterGroundResponse:(NSDictionary*)data
{
    [[((MTMapView*)self.superview).poiItems objectAtIndex:0] setTag:[[data valueForKey:@"groundId"] integerValue]];
    
    [self removeFromSuperview];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTab:(id)sender
{
    [self.groundName resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
