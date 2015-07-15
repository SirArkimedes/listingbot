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
    self.nameField.delegate = self;
    self.nameField.layer.borderWidth = 1.0f;
    self.nameField.layer.cornerRadius = 5.0f;
    self.nameField.layer.borderColor = [[UIColor blueColor] CGColor];
    
    self.listField.delegate = self;
    self.listField.layer.borderWidth = 1.0f;
    self.listField.layer.cornerRadius = 5.0f;
    self.listField.layer.borderColor = [[UIColor blueColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Begin animation for next question.
    CGRect viewFrame = self.nameView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.nameView.frame = viewFrame;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateInListName) withObject:nil afterDelay:kAnimation/2];
    
    return YES;
}

#pragma mark - Animations

- (void)animateInListName {
    
    // Unhide
    self.listView.hidden = NO;

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
    
    [UIView commitAnimations];
    
//    [self performSelector:@selector(animateInListName) withObject:nil afterDelay:kAnimation];
    
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
