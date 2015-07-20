//
//  MainListViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/18/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "MainListViewController.h"

@interface MainListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *listsTable;
@property (weak, nonatomic) IBOutlet UITableView *contentOfList;

@end

@implementation MainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure tables
    self.listsTable.dataSource = self;
    self.listsTable.delegate = self;
    
    self.contentOfList.dataSource = self;
    self.contentOfList.delegate = self;
    
//    self.title = @"ListingBot!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.listsTable) {
        // Left-most table
        
        return 21;
        
    } else {
        // Lists content table
        
        return 2;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (tableView == self.listsTable) {
        // Left-most table
        
        cell = [self listsTableSetupWith:tableView cellForRowAtIndexPath:indexPath];
        
    } else {
        // Lists content table
        
        cell = [self contentOfListSetupWith:tableView cellForRowAtIndexPath:indexPath];
        
    }
    
    return cell;
    
}

- (UITableViewCell *)listsTableSetupWith:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *contentCellIdentifier = @"contentCell";
    static NSString *separaterCellIdentifier = @"separatorCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row % 2 == 0) {
        // this is a content cell
        cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"contentCell" owner:self options:nil] objectAtIndex:0];
        }
        
    } else {
        // this is a separator cell
        cell = [tableView dequeueReusableCellWithIdentifier:separaterCellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"separatorCell" owner:self options:nil] objectAtIndex:0];
        }
    }
    
    if (indexPath.row == 1) {
        
        cell.selected = YES;
        
    }
    
    return cell;
    
}

- (UITableViewCell *)contentOfListSetupWith:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *listItem = @"listItem";
    
    UITableViewCell *cell = nil;
    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"listItem" owner:self options:nil] objectAtIndex:0];
//    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:listItem];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.listsTable) {
        // Left-most table
    
        if (indexPath.row % 2 == 0) {
            // this is a regular cell
            return 75;
        } else {
            // this is a "space" cell
            return 10;
        }
        
    } else {
        // Lists content table
        return 44;
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
