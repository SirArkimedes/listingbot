//
//  AlertViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 11/22/15.
//  Copyright © 2015 Robinson Bros. All rights reserved.
//

#import "AlertViewController.h"

#define kAnimation .5f

@interface AlertViewController ()

@property (weak, nonatomic) IBOutlet UIView *alertContainer;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;

@property (weak, nonatomic) IBOutlet UIView *buttonHolderDialog;
@property (weak, nonatomic) IBOutlet UIView *checkmarkDialog;

@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIImageView *topSymbol;

@property NSString *alertMessage;
@property NSString *topButtonMessage;
@property NSString *bottomButtonMessage;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation AlertViewController

#pragma mark - Creation

- (id)init
{
    if (self = [super init])
    {
        [self setupUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupUI];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
//    self.view.backgroundColor = [UIColor clearColor];
    
    self.redColor = [self colorWithRed:255.0 green:26.0 blue:0.0];
    self.exImage = [UIImage imageNamed:@"whiteX"];
    self.providesPresentationContextTransitionStyle = YES;
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.clearColor;
    self.alertContainer.hidden = YES;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.blurView.effect = nil;
    
    self.buttonHolderDialog.layer.cornerRadius = 10.f;
    self.buttonHolderDialog.layer.masksToBounds = YES;
    
    self.checkmarkDialog.layer.cornerRadius = 45.f;
    self.checkmarkDialog.layer.masksToBounds = YES;
    self.checkmarkDialog.layer.borderWidth = 5.f;
    self.checkmarkDialog.layer.borderColor = [self.buttonHolderDialog.backgroundColor CGColor];
    self.checkmarkDialog.layer.shadowColor = nil;
    
    if (!self.color) {
        self.color = [self colorWithRed:35.0 green:170.0 blue:96.0];
    }
    self.topButton.backgroundColor = self.color;
    self.bottomButton.backgroundColor = self.color;
    self.checkmarkDialog.backgroundColor = self.color;
    
    if (!self.topImage) {
        self.topImage = [UIImage imageNamed:@"Basic_tick_64"];
    }
    self.topSymbol.image = self.topImage;
    
    self.alertTitle.text = self.alertMessage;
    [self.topButton setTitle:self.topButtonMessage forState:UIControlStateNormal];
    [self.bottomButton setTitle:self.bottomButtonMessage forState:UIControlStateNormal];
        
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self displayAlertDialog];
}

- (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

#pragma mark - Publics

- (void)setAlertWithTitle:(NSString *)title withButton:(NSString *)top withButton:(NSString *)bottom {
    self.alertMessage = title;
    self.topButtonMessage = top;
    self.bottomButtonMessage = bottom;
}

#pragma mark - Buttons

- (IBAction)topButtonPressed:(id)sender {
    [self.delegate topButtonPressedOnAlertView:self];
    [self hideAlertDialog];
}

- (IBAction)bottomButtonPressed:(id)sender {
    [self.delegate bottomButtonPressedOnAlertView:self];
    [self hideAlertDialog];
}

#pragma mark - Animations

- (void)displayAlertDialog {
    
    // Animate in the background blind
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //    self.blurView.alpha = .85f;
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [self.blurView setEffect:effect];
    
    [UIView commitAnimations];
    
    // New positions
    CGRect viewFrame = self.alertContainer.frame;
    viewFrame.origin.y = -viewFrame.size.height;
    self.alertContainer.frame = viewFrame;
    
    self.alertContainer.hidden = NO;
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.alertContainer snapToPoint:self.view.center];
    snapBehaviour.damping = 1.f;
    [self.animator addBehavior:snapBehaviour];
    
}

- (void)hideAlertDialog {
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.alertContainer]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertContainer]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.alertContainer];
    [self.animator addBehavior:itemBehaviour];
    
    // Animate in the background blind
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //    self.blurView.alpha = 0.f;
    self.blurView.effect = nil;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:kAnimation];
    
    //    if ([User instance].userDidChangeDelete) {
    //        [self performSelector:@selector(dismissBack) withObject:nil afterDelay:2 * kAnimation];
    //    } else {
    //        [self performSelector:@selector(removeAlert) withObject:nil afterDelay:kAnimation];
    //    }
    
}

- (void)removeAlert {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
