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

#import "AlertViewController.h"

#import <Parse/Parse.h>

#define kAnimation .5f

typedef NS_ENUM(NSUInteger, cellType) {
    shareCell,
    deleteCell,
};

@interface ListSettingsViewController () <AlertViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        AlertViewController *alert = [[AlertViewController alloc] init];
        [alert setAlertWithTitle:@"Are you sure you want to delete this list?" withButton:@"Yes" withButton:@"No"];
        alert.delegate = self;
        alert.color = alert.redColor;
        alert.topImage = alert.exImage;
        self.definesPresentationContext = YES;
        [self presentViewController:alert animated:NO completion:nil];
    }
    
}

#pragma mark - AlertViewController Delegate

- (void)topButtonPressedOnAlertView:(AlertViewController *)alertView {
    [[User instance].lists removeObject:self.list];
    [User instance].userDidChangeDelete = YES;
    [self saveUserObject:[User instance] key:@"user"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - List delete

- (void)saveUserObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
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
