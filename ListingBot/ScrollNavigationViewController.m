//
//  ScrollNavigationViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ScrollNavigationViewController.h"

#import "ListViewController.h"

#import "User.h"

@interface ScrollNavigationViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollNavigation;

@end

@implementation ScrollNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ListViewController *listView = [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    
    [self addChildViewController:listView];
    [self.scrollNavigation addSubview:listView.view];
    [listView didMoveToParentViewController:self];
    
    ListViewController *newView = [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    newView.view.backgroundColor = [UIColor orangeColor];
    
    [self addChildViewController:newView];
    [self.scrollNavigation addSubview:newView.view];
    [newView didMoveToParentViewController:self];
    
    CGRect listFrame = listView.view.frame;
    listFrame.origin.x = self.view.frame.size.width;
    newView.view.frame = listFrame;
    
//    var adminFrame :CGRect = AVc.view.frame;
//    adminFrame.origin.x = adminFrame.width;
//    BVc.view.frame = adminFrame;
    
    CGFloat scrollWidth = 2 * self.view.frame.size.width;
    CGFloat scrollHeight = self.view.frame.size.height;
    self.scrollNavigation.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
    NSLog(@"%@", [User instance].userName);
    NSLog(@"%@", [User instance].userUuid);
    NSLog(@"%@", [User instance].lists);
    
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
