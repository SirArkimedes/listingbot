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

#import <Parse/Parse.h>

#import "User.h"
#import "List.h"
#import "Item.h"

#import "ListSettingsViewController.h"
#import "NotesView.h"
#import "EmptyStateView.h"

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

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property BOOL editing;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemTable.delegate = self;
    self.itemTable.dataSource = self;
                
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideEmptyState:) name:@"noLongerEmpty" object:nil];

    // Initialize with no editing.
    self.editing = NO;
    
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

- (void)viewDidAppear:(BOOL)animated {
    
    // Check for blank table
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    if ([list.listItems count] == 0) {
        [self presentEmptyState];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)refreshTableWithNotification:(NSNotification *)notification {
//    [self.itemTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    [self.itemTable setEditing:NO animated:YES];
//    
//    NSDictionary *dict = [notification userInfo];
//    
//    [[dict objectForKey:@[@"textfield"]] becomeFirstResponder];
//    
//}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)presentEmptyState {
    
    self.editButton.hidden = YES;
    [self setEditing:NO animated:YES];
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"EmptyState"
                                                         owner:self
                                                       options:nil];
    EmptyStateView *empty = [nibContents objectAtIndex:0];
    empty.frame = CGRectMake(self.itemTable.frame.origin.x, self.itemTable.frame.origin.y, self.view.frame.size.width, self.itemTable.frame.size.height);
    empty.alpha = 0.f;
    
    [self.view addSubview:empty];
    
    // Fade in empty
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    empty.alpha = 1.f;
    empty.addItem.enabled = YES;
    
    [UIView commitAnimations];
    
}

- (void)didHideEmptyState:(NSNotification *)notification {
    
    self.editButton.hidden = NO;
    
}

#pragma mark - Buttons

- (IBAction)listSettingsPress:(id)sender {
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListSettingsViewController *vc = (ListSettingsViewController*)[storybord instantiateViewControllerWithIdentifier:@"settings"];
    vc.listIndex = (NSUInteger)self.view.tag;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)editAction:(id)sender {
    
    if (self.editing)
        [self setEditing:NO animated:YES];
    else
        [self setEditing:YES animated:YES];
    
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    
    // Returning for no items
    if (list.listItems.count == 0) {
        return 0;
    }
    
    // Return item count * 2, because of seperator cells. -1 to remove the bottom seperator cell.
    if (self.editing)
        return list.listItems.count;
    else
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
    
    // this is a item cell
    ItemsTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    Item *item;
    if (self.editing)
        item = [list.listItems objectAtIndex:indexPath.row];
    else
        item = [list.listItems objectAtIndex:indexPath.row/2];
    
    cell.itemName.text = item.itemName;
    cell.itemQuantity.text = [NSString stringWithFormat:@"%@", item.quantity];

    // Checks if the cell is completed or not and then modifies if needed.
    if (item.isDone)
        [self setCellDone:cell];
    else {
        cell.selectionTriangle.image = nil;
        cell.doneWidthCon.constant = 0;
        
        cell.backgroundColor = UIColorFromRGB(0xFFFDEC, 1);
    }
    
    // Check for note on cell
    if (item.itemNote == nil || [item.itemNote isEqualToString:@""]) {
        [cell.noteButton setImage:[UIImage imageNamed:@"NoNote"] forState:UIControlStateNormal];
    } else {
        [cell.noteButton setImage:[UIImage imageNamed:@"Note"] forState:UIControlStateNormal];
    }
    
    return cell;
    
}

- (UITableViewCell *)setupSeperatorCellWithTableView:(UITableView *)tableView {
    
    static NSString *separaterCellIdentifier = @"separatorCell";
    
    // this is a seperator cell
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

// MARK - TABLE EDITING

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Disable swipe to delete
    if (self.itemTable.editing)
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case contentCell:
            return YES;
            break;
        case seperatorCell:
            return NO;
            break;
        case textFieldCell:
            return NO;
            break;
        default:
            return NO;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Using the view's tag with matching array index, get the list.
        List *list = [[User instance].lists objectAtIndex:self.view.tag];
        
//        Item *item = [list.listItems objectAtIndex:indexPath.row];
        
        [list.listItems removeObjectAtIndex:indexPath.row];
                
//        [PFCloud callFunctionInBackground:@"deleteItem"
//                           withParameters:@{@"userUuid": [User instance].userUuid, @"listUuid": list.listUuid, @"itemUuid": item.itemUuid}
//                                    block:^(NSString *results, NSError *error) {
//                                        if (!error) {
//                                            NSLog(@"Success! Deleted Item with result: %@", results);
//                                        } else {
//                                            NSLog(@"Uuid function grab error: %@", error.description);
//                                        }
//                                    }];
        
        NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:
                                     [NSIndexPath indexPathForRow:indexPath.row inSection:0],
//                                     [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0],
                                     nil];
        
        [tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (list.listItems.count == 0) {
            [self presentEmptyState];
        }
        
//        [tableView reloadData];
        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    
    Item *itemToMove = [list.listItems objectAtIndex:sourceIndexPath.row];
    [list.listItems removeObjectAtIndex:sourceIndexPath.row];
    [list.listItems insertObject:itemToMove atIndex:destinationIndexPath.row];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.itemTable setEditing:editing animated:YES];
    
    if (editing) {
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        self.editing = YES;
        [self resignFirstResponder];
        [self.itemTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        self.editing = NO;
        [self.itemTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    List *list = [[User instance].lists objectAtIndex:self.view.tag];
    
    if (self.editing) {
        
        return contentCell;
        
    } else {
    
        if (2 * list.listItems.count == indexPath.row)
            return textFieldCell;
        else if (indexPath.row % 2 == 0)
            return contentCell;
        else
            return seperatorCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self typeForRowAtIndexPath:indexPath] == contentCell) {
        
        ItemsTableViewCell *cell = (ItemsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [self evaluateSelectionWithCell:cell withIndexPath:indexPath];
        
    }
    
}

- (void)evaluateSelectionWithCell:(ItemsTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    if (CGSizeEqualToSize(cell.selectionTriangle.image.size, CGSizeZero)) {
        
        // Using the view's tag with matching array index, get the list.
        List *list = [[User instance].lists objectAtIndex:self.view.tag];
        Item *item = [list.listItems objectAtIndex:indexPath.row/2];
        
        item.isDone = YES;
        
        [self setCellDone:cell];
        
    } else {
        
        // Using the view's tag with matching array index, get the list.
        List *list = [[User instance].lists objectAtIndex:self.view.tag];
        Item *item = [list.listItems objectAtIndex:indexPath.row/2];
        
        item.isDone = NO;
        
        cell.selectionTriangle.image = nil;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kAnimation/2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        [cell.backView setBackgroundColor:[UIColor clearColor]];
        cell.backgroundColor = UIColorFromRGB(0xFFFDEC, 1);
        
        cell.doneWidthCon.constant = 0;
        [cell layoutIfNeeded];
        
        [UIView commitAnimations];
        
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
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [cell.backView setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor = UIColorFromRGB(0xAAAAAA, .28);
    
    cell.doneWidthCon.constant = 21;
    [cell layoutIfNeeded];
    
    [UIView commitAnimations];
    
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
