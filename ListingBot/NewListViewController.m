//
//  NewListViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "NewListViewController.h"

#import "User.h"
#import "List.h"

#define UIColorFromRGB(rgbValue, ...) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                      green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                       blue:((float)(rgbValue & 0xFF))/255.0 alpha:__VA_ARGS__]

#define kAnimation .5f

@interface NewListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *yesShareCopy;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *allDoneView;
@property (weak, nonatomic) IBOutlet UIView *yesShare;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property BOOL didWantShare;
@property BOOL shareCode;
@property (strong, nonatomic) NSString *listName;

@end

@implementation NewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Textfield keyboard hide
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Setup textfield
    self.nameField = [self styleField:self.nameField];
    
    self.yesShareCopy.layer.cornerRadius = 5.f;
    
    self.codeField = [self styleField:self.codeField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    
    [self.nameField resignFirstResponder];
    [self.codeField resignFirstResponder];
    
}

- (UITextField *)styleField:(UITextField *)field {
    
    field.delegate = self;
    field.layer.cornerRadius = 5.0f;
    field.tintColor = [UIColor grayColor];
    
    return field;
}

#pragma mark - NewList

- (void)addNewList {
    
    List *newList = [[List alloc] init];
    
    newList.listName = self.listName;
    newList.sharedWith = [[NSMutableArray alloc] init];
    newList.listItems = [[NSMutableArray alloc] init];
//    newList.listUuid = [[NSUUID UUID] UUIDString];
    
    [[User instance].lists addObject:newList];
    
    [User instance].userDidChangeAdd = YES;
    
//    [PFCloud callFunctionInBackground:@"newListId"
//                       withParameters:nil
//                                block:^(NSNumber *results, NSError *error) {
//                                    if (!error) {
//                                        [self performSelector:@selector(saveListWithUuid:) withObject:results];
//                                    } else {
//                                        NSLog(@"Uuid function grab error: %@", error.description);
//                                    }
//                                }];
    
}

- (void)saveListWithUuid:(NSNumber *)uuid {
    
    List *newList = [[List alloc] init];
    
    newList.listName = self.listName;
    newList.sharedWith = [[NSMutableArray alloc] init];
    newList.listItems = [[NSMutableArray alloc] init];
    
    [[User instance].lists addObject:newList];
    
}

#pragma mark - Buttons

- (IBAction)yesShare:(id)sender {
    
    [self animateOutShareView];
    
    self.didWantShare = YES;
    
}

- (IBAction)noShare:(id)sender {
    
    [self animateOutShareView];
    
}

- (IBAction)yesShareCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.yesShareCopy.titleLabel.text;
    
    [self animateOutYesShare];
    
}

- (IBAction)shareCode:(id)sender {
    
    self.shareCode = YES;
    
    [self animateOutShareView];
    
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Is Empty?
    if ([textField.text isEqual:@""]) {
        
        [self shake:textField];
        
        return NO;
        
    } else {
        
        if (textField == self.codeField) {
            
            [self animateOutShareCode];
            
        } else {
        
            self.listName = textField.text;
            [self animateOutListName];
            
        }
        
        return YES;
    }
}

#pragma mark - Animations

- (void)animateOutShareView {
    
    // Begin animation for next question.
    CGRect viewFrame = self.shareView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.shareView.frame = viewFrame;
    self.shareView.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    if (self.shareCode)
        [self performSelector:@selector(animateInShareCode) withObject:nil afterDelay:kAnimation];
    else
        [self performSelector:@selector(animateInListName) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateInShareCode {
    
    // Unhide
    self.codeView.hidden = NO;
    self.codeView.layer.opacity = 0.f;
    
    // Move keyboard
    [self.codeField becomeFirstResponder];
    
    // OG
    CGRect listViewOG = self.codeView.frame;
    
    // New positions
    CGRect viewFrame = self.codeView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.codeView.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.codeView.frame = listViewOG;
    self.codeView.layer.opacity = 1.f;
    
    [UIView commitAnimations];
    
    //    [self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateOutShareCode {
    
    // Move to ending.
    CGRect viewFrame = self.codeView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.codeView.frame = viewFrame;
    self.codeView.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateInAllDone) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateInListName {
    
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
    
    [UIView commitAnimations];
    
    //    [self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateOutListName {
    
    // Move to ending.
    CGRect viewFrame = self.nameView.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.nameView.frame = viewFrame;
    self.nameView.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    if (self.didWantShare) {
        [self performSelector:@selector(animateInYesShare) withObject:nil afterDelay:kAnimation];
    } else {
        [self performSelector:@selector(animateInAllDone) withObject:nil afterDelay:kAnimation];
        [self addNewList];
    }
    
}

- (void)animateInYesShare {
    
    // Unhide
    self.yesShare.hidden = NO;
    self.yesShare.layer.opacity = 0.f;
    
    // resign keyboard
    [self.nameField resignFirstResponder];
    
    // OG
    CGRect listViewOG = self.yesShare.frame;
    
    // New positions
    CGRect viewFrame = self.nameView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.yesShare.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.yesShare.frame = listViewOG;
    self.yesShare.layer.opacity = 1.f;
    
    [UIView commitAnimations];
    
    //    [self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateOutYesShare {
    
    // Move to ending.
    CGRect viewFrame = self.yesShare.frame;
    viewFrame.origin.x = -self.view.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.yesShare.frame = viewFrame;
    self.yesShare.layer.opacity = 0.f;
    
    [UIView commitAnimations];
    
    [self addNewList];
    [self performSelector:@selector(animateInAllDone) withObject:nil afterDelay:kAnimation];
    
}

- (void)animateInAllDone {
    
    // Unhide
    self.allDoneView.hidden = NO;
    self.allDoneView.layer.opacity = 0.f;
    
    // Drop keyboard
    [self dismissKeyboard];
    
    // OG
    CGRect listViewOG = self.allDoneView.frame;
    
    // New positions
    CGRect viewFrame = self.allDoneView.frame;
    viewFrame.origin.x = viewFrame.size.width;
    self.allDoneView.frame = viewFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.allDoneView.frame = listViewOG;
    self.allDoneView.layer.opacity = 1.f;
    self.cancelButton.alpha = 0.f;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(dropView) withObject:nil afterDelay:kAnimation*10];
    
}

- (void)dropView {
    [self dismissViewControllerAnimated:YES completion:nil];
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
