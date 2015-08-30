//
//  ItemsTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/2/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ItemsTableViewCell.h"

#import "User.h"
#import "List.h"
#import "Item.h"

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backView.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Buttons

- (IBAction)notePressed:(id)sender {
    
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:self.superview.superview.superview.tag];
    
    // Get the index of the cell where the button was pressed.
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
    
}

@end
