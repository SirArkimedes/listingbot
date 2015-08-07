//
//  ItemsTableViewCell.h
//  ListingBot
//
//  Created by Andrew Robinson on 8/2/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantity;

@property (weak, nonatomic) IBOutlet UIView *selectionBubble;
@property (weak, nonatomic) IBOutlet UIView *isSelectedBubble;
@property (weak, nonatomic) IBOutlet UIImageView *selectionTriangle;

@end
