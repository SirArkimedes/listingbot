//
//  ListSettingsViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/12/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ListSettingsViewController.h"

#import "User.h"
#import "List.h"

#import <Parse/Parse.h>

#define kAnimation .5f

typedef NS_ENUM(NSUInteger, cellType) {
    shareCell,
    deleteCell,
};

@interface ListSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;

@property (weak, nonatomic) IBOutlet UIView *deleteDialogContainer;
@property (weak, nonatomic) IBOutlet UIView *blindBackground;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (weak, nonatomic) IBOutlet UIView *checkmarkDialog;
@property (weak, nonatomic) IBOutlet UIView *buttonHolderDialog;

@property (nonatomic, assign) CGRect originalBounds;
@property (nonatomic, assign) CGPoint originalCenter;

@property List *list;

@end

@implementation ListSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set list specifics
    List *list = [[User instance].lists objectAtIndex:self.listIndex];
    self.list = list;
    
    self.listNameLabel.text = [NSString stringWithFormat:@"%@ Settings", self.list.listName];
    
    // Setup our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Setup the dialog
    self.buttonHolderDialog.layer.cornerRadius = 10.f;
    self.buttonHolderDialog.layer.masksToBounds = YES;
    
    self.checkmarkDialog.layer.cornerRadius = 45.f;
    self.checkmarkDialog.layer.masksToBounds = YES;
    self.checkmarkDialog.layer.borderWidth = 5.f;
    self.checkmarkDialog.layer.borderColor = [self.buttonHolderDialog.backgroundColor CGColor];
    self.checkmarkDialog.layer.shadowColor = nil;
    
    // Set originals
    self.originalBounds = self.deleteDialogContainer.bounds;
    self.originalCenter = self.deleteDialogContainer.center;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)didDelete:(id)sender {
    
    // Delete
    [[User instance].lists removeObject:self.list];
    
//    [User instance].userDidDeleteFromList = YES;
    [User instance].userDidChangeDelete = YES;
    
    // TODO: Remove from sharedWith on User Instance and pass new list to server.
    
    [self saveUserObject:[User instance] key:@"user"];
    
    // Save delete to server
    NSData *userArchive = [NSKeyedArchiver archivedDataWithRootObject:[User instance]];
    
    [PFCloud callFunctionInBackground:@"deleteListFromUserObject"
                       withParameters:@{@"object": userArchive, @"userUuid": [User instance].userUuid, @"listUuid": self.list.listUuid}
                                block:^(NSNumber *results, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Success! Deleted list from User object.");
                                    } else {
                                        NSLog(@"Delete List function error: %@", error.description);
                                    }
                                }];
    
    [self hideDeleteDialog];
    
}

- (IBAction)didNotDelete:(id)sender {
    
    [self hideDeleteDialog];
    
}

- (void)saveUserObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case deleteCell:
            cell = [self setupDeleteCellWithTableView:tableView];
            break;
        case shareCell:
            cell = [self setupShareCellWithTableView:tableView];
            break;
    }
    
    return cell;
}

- (UITableViewCell *)setupDeleteCellWithTableView:(UITableView *)tableView {
    
    static NSString *textFieldCellIdentifier = @"delete";
    
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
    
    return cell;
    
}

- (UITableViewCell *)setupShareCellWithTableView:(UITableView *)tableView {
    
    static NSString *textFieldCellIdentifier = @"share";

    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
    
    return cell;
    
}

- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1)
        return deleteCell;
    else
        return shareCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case deleteCell:
            return 44;
            break;
        case shareCell:
            return 152.f;
            break;
        default:
            return 44;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self typeForRowAtIndexPath:indexPath] == deleteCell) {
        [self displayDeleteDialog];
    }
    
}

- (void)displayDeleteDialog {
    
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
    CGRect viewFrame = self.deleteDialogContainer.frame;
    viewFrame.origin.y = -viewFrame.size.height;
    self.deleteDialogContainer.frame = viewFrame;
    
    self.deleteDialogContainer.hidden = NO;
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.deleteDialogContainer snapToPoint:self.view.center];
    snapBehaviour.damping = 1.f;
    [self.animator addBehavior:snapBehaviour];
    
}

- (void)hideDeleteDialog {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.deleteDialogContainer]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.deleteDialogContainer]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.deleteDialogContainer];
    [self.animator addBehavior:itemBehaviour];
    
    // Animate in the background blind
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.blindBackground.alpha = 0.f;
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    [keyWindow tintColorDidChange];
    
    [UIView commitAnimations];
    
    if ([User instance].userDidChangeDelete) {
        [self performSelector:@selector(dismissBack) withObject:nil afterDelay:2 * kAnimation];
    } else {
        [self performSelector:@selector(removeAlert) withObject:nil afterDelay:kAnimation];
    }
    
}

- (void)removeAlert {
    
    [self.deleteDialogContainer setHidden:YES];
    
    // Reset animations
    [self.animator removeAllBehaviors];
    
    // Move above view for next press
    self.deleteDialogContainer.bounds = self.originalBounds;
    self.deleteDialogContainer.center = self.originalCenter;
    self.deleteDialogContainer.transform = CGAffineTransformIdentity;
    
}

- (void)dismissBack {
    [self dismissViewControllerAnimated:YES completion:nil];
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
