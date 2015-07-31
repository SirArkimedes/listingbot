//
//  ScrollNavigationViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ScrollNavigationViewController.h"

#import "ListViewController.h"

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
    
    [self addChildViewController:listView];
    [self.scrollNavigation addSubview:listView.view];
    [listView didMoveToParentViewController:self];
    
    CGFloat scrollWidth = 2 * self.view.frame.size.width;
    CGFloat scrollHeight = self.view.frame.size.height;
    self.scrollNavigation.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
//    var scrollWidth: CGFloat  = 3 * self.view.frame.width
//    var scrollHeight: CGFloat  = self.view.frame.size.height
//    self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
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
