//
//  ListingsViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ListingsViewController.h"

#define kAnimation .5f

@interface ListingsViewController ()

@property (weak, nonatomic) IBOutlet UIView *firstLaunch;
@property (weak, nonatomic) IBOutlet UIView *blindBackground;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation ListingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

- (void)viewDidAppear:(BOOL)animated {
        
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.firstLaunch.hidden = NO;
        self.blindBackground.hidden = NO;
        
        [self performSelector:@selector(animateInAlert) withObject:nil];
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Unwind

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"unwindToList"]) {
        
        [self performSelector:@selector(animateOutAlert) withObject:nil afterDelay:kAnimation];
        
    }
    
}

#pragma mark - Animations

- (void)animateInAlert {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    // Adjust our keyWindow's tint adjustment mode to make everything behind the alert view dimmed
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];
    
    // Animate in the background blind
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.blindBackground.alpha = .85f;
    
    [UIView commitAnimations];
    
    // New positions
    CGRect viewFrame = self.firstLaunch.frame;
    viewFrame.origin.y = -viewFrame.size.height;
    self.firstLaunch.frame = viewFrame;
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.firstLaunch snapToPoint:self.view.center];
    snapBehaviour.damping = 1.f;
    [self.animator addBehavior:snapBehaviour];
    
}

- (void)animateOutAlert {
    
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.firstLaunch]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.firstLaunch]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.firstLaunch];
    [self.animator addBehavior:itemBehaviour];
    
    // Animate in the background blind
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.blindBackground.alpha = 0.f;
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    [keyWindow tintColorDidChange];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:kAnimation];
    
}

- (void)removeAlert {
    
    [self.firstLaunch setHidden:YES];
    
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
