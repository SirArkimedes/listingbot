//
//  ListViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ListViewController.h"
#import "ItemsTableViewCell.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *itemTable;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemTable.delegate = self;
    self.itemTable.dataSource = self;
    
//    // Gradient text
//    CAGradientLayer *l = [CAGradientLayer layer];
//    l.frame = self.listTitle.bounds;
//    l.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor];
//    l.startPoint = CGPointMake(0.1f, 1.0f);
//    l.endPoint = CGPointMake(0.95f, 1.0f);
//    self.listTitle.layer.mask = l;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *contentCellIdentifier = @"item";
    static NSString *separaterCellIdentifier = @"separatorCell";
    
    if (indexPath.row % 2 == 0) {
        // this is a content cell
        ItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        // Forces some color somewhere to not be white, causing cells to have a white background.
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    } else {
        // this is a separator cell
        UITableViewCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:separaterCellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SeperatorTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        // Forces some color somewhere to not be white, causing cells to have a white background.
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        // this is a regular cell
        return 44;
    } else {
        // this is a "space" cell
        return 10;
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
