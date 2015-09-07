//
//  NoteBackground.m
//  ListingBot
//
//  Created by Andrew Robinson on 9/3/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "NoteBackground.h"

#define kAnimation .5f

@implementation NoteBackground

- (void)awakeFromNib {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUpItemLabel:) name:@"moveUpItem" object:nil];
    
    // Setup our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview.superview.superview];
    self.animator.delegate = self;
    
}

- (void)moveUpItemLabel:(NSNotification *)notification {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Move everything up
    self.itemLabel.frame = CGRectMake(self.itemLabel.frame.origin.x, self.itemLabel.frame.origin.y - 120, self.itemLabel.frame.size.width, self.itemLabel.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.note || touch.view == self.note.textView) {
        return NO;
    }
    
    return YES;
}

- (NotesView *)createNoteWithItem:(Item *)item {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NotesView"
                                                         owner:self
                                                       options:nil];
    NotesView *notes = [nibContents objectAtIndex:0];
    notes.frame = CGRectMake(self.frame.size.width/2 - 125, self.frame.size.height/2 - 100, 250, 200);
    notes.textView.text = item.itemNote;
    
    if ([notes.textView.text isEqualToString:@""]) {
        
        notes.emptyNote.hidden = NO;
        notes.emptyNote.alpha = 0.f;
        
    }
    
    notes.textView.editable = NO;
    
    notes.layer.cornerRadius = 5.f;
    
    self.note = notes;
    self.note.item = item;
    
    // New positions
    CGRect viewFrame = notes.frame;
    viewFrame.origin.y = -viewFrame.size.height;
    notes.frame = viewFrame;
    
    CGPoint moveToPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.note snapToPoint:moveToPoint];
    snapBehaviour.damping = 1.f;
    
    [self.animator addBehavior:snapBehaviour];
    
    return self.note;
    
}

- (void)dismissKeyboard {
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.note]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.note]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.note];
    [self.animator addBehavior:itemBehaviour];
    
    // Add note data to item.
    self.note.item.itemNote = self.note.textView.text;
    
    // Pass the specific tableview for reloading
    UITableView *tableView;
    
    for (UIView *view in [self.superview subviews]) {
        
        if ([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
        }
        
    }
    
    NSIndexPath* rowToReload = self.indexPath;
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
//    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView setEditing:NO animated:YES];
    
    [self performSelector:@selector(removeNoteEntirely:) withObject:self.note afterDelay:kAnimation];
    
//    for (UIView *inBlind in [self subviews]) {
//
//        // Drop Note
//        if ([inBlind isKindOfClass:[NotesView class]]) {
//            
//            UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[inBlind]];
//            gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
//            [self.animator addBehavior:gravityBehaviour];
//            
//            UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[inBlind]];
//            [itemBehaviour addAngularVelocity:-M_PI_2 forItem:inBlind];
//            [self.animator addBehavior:itemBehaviour];
//            
//            [self performSelector:@selector(removeNoteEntirely:) withObject:inBlind afterDelay:kAnimation];
//            
//        }
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNote" object:self.superview.superview userInfo:nil];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator {
    
    self.note.textView.editable = YES;
    
}

- (void)removeNoteEntirely:(UIView *)note {
    
    [note removeFromSuperview];
    [self.animator removeAllBehaviors];
    self.note = nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
