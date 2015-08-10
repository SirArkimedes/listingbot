//
//  ShareListViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/10/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ShareListViewController.h"

@interface ShareListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation ShareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shareButton.layer.cornerRadius = 5.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)sharePress:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareButton.titleLabel.text;
    
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
