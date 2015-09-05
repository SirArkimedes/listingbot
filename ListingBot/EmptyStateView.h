//
//  EmptyStateView.h
//  ListingBot
//
//  Created by Andrew Robinson on 9/4/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyStateView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addItem;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (weak, nonatomic) IBOutlet UIView *itemView;

@end
