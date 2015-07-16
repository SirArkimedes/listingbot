//
//  InfoViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "InfoViewController.h"

#define kAnimation .5f

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *listField;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *listView;

@property int stage;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Textfield styling
//    self.nameField.delegate = self;
//    self.nameField.layer.borderWidth = 1.0f;
//    self.nameField.layer.cornerRadius = 5.0f;
//    self.nameField.layer.borderColor = [[UIColor blueColor] CGColor];
    self.nameField = [self styleField:self.nameField];
    self.listField = [self styleField:self.listField];
    
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

#pragma mark - Buttons

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text isEqual:@""]) {
        
        
        [self shake:textField];
        
        return NO;
        
    } else {
        
        // Begin animation for next question.
        CGRect viewFrame = self.nameView.frame;
        viewFrame.origin.x = -self.view.frame.size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kAnimation];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.nameView.frame = viewFrame;
        self.nameView.layer.opacity = 0.f;
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(animateInListName) withObject:nil afterDelay:kAnimation];
        
        return YES;
    }
}

#pragma mark - Animations

- (void)animateInListName {
    
    // Unhide
    self.listView.hidden = NO;
    self.listView.layer.opacity = 0.f;
    
    // Move keyboard
    [self.listField becomeFirstResponder];

    // OG
    CGRect listViewOG = self.listView.frame;
    
    // New positions
    CGRect viewFrame = self.listView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.listView.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.listView.frame = listViewOG;
    self.listView.layer.opacity = 1.f;
    
    [UIView commitAnimations];
    
//    [self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:kAnimation];
    
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
