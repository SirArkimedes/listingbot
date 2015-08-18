//
//  FarLeftViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "FarLeftViewController.h"

#import "AddListTableViewCell.h"
#import "DraggableNewListTableViewCell.h"

#import "Settings.h"

typedef NS_ENUM(NSUInteger, cellType) {
    welcomeCell,
    addNewListCell,
    underNewSeperatorCell,
    draggableNewList,
};

@interface FarLeftViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end

@implementation FarLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.settingTable.dataSource = self;
    self.settingTable.delegate =  self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshTable" object:nil];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableWithNotification:(NSNotification *)notification {
    [self.settingTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if ([Settings instance].doesWantDraggable) {
        return 2;
    } else {
        return 4;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case welcomeCell:
            cell = [self setupWelcomeCellWithTableView:tableView];
            break;
        case addNewListCell:
            cell = [self setupAddNewListCellWithTableView:tableView];
            break;
        case underNewSeperatorCell:
            cell = [self setupSeperatorCellWithTableView:tableView];
            break;
        case draggableNewList:
            cell = [self setupDraggableNewListCellWithTableView:tableView];
            break;
    }
    
    return cell;
}

- (UITableViewCell *)setupWelcomeCellWithTableView:(UITableView *)tableView {
    
    static NSString *welcomeCellIdentifier = @"welcomeCell";
    
    // this is a textfield cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:welcomeCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WelcomeCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupAddNewListCellWithTableView:(UITableView *)tableView {
    
    static NSString *addNewListCellIdentifier = @"addNewList";
    
    // this is a textfield cell
    AddListTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:addNewListCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddListCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupSeperatorCellWithTableView:(UITableView *)tableView {
    
    static NSString *seperatorCellIdentifier = @"farLeftSeperator";
    
    // this is a textfield cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:seperatorCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FarLeftSeperator" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupDraggableNewListCellWithTableView:(UITableView *)tableView {
    
    static NSString *draggableNewListCellIdentifier = @"draggableNewList";
    
    // this is a textfield cell
    DraggableNewListTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:draggableNewListCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DraggableNewList" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}



- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Settings instance].doesWantDraggable) {
        
        switch (indexPath.row) {
            case 0:
                return welcomeCell;
                break;
            case 1:
                return draggableNewList;
            default:
                return welcomeCell;
                break;
        }
        
    } else {
    
        switch (indexPath.row) {
            case 0:
                return welcomeCell;
                break;
            case 1:
                return addNewListCell;
                break;
            case 2:
                return underNewSeperatorCell;
                break;
            case 3:
                return draggableNewList;
            default:
                return welcomeCell;
                break;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case welcomeCell:
            return 177.f;
            break;
        case addNewListCell:
            return 44.f;
            break;
        case underNewSeperatorCell:
            return 11.f;
            break;
        case draggableNewList:
            return 44.f;
            break;
        default:
            return 44.f;
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
