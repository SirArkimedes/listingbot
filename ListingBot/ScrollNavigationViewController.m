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
#import "FarLeftViewController.h"

#import "NewListViewController.h"
#import "NotesView.h"

#import "User.h"
#import "List.h"

#import "Settings.h"

#define kAnimation .5f

typedef enum ScrollDirection {
    ScrollDirectionRight,
    ScrollDirectionLeft
} ScrollDirection;

@interface ScrollNavigationViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollNavigation;

@property (weak, nonatomic) IBOutlet UIButton *listNewButton;

@property (strong, nonatomic) UILabel *testing;

@end


@implementation ScrollNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Customize button
    self.listNewButton.layer.cornerRadius = 25.f;
    
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.listNewButton addGestureRecognizer:pangr];
    
    // Set scrollview delegate
    self.scrollNavigation.delegate = self;
    
    // Hide or unhide button based on setting
    if ([Settings instance].doesWantDraggable) {
        self.listNewButton.layer.opacity = 1.f;
    } else {
        self.listNewButton.layer.opacity = 0.f;
    }
    
    // Set this for better readability when not having any lists
    self.scrollNavigation.alwaysBounceHorizontal = YES;
    
    // Register new list button notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evaluateNewListChange:) name:@"newList" object:nil];
    
    // Register creating a new list view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNewListController:) name:@"createNewList" object:nil];
    
    // Register ListTable modifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutViews:) name:@"didChangeListTable" object:nil];
    
//    // Generate views and play on scrollview
//    [self layoutViews];
    
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

- (void)viewDidAppear:(BOOL)animated {
    
    if ([User instance].userDidChangeAdd) {
        [self performSelector:@selector(layoutViews) withObject:nil afterDelay:kAnimation];
    } else if ([User instance].userDidChangeDelete) {
        [self performSelector:@selector(layoutViews) withObject:nil];
    } else {
        [self layoutViews];
    }
    
}

#pragma mark - Buttons

- (IBAction)wantsNewList:(id)sender {
    
    UIScrollView *scroll;
    
    for (UIScrollView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scroll = view;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNote" object:scroll userInfo:nil];
    
}

#pragma mark - List Management

- (void)evaluateNewListChange:(NSNotification *)notification {
    
    CGFloat opacity;
    
    if ([Settings instance].doesWantDraggable) {
        opacity = 1.f;
    } else {
        opacity = 0.f;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.listNewButton.layer.opacity = opacity;
    
    [UIView commitAnimations];
    
}

- (void)pushNewListController:(NSNotification *)notification {
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewListViewController *vc = (NewListViewController*)[storybord instantiateViewControllerWithIdentifier:@"newListController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)layoutViews:(NSNotification *)notification {
    
    [self layoutViews];
    
}

- (void)layoutViews {
    
    // Remove to not have kept for overlapping views -- This needs to be done everytime we add new ones.
    for (UIView *subview in [self.scrollNavigation subviews]) {
        [subview removeFromSuperview];
    }
    
    // Cleanup old viewcontrollers that won't be used again
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    FarLeftViewController *farLeft = [[FarLeftViewController alloc] initWithNibName:@"FarLeftView" bundle:nil];
    
    CGRect leftFrame = farLeft.view.frame;
    leftFrame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    farLeft.view.frame = leftFrame;
    
    farLeft.view.tag = -1;
    
    [self addChildViewController:farLeft];
    [self.scrollNavigation addSubview:farLeft.view];
    [farLeft didMoveToParentViewController:self];
    
    // Define the width of the scrollview before we reset to 0. 0 was changing when deleting.
    CGFloat scrollWidth = ([[User instance].lists count] + 1) * self.view.frame.size.width;
    CGFloat scrollHeight = self.view.frame.size.height;
    self.scrollNavigation.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
    // This needs to be after the farleft view creation because of the scrolling to farleft content.
    if ([User instance].userDidChangeDelete) {
        
        // Move to start screen
        [self.scrollNavigation setContentOffset:CGPointMake(0, 0) animated:YES];
        [User instance].userDidChangeDelete = NO;
        
    }
    
    // Generate views based on how many lists we have.
    for (int i = 1; i <= [[User instance].lists count]; i++) {
        
        [self layoutNewListViewWithCount:i];
        
    }
    
    if ([User instance].userDidChangeAdd) {
        [self.scrollNavigation setContentOffset:CGPointMake([[User instance].lists count] * self.view.frame.size.width, 0) animated:YES];
        [User instance].userDidChangeAdd = NO;
    }
    
}

- (void)layoutNewListViewWithCount:(int)i {
    
    ListViewController *listView = [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    
    [self addChildViewController:listView];
    [self.scrollNavigation addSubview:listView.view];
    [listView didMoveToParentViewController:self];
    
    // Customize the view's properties
    List *list = [[User instance].lists objectAtIndex:i - 1];
    
    listView.listTitle.text = list.listName;
    
    // Setup sharedWith data, hide if not shared.
    if (list.sharedWith.count != 0) {
        NSString *shared = [list.sharedWith componentsJoinedByString:@", "];
        listView.sharedWith.text = [NSString stringWithFormat:@"Shared with: %@", shared];
    } else {
        listView.bottomOfTableConst.constant = 0;
    }
    
    listView.view.tag = i - 1;
    
    // Spacially places the new view inside of the scrollview
    CGRect listFrame = listView.view.frame;
    listFrame.origin.x = (i) * self.view.frame.size.width;
    listFrame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    listView.view.frame = listFrame;
    
}

#pragma mark - Scrollview Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Drop the keyboard
    [self.view endEditing:NO];
    
    CGFloat offset = scrollView.contentOffset.x;
    [self animationForScroll:offset withDirection:ScrollDirectionRight];
    
//    UIScrollView *scroll;
//    
//    for (UIScrollView *view in [self.view subviews]) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            scroll = view;
//        }
//    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNote" object:scroll userInfo:nil];
    
}

- (void)animationForScroll:(CGFloat)offset withDirection:(int)direction {
    
    // Direction can also be used here.
    
    CATransform3D labelTransform = CATransform3DTranslate(CATransform3DIdentity, 1.25*offset, 0, 0);
    self.testing.layer.transform = labelTransform;
}

#pragma mark - Button drag

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
        
        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.view];
        
        CGRect newButtonFrame = draggedButton.frame;
        newButtonFrame.origin.x += translation.x;
        newButtonFrame.origin.y += translation.y;
        
        if (CGRectContainsRect(self.view.frame, newButtonFrame))
            draggedButton.frame = newButtonFrame;
        
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    }
    
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
