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

#import "NotesView.h"

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backView.layer.cornerRadius = 5.f;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNote:) name:@"removeNote" object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)removeNote:(NSNotification *)notification {
    
    UIView *topView = self.superview.superview.superview;
    
    // Remove notes view from display. 
    for (UIView *view in [[notification object] subviews]) {
        
        if (view.tag == topView.tag) {
            
            for (UIView *newView in [view subviews]) {
                
                if ([newView isKindOfClass:[NotesView class]]) {
                    [newView removeFromSuperview];
                }
                
            }
            
        }
        
    }
    
}

#pragma mark - Buttons

- (IBAction)notePressed:(id)sender {
    
    // Get the index of the cell where the button was pressed.
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
    
    UIView *topView = self.superview.superview.superview;
    
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:topView.tag];
    
    // Divide by two because of seperator cells.
    Item *item = [list.listItems objectAtIndex:indexPath.row/2];
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NotesView"
                                                         owner:self
                                                       options:nil];
    NotesView *notesView = [nibContents objectAtIndex:0];
    notesView.frame = CGRectMake(topView.frame.size.width/2 - 100, topView.frame.size.height/2 - 100, 200, 200);
    notesView.notesLabel.text = item.itemNote;
    
    [topView addSubview:notesView];
        
}

@end
