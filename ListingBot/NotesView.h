//
//  NotesView.h
//  ListingBot
//
//  Created by Andrew Robinson on 8/30/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "Item.h"

@interface NotesView : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) Item *item;

@end
