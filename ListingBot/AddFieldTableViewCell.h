//
//  AddFieldTableViewCell.h
//  ListingBot
//
//  Created by Andrew Robinson on 8/3/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (weak, nonatomic) IBOutlet UIButton *addQuantity;
@property (weak, nonatomic) IBOutlet UIButton *subtractQuantity;

@end
