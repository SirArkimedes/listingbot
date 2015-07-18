//
//  ShareCodeViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ShareCodeViewController.h"

#import <Parse/Parse.h>

#define kAnimation .5f

@interface ShareCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *shareCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *allDone;
@property (weak, nonatomic) IBOutlet UILabel *lastInformation;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property int stage;

@end

@implementation ShareCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shareCodeTextField = [self styleField:self.shareCodeTextField];
    self.nameField = [self styleField:self.nameField];
    
    [PFCloud callFunctionInBackground:@"newUserId"
                       withParameters:nil
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", results);
                                    }
                                }];
    
    // Set animation stage
    self.stage = 1;
    
    // Textfield keyboard hide
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (UITextField *)styleField:(UITextField *)field {
    
    field.delegate = self;
    field.layer.cornerRadius = 5.0f;
    
    return field;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    
    [self.shareCodeTextField resignFirstResponder];
    [self.nameField resignFirstResponder];
    
}

#pragma mark - Buttons

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Is Empty?
    if ([textField.text isEqual:@""]) {
        
        
        [self shake:textField];
        
        return NO;
        
    } else {
        
        // What animation stage are we on?
        switch (self.stage) {
            case 1:
                [self performSelector:@selector(animateOutCodeView) withObject:nil];
                break;
            case 2:
                [self performSelector:@selector(animateOutName) withObject:nil];
                break;
            default:
                break;
        }
        
        return YES;
    }
}

#pragma mark - Animations

- (void)animateOutCodeView {
    
    // Begin animation for next question.
    CGRect viewFrame = self.codeView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.codeView.frame = viewFrame;
    self.codeView.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateInName) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateInName {
    
    // Stage change
    self.stage = 2;
    
    // Unhide
    self.nameView.hidden = NO;
    self.nameView.layer.opacity = 0.f;
    
    // Move keyboard
    [self.nameField becomeFirstResponder];
    
    // OG
    CGRect listViewOG = self.nameView.frame;
    
    // New positions
    CGRect viewFrame = self.nameView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.nameView.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.nameView.frame = listViewOG;
    self.nameView.layer.opacity = 1.f;
    self.lastInformation.layer.opacity = 1.f;
    
    [UIView commitAnimations];
    
    //    [self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateOutName {
    
    // Move to ending.
    CGRect viewFrame = self.nameView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.nameView.frame = viewFrame;
    self.nameView.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateInAllDone) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateInAllDone {
    
    // Unhide
    self.allDone.hidden = NO;
    self.allDone.layer.opacity = 0.f;
    
    // Drop keyboard
    [self.nameField resignFirstResponder];
    
    // OG
    CGRect listViewOG = self.allDone.frame;
    
    // New positions
    CGRect viewFrame = self.nameView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.allDone.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.allDone.frame = listViewOG;
    self.allDone.layer.opacity = 1.f;
    self.lastInformation.layer.opacity = 0.f;
    self.cancelButton.alpha = 0.f;
    
    [UIView commitAnimations];
    
//    [self performSelector:@selector(saveInputData) withObject:nil];
    [self performSelector:@selector(dropView) withObject:nil afterDelay:kAnimation*10];
    
}

- (void)dropView {
    [self performSegueWithIdentifier:@"unwindToList" sender:self];
}

- (void)shake:(UIView *)field {
    
    const int reset = 5;
    const int maxShakes = 6;
    
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration: 0.09 - (shakes * .01) // reduce duration every shake from .09 to .04
                          delay: 0.01f //edge wait delay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{field.transform = CGAffineTransformMakeTranslation(translate, 0);}
                     completion: ^(BOOL finished) {
                         if (shakes < maxShakes) {
                             shakes++;
                             
                             //throttle down movement
                             if (translate > 0)
                                 translate--;
                             
                             //change direction
                             translate *= -1;
                             [self shake:field];
                         } else {
                             field.transform = CGAffineTransformIdentity;
                             shakes = 0; //ready for next time
                             translate = reset; //ready for next time
                             return;
                         }
                     }];
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
