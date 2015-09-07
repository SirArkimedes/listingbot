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
#import "NoteBackground.h"

#import "ListViewController.h"

#define kAnimation .5f

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backView.layer.cornerRadius = 5.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNote:) name:@"removeNote" object:nil];
    
    // Setup our UIKit Dynamics
//    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview.superview.superview];
//    self.animator.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"removeNote"];
    
}

#pragma mark - Buttons

- (IBAction)notePressed:(id)sender {
    
    // Get the index of the cell where the button was pressed.
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
    
    [self createBackgroundWithIndexPath:indexPath];
    
}

- (void)createBackgroundWithIndexPath:(NSIndexPath *)indexPath {
    
    UIView *topView = self.superview.superview.superview;
    
    // Modify index to match if the table is editing or not.
    UITableView *table;
    
    for (UIView *view in [topView subviews]) {
        if ([view isKindOfClass:[UITableView class]]) {
            table = (UITableView *)view;
        }
    }
    
    NSIndexPath *index;
    
    if (table.editing) {
        index = indexPath;
    } else {
        NSIndexPath *new = [NSIndexPath indexPathForRow:indexPath.row/2 inSection:0];
        index = new;
    }
    
    // Using the view's tag with matching array index, get the list.
    List *list = [[User instance].lists objectAtIndex:topView.tag];
    
    // Divide by two because of seperator cells.
    Item *item = [list.listItems objectAtIndex:index.row];
    
    NSArray *noteBack = [[NSBundle mainBundle] loadNibNamed:@"NoteBackground"
                                                      owner:self
                                                    options:nil];
    NoteBackground *blindBackground = [noteBack objectAtIndex:0];
    blindBackground.layer.opacity = 0.f;
    blindBackground.frame = CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height);
    blindBackground.indexPath = indexPath;
    
    NotesView *note = [blindBackground createNoteWithItem:item];
    
    // Item label
    UILabel *itemLabel = [[UILabel alloc] init];
    itemLabel.text = item.itemName;
    itemLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
    itemLabel.textColor = [UIColor whiteColor];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.layer.opacity = 0.f;
    
    [blindBackground addSubview:itemLabel];
    [blindBackground addSubview:note];
    [topView addSubview:blindBackground];
    
    self.blindBackground = blindBackground;
    blindBackground.itemLabel = itemLabel;
    
    // Fade in blind
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    blindBackground.alpha = 1.f;
    blindBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.65f];
    
    [UIView commitAnimations];
    
    NSArray *array = @[itemLabel, note];
    [self performSelector:@selector(moveInItemLabelWithArrayData:) withObject:array afterDelay:kAnimation];
    
}

- (void)moveInItemLabelWithArrayData:(NSArray *)array {
    
    UILabel *label = [array objectAtIndex:0];
    NotesView *note = [array objectAtIndex:1];
    
    if (note.emptyNote.hidden == NO) {
        
        // Fade in uilabel
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kAnimation];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        note.emptyNote.alpha = 1.f;
        
        [UIView commitAnimations];
        
    }
    
    label.frame = CGRectMake(note.frame.origin.x, note.frame.origin.y - 35, 250, 30);
    
    // Fade in uilabel
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    note.textView.alpha = 1.f;
    label.alpha = 1.f;
    
    [UIView commitAnimations];
    
}

- (void)removeNote:(NSNotification *)notification {
    
    UIView *topView = self.superview.superview.superview;
    
    // Remove notes view from display.
    for (UIView *view in [[notification object] subviews]) {
        
        if (view.tag == topView.tag) {
            
            for (UIView *newView in [view subviews]) {
                
                // Fade background
                if ([newView isKindOfClass:[NoteBackground class]]) {
                    
                    // Fade out blind
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:kAnimation];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                    
                    self.blindBackground.alpha = 0.f;
                    
                    [UIView commitAnimations];
                    
                }
                
            }
            
        }
        
    }
    
}

@end
