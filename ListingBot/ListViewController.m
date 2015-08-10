//
//  ListViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ListViewController.h"
#import "ItemsTableViewCell.h"
#import "ScrollNavigationViewController.h"

#import "User.h"
#import "List.h"
#import "Item.h"

#define kAnimation .5f

#define UIColorFromRGB(rgbValue, ...) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                    blue:((float)(rgbValue & 0xFF))/255.0 alpha:__VA_ARGS__]

typedef NS_ENUM(NSUInteger, cellType) {
    contentCell,
    seperatorCell,
    textFieldCell,
};

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *itemTable;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemTable.delegate = self;
    self.itemTable.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshTable" object:nil];
    
//    self.navigationView.layer.shadowOffset = CGSizeMake(0, 5);
//    self.navigationView.layer.shadowRadius = 20;
//    self.navigationView.layer.shadowOpacity = 0.5;
    
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

- (void)refreshTableWithNotification:(NSNotification *)notification {
    [[notification object] reloadData];
}

#pragma mark - Buttons

- (IBAction)listSettingsPress:(id)sender {
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = (UIViewController *)[storybord instantiateViewControllerWithIdentifier:@"settings"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)listSharePress:(id)sender {
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = (UIViewController *)[storybord instantiateViewControllerWithIdentifier:@"share"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    
    // Return item count * 2, because of seperator cells. -1 to remove the bottom seperator cell.
    return 2 * list.listItems.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case contentCell:
            cell = [self setupContentCellWithTableView:tableView withIndexPath:indexPath];
            break;
        case seperatorCell:
            cell = [self setupSeperatorCellWithTableView:tableView];
            break;
        case textFieldCell:
            cell = [self setupTextFieldCellWithTableView:tableView];
            break;
    }
    
    return cell;
    
}

- (UITableViewCell *)setupTextFieldCellWithTableView:(UITableView *)tableView {
    
    static NSString *textFieldCellIdentifier = @"addField";
    
    // this is a textfield cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupContentCellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *contentCellIdentifier = @"item";
    
    // this is a textfield cell
    ItemsTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    Item *item = [list.listItems objectAtIndex:indexPath.row/2];
    
    cell.itemName.text = item.itemName;
    cell.itemQuantity.text = [NSString stringWithFormat:@"%@", item.quantity];
    
    // Checks if the cell is completed or not and then modifies if needed.
    if (item.isDone)
        [self setCellDone:cell];
    else
        cell.selectionTriangle.image = nil;
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupSeperatorCellWithTableView:(UITableView *)tableView {
    
    static NSString *separaterCellIdentifier = @"separatorCell";
    
    // this is a textfield cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:separaterCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SeperatorTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case seperatorCell:
            return 10;
            break;
        default:
            return 44.f;
            break;
    }
    
}

- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    
    if (2 * list.listItems.count == indexPath.row)
        return textFieldCell;
    else if (indexPath.row % 2 == 0)
        return contentCell;
    else
        return seperatorCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self typeForRowAtIndexPath:indexPath] == contentCell) {
        
        ItemsTableViewCell *cell = (ItemsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [self evaluateSelectionWithCell:cell];
        
    }
    
}

- (void)evaluateSelectionWithCell:(ItemsTableViewCell *)cell {
    
    if (CGSizeEqualToSize(cell.selectionTriangle.image.size, CGSizeZero)) {
        
        [self setCellDone:cell];
        
    } else {
        
        cell.selectionTriangle.image = nil;
        
//        NSDictionary* attributes = @{
//                                    NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]
//                                    };
//        
//        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:cell.itemName.text attributes:attributes];
//        cell.itemName.attributedText = attrText;
        
    }
}

- (void)setCellDone:(ItemsTableViewCell *)cell {
    
    cell.selectionTriangle.image = [UIImage imageNamed:@"SelectionBubble"];
    
//    NSDictionary* attributes = @{
//                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
//                                 };
//    
//    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:cell.itemName.text attributes:attributes];
//    cell.itemName.attributedText = attrText;
    
}


- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2 {
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
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
