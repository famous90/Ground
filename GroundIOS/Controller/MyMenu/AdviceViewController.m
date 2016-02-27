//
//  AdviceViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 28..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define CUSTOMER_CENTER_SECTION 0
#define ADVICE_SECTION          1

#import "AdviceViewController.h"

@interface AdviceViewController ()

@end

@implementation AdviceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowCustomerCenter"]) {
        
    }
    if ([[segue identifier] isEqualToString:@"ShowAdvice"]) {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CUSTOMER_CENTER_SECTION) {
        static NSString *CellIdentifier = @"CustomerCenterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setText:@"고객센터"];
        
        return cell;
        
    }else if (indexPath.section == ADVICE_SECTION){
        static NSString *CellIdentifier = @"FAQCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setText:@"팀은 어떻게 등록하나요?"];
        
        return cell;
        
    }else return nil;

}

@end
