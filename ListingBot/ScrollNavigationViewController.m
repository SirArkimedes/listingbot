//
//  ScrollNavigationViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ScrollNavigationViewController.h"

#import <Parse/Parse.h>
#import "ListViewController.h"

#import "User.h"

typedef enum ScrollDirection {
    ScrollDirectionRight,
    ScrollDirectionLeft
} ScrollDirection;

@interface ScrollNavigationViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollNavigation;

@property (strong, nonatomic) UILabel *testing;

@end


@implementation ScrollNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollNavigation.delegate = self;
    
    ListViewController *listView = [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    
    [self addChildViewController:listView];
    [self.scrollNavigation addSubview:listView.view];
    [listView didMoveToParentViewController:self];
    
    listView.listTitle.text = @"Testing";
    self.testing = listView.listTitle;
    
    ListViewController *newView = [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    newView.view.backgroundColor = [UIColor orangeColor];
    
    [self addChildViewController:newView];
    [self.scrollNavigation addSubview:newView.view];
    [newView didMoveToParentViewController:self];
    
    CGRect listFrame = listView.view.frame;
    listFrame.origin.x = self.view.frame.size.width;
    newView.view.frame = listFrame;
    
    CGFloat scrollWidth = 2 * self.view.frame.size.width;
    CGFloat scrollHeight = self.view.frame.size.height;
    self.scrollNavigation.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
    // Test data testing
    NSLog(@"%@", [User instance].userName);
    NSLog(@"%@", [User instance].userUuid);
    NSLog(@"%@", [User instance].lists);
    
    // Saves and retrieves data from Parse
//    NSData *dataFromSet = [NSKeyedArchiver archivedDataWithRootObject:[User instance]];
//    PFObject *object = [PFObject objectWithClassName:@"Users"];
//    object[@"user"] = dataFromSet;
//    [object saveEventually];
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
////    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
////            NSLog(@"Successfully retrieved %d scores.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                User *unarchivedSet = [NSKeyedUnarchiver unarchiveObjectWithData:object[@"user"]];
//                NSLog(@"Here's the set: %@", unarchivedSet);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scrollview Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x;
    [self animationForScroll:offset withDirection:ScrollDirectionRight];
    
}

- (void)animationForScroll:(CGFloat)offset withDirection:(int)direction {
    
    // Direction can also be used here.
    
    CATransform3D labelTransform = CATransform3DTranslate(CATransform3DIdentity, 1.25*offset, 0, 0);
    self.testing.layer.transform = labelTransform;
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
