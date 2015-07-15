//
//  FirstLaunchViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "FirstLaunchViewController.h"

@interface FirstLaunchViewController ()

@end

@implementation FirstLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)listNew:(id)sender {
    
    UIViewController *shareCode = [self.storyboard instantiateViewControllerWithIdentifier:@"newList"];
    [shareCode setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.navigationController pushViewController:shareCode animated:YES];
    
}

- (IBAction)shareCode:(id)sender {
    
    UIViewController *shareCode = [self.storyboard instantiateViewControllerWithIdentifier:@"shareCode"];
    [shareCode setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.navigationController pushViewController:shareCode animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
