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

#import "ListViewController.h"

#define kAnimation .5f

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backView.layer.cornerRadius = 5.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNote:) name:@"removeNote" object:nil];
    
    // Setup our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview.superview.superview];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"removeNote"];
    
}

- (void)removeNoteEntirely:(UIView *)note {
    
    [note removeFromSuperview];
    
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
    NotesView *notes = [nibContents objectAtIndex:0];
    notes.frame = CGRectMake(topView.frame.size.width/2 - 125, topView.frame.size.height/2 - 100, 250, 200);
    notes.textView.text = item.itemNote;
    
    [topView addSubview:notes];
    
    // New positions
    CGRect viewFrame = notes.frame;
    viewFrame.origin.y = -viewFrame.size.height;
    notes.frame = viewFrame;
    
    CGPoint moveToPoint = CGPointMake(topView.frame.size.width/2, topView.frame.size.height/2);
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:notes snapToPoint:moveToPoint];
    snapBehaviour.damping = 1.f;
    [self.animator addBehavior:snapBehaviour];
    
}

- (void)removeNote:(NSNotification *)notification {
    
    UIView *topView = self.superview.superview.superview;
    
    // Remove notes view from display.
    for (UIView *view in [[notification object] subviews]) {
        
        if (view.tag == topView.tag) {
            
            for (UIView *newView in [view subviews]) {
                
                if ([newView isKindOfClass:[NotesView class]]) {
                    
                    [self.animator removeAllBehaviors];
                    
                    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[newView]];
                    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
                    [self.animator addBehavior:gravityBehaviour];
                    
                    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[newView]];
                    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:newView];
                    [self.animator addBehavior:itemBehaviour];
                    
                    [self performSelector:@selector(removeNoteEntirely:) withObject:newView afterDelay:kAnimation];
                }
                
            }
            
        }
        
    }
    
}

@end
