//
//  FirstLaunchViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "FirstLaunchViewController.h"

#define kAnimation .5f

@interface FirstLaunchViewController ()

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *infoDot;

@end

@implementation FirstLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.popUpView.layer.cornerRadius = 10.f;
    self.popUpView.layer.masksToBounds = YES;
    
    self.infoView.layer.cornerRadius = 45.f;
    self.infoView.layer.masksToBounds = YES;
    self.infoView.layer.borderWidth = 5.f;
    self.infoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.infoDot.layer.cornerRadius = 5.f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)listNew:(id)sender {
    
    UIViewController *newList = [self.storyboard instantiateViewControllerWithIdentifier:@"newList"];
    [newList setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:newList animated:YES completion:nil];
    
}

- (IBAction)shareCode:(id)sender {
    
    UIViewController *shareCode = [self.storyboard instantiateViewControllerWithIdentifier:@"shareCode"];
    [shareCode setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:shareCode animated:YES completion:nil];
    
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
