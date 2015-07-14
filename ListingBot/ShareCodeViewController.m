//
//  ShareCodeViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ShareCodeViewController.h"

@interface ShareCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *shareCodeTextField;

@end

@implementation ShareCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shareCodeTextField.layer.borderWidth = 1.0f;
    self.shareCodeTextField.layer.cornerRadius = 5.0f;
    self.shareCodeTextField.layer.borderColor = [[UIColor redColor] CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
