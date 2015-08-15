//
//  FarLeftViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "FarLeftViewController.h"

typedef NS_ENUM(NSUInteger, cellType) {
    welcomeCell,
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case welcomeCell:
            cell = [self setupWelcomeCellWithTableView:tableView];
            break;
    }
    
    return cell;
}

- (UITableViewCell *)setupWelcomeCellWithTableView:(UITableView *)tableView {
    
    static NSString *textFieldCellIdentifier = @"welcomeCell";
    
    // this is a textfield cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WelcomeCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return welcomeCell;
    else
        return welcomeCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case welcomeCell:
            return 177;
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
