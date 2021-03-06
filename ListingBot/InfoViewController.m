//
//  InfoViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "InfoViewController.h"

#import <Parse/Parse.h>

#import "User.h"
#import "List.h"

#import "DataHandler.h"
#import "AlertViewController.h"

#define kAnimation .5f

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *listField;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet UIView *allDone;
@property (weak, nonatomic) IBOutlet UILabel *littleInformation;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

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
    
    // Set animation stage
    self.stage = 1;
    
    // Textfield keyboard hide
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    
}

- (UITextField *)styleField:(UITextField *)field {
    
    field.delegate = self;
    field.layer.cornerRadius = 5.0f;
    field.tintColor = [UIColor grayColor];
    
    return field;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    
    [self.nameField resignFirstResponder];
    [self.listField resignFirstResponder];
    
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
                [self performSelector:@selector(animateOutPersonName) withObject:nil];
                break;
            case 2:
                [self performSelector:@selector(animateOutListName) withObject:nil];
                break;
            default:
                break;
        }
        
        return YES;
    }
}

#pragma mark - Animations

- (void)animateOutPersonName {
    
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
    
}

- (void)animateInListName {
    
    // Stage change
    self.stage = 2;
    
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

- (void)animateOutListName {
    
    // Move to ending.
    CGRect viewFrame = self.listView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.listView.frame = viewFrame;
    self.listView.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateInAllDone) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateInAllDone {
    
    // Unhide
    self.allDone.hidden = NO;
    self.allDone.layer.opacity = 0.f;
    
    // Drop keyboard
    [self.listField resignFirstResponder];
    
    // OG
    CGRect listViewOG = self.allDone.frame;
    
    // New positions
    CGRect viewFrame = self.listView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.allDone.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.allDone.frame = listViewOG;
    self.allDone.layer.opacity = 1.f;
    self.littleInformation.layer.opacity = 0.f;
    self.cancelButton.alpha = 0.f;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(saveInputData) withObject:nil];
    
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

#pragma mark - Data

- (void)saveInputData {
    
    NSString *name = self.nameField.text;
    NSString *listName = self.listField.text;
    
    //    NSArray *inputData = @[name, listName];
    
    // Create a 'dirty' uuid
    //    NSString *userUuid = [[NSUUID UUID] UUIDString];
//    NSString *lUuid = [[NSUUID UUID] UUIDString];
    
    // Create the list
    List *newList = [[List alloc] init];
    newList.listName = listName;
//    newList.listUuid = lUuid;
    newList.sharedWith = [[NSMutableArray alloc] init];
    newList.listItems = [[NSMutableArray alloc] init];
    
    // Add to Local User
    [[User instance].lists addObject:newList];
    [User instance].userName = name;
    [User instance].userDidChangeAdd = YES;
    
    [self saveUserObject:[User instance] key:@"user"];
    
    [[DataHandler instance] createNewUserWithBlock:^(BOOL success) {
        [self dropView];
    }];
    
}

- (void)saveUserObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

- (void)dropView {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
