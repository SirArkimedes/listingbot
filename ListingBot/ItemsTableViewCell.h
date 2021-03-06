//
//  ItemsTableViewCell.h
//  ListingBot
//
//  Created by Andrew Robinson on 8/2/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesView.h"

@interface ItemsTableViewCell : UITableViewCell <UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneWidthCon;

@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantity;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;

@property (weak, nonatomic) IBOutlet UIView *selectionBubble;
@property (weak, nonatomic) IBOutlet UIView *isSelectedBubble;
@property (weak, nonatomic) IBOutlet UIImageView *selectionTriangle;

@property (weak, nonatomic) IBOutlet UIView *backView;

//@property (strong, nonatomic) NotesView *note;
@property (strong, nonatomic) UIView *blindBackground;

//@property (nonatomic, strong) UIDynamicAnimator *animator;

@end
