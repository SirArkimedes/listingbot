//
//  EmptyStateView.m
//  ListingBot
//
//  Created by Andrew Robinson on 9/4/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "EmptyStateView.h"

#import "User.h"
#import "List.h"
#import "Item.h"

#define kAnimation .5f

@implementation EmptyStateView

- (void)awakeFromNib {
    
    self.addItem.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tap];
    
    UIColor *color = [UIColor colorWithWhite:1 alpha:.75f];
    self.addItem.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add item" attributes:@{NSForegroundColorAttributeName: color}];
    
    // Set to not ediable to avoid exception
    self.addItem.enabled = NO;
    
}

- (void)dismissKeyboard {
    
    [self.addItem resignFirstResponder];
    
}

#pragma mark - Buttons

- (IBAction)addQuantity:(id)sender {
    
    int quantity = [self.quantityLabel.text intValue];
    quantity++;
    
    if (quantity <= 999)
        self.quantityLabel.text = [NSString stringWithFormat:@"%d", quantity];
    
}

- (IBAction)subtractQuntity:(id)sender {
    
    int quantity = [self.quantityLabel.text intValue];
    quantity--;
    
    if (quantity > 0)
        self.quantityLabel.text = [NSString stringWithFormat:@"%d", quantity];
    
}

#pragma mark - Textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Is Empty?
    if ([textField.text isEqual:@""]) {
        
        [self.addItem resignFirstResponder];
        
        return NO;
        
    } else {
        
        // Add textfield item to data.
        // Using the view's tag with matching array index, get the list.
        List *list = [[User instance].lists objectAtIndex:self.superview.tag];
        
        NSNumber *quantity = [NSNumber numberWithInt:[self.quantityLabel.text intValue]];
        
        NSString *name = textField.text;
        
        Item *newItem = [[Item alloc] initWithName:name withQuantity:quantity withUuid:nil];
        [list.listItems addObject:newItem];
        
        self.addItem.text = @"";
        self.quantityLabel.text = @"1";
        
        // Pass the specific tableview for reloading
        UITableView *tableView;
        
        for (UIView *view in [self.superview subviews]) {
            
            if ([view isKindOfClass:[UITableView class]]) {
                tableView = (UITableView *)view;
            }
            
            if ([view isKindOfClass:[self class]]) {
                
                [self.addItem resignFirstResponder];
                
                // Fade out self
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:kAnimation];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                
                self.alpha = 0.f;
                
                [UIView commitAnimations];
                
            }
            
        }
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [tableView setEditing:NO animated:YES];
        
        // Pass to tables
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noLongerEmpty" object:nil userInfo:nil];
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:tableView userInfo:nil];
        
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    // Move up
    self.itemView.frame = CGRectMake(self.itemView.frame.origin.x, self.itemView.frame.origin.y - 60, self.itemView.frame.size.width, self.itemView.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    // Move down
    self.itemView.frame = CGRectMake(self.itemView.frame.origin.x, self.itemView.frame.origin.y + 60, self.itemView.frame.size.width, self.itemView.frame.size.height);
    
    [UIView commitAnimations];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
