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
#import "List.h"

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
    
    UIViewController *farLeft = [[UIViewController alloc] initWithNibName:@"FarLeftView" bundle:nil];
    
    farLeft.view.tag = -1;
    
    [self addChildViewController:farLeft];
    [self.scrollNavigation addSubview:farLeft.view];
    [farLeft didMoveToParentViewController:self];
    
    // Generate views based on how many lists we have.
    for (int i = 1; i <= [[User instance].lists count]; i++) {
        
        ListViewController *listView = [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];
        
        [self addChildViewController:listView];
        [self.scrollNavigation addSubview:listView.view];
        [listView didMoveToParentViewController:self];
        
        // Customize the view's properties
        List *list = [[User instance].lists objectAtIndex:i - 1];
        
        listView.listTitle.text = list.listName;
        listView.view.tag = i - 1;
        
        // Spacially places the new view inside of the scrollview
        CGRect listFrame = listView.view.frame;
        listFrame.origin.x = (i) * self.view.frame.size.width;
        listView.view.frame = listFrame;
        
    }
    
//    [self.scrollNavigation setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    
    CGFloat scrollWidth = ([[User instance].lists count] + 1) * self.view.frame.size.width;
    CGFloat scrollHeight = self.view.frame.size.height;
    self.scrollNavigation.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
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
    
    // Drop the keyboard
    [self.view endEditing:NO];
    
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
