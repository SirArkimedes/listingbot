//
//  NoteBackground.h
//  ListingBot
//
//  Created by Andrew Robinson on 9/3/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesView.h"

#import "User.h"
#import "List.h"
#import "Item.h"

@interface NoteBackground : UIView <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) NotesView *note;

@property (nonatomic, strong) UIDynamicAnimator *animator;

- (NotesView *)createNoteWithIndexPath:(NSIndexPath *)indexPath;

@end
