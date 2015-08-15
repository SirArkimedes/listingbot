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

typedef NS_ENUM(NSUInteger, cellType) {
    shareCell,
    deleteCell,
};

@interface ListSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property List *list;

@end

@implementation ListSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    List *list = [[User instance].lists objectAtIndex:self.listIndex];
    self.list = list;
    
    self.title = [NSString stringWithFormat:@"%@ Settings", self.list.listName];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
