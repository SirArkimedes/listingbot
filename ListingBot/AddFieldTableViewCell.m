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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Is Empty?
    if ([textField.text isEqual:@""]) {
        
        [self.addTextField resignFirstResponder];
        
        return NO;
        
    } else {
        
        // Add textfield item to data.
        // Using the view's tag with matching array index, get the list.
        List *list = [[User instance].lists objectAtIndex:self.superview.superview.superview.tag];
        
        int quantity = [self.quantityLabel.text intValue];
        
        Item *newItem = [[Item alloc] initWithName:textField.text withQuantity:[NSNumber numberWithInt:quantity]];
        [list.listItems addObject:newItem];
        
        self.addTextField.text = @"";
        self.quantityLabel.text = @"1";
        
        UITableView *tableView = (UITableView *)self.superview.superview;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:tableView userInfo:nil];
        
        return YES;
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
