//
//  AddFieldTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/3/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "AddFieldTableViewCell.h"

#import "User.h"
#import "List.h"
#import "Item.h"

#import <Parse/Parse.h>

#define kAnimation .5f

@implementation AddFieldTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.addTextField.delegate = self;
    
    // Change this.
    UIColor *color = [UIColor colorWithWhite:1 alpha:.75f];
    self.addTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add item" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Is Empty?
    if ([textField.text isEqual:@""]) {
        
        [self.addTextField resignFirstResponder];
        
        return NO;
        
    } else {
        
        // Add textfield item to data.
        // Using the view's tag with matching array index, get the list.
        List *list = [[User instance].lists objectAtIndex:self.superview.superview.superview.tag];
        
        NSNumber *quantity = [NSNumber numberWithInt:[self.quantityLabel.text intValue]];
        
        NSString *name = textField.text;
        
        Item *newItem = [[Item alloc] initWithName:name withQuantity:quantity withUuid:nil];
        [list.listItems addObject:newItem];
        
        [PFCloud callFunctionInBackground:@"newItemId"
                           withParameters:nil
                                    block:^(NSNumber *results, NSError *error) {
                                        if (!error) {
                                            NSArray *array = @[list, newItem, name];
                                            [self performSelector:@selector(saveItemWithUuid:withData:) withObject:results withObject:array];
                                        } else {
                                            NSLog(@"Uuid function grab error: %@", error.description);
                                        }
                                    }];
        
        self.addTextField.text = @"";
        self.quantityLabel.text = @"1";
        
        // Pass the specific tableview for reloading
        UITableView *tableView = (UITableView *)self.superview.superview;
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [tableView setEditing:NO animated:YES];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:tableView userInfo:nil];
        
        return YES;
    }
}

- (void)saveItemWithUuid:(NSNumber *)uuid withData:(NSArray *)array {
    
//    List *list = [array objectAtIndex:0];
    Item *item = [array objectAtIndex:1];
    NSString *name = [array objectAtIndex:2];
    
    item.itemUuid = uuid;
    
    // Save Item
    PFObject *parseItem = [PFObject objectWithClassName:@"Items"];
    parseItem[@"name"] = name;
    parseItem[@"quantity"] = item.quantity;
//    parseItem[@"hasListUuid"] = list.listUuid;
    parseItem[@"uuid"] = uuid;
    [parseItem saveEventually];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // Move the table above the keyboard.
    List *list = [[User instance].lists objectAtIndex:self.superview.superview.superview.tag];

    UITableView *tableView = (UITableView *)self.superview.superview;
    
    [self.superview layoutIfNeeded];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Move table up
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height - 260);
    
    // Show quantitycontrol
    self.quantControlToCell.constant = 0;
    [self.superview layoutIfNeeded];
    
    [UIView commitAnimations];
    
    // Scroll table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 * list.listItems.count inSection:0];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    // Move the table back to the original position.
    [self performSelector:@selector(moveTableBack) withObject:nil afterDelay:.1f];
    
}

- (void)moveTableBack {
    
    List *list = [[User instance].lists objectAtIndex:self.superview.superview.superview.tag];
    
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    [self.superview layoutIfNeeded];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Move table back down.
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height + 260);
    
    // Remove quantitycontrol
    self.quantControlToCell.constant = -100;
    [self.superview layoutIfNeeded];
    
    [UIView commitAnimations];
    
    // Scroll table
    if (tableView.editing) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:list.listItems.count - 1 inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 * list.listItems.count inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

- (IBAction)addQuantity:(id)sender {
    
    int quantity = [self.quantityLabel.text intValue];
    quantity++;
    
    if (quantity <= 999)
        self.quantityLabel.text = [NSString stringWithFormat:@"%d", quantity];
    
}

- (IBAction)subtractQuantity:(id)sender {
    
    int quantity = [self.quantityLabel.text intValue];
    quantity--;
    
    if (quantity > 0)
        self.quantityLabel.text = [NSString stringWithFormat:@"%d", quantity];
    
}

@end
