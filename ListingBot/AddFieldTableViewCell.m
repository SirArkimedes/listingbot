//
//  AddFieldTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/3/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "AddFieldTableViewCell.h"

@implementation AddFieldTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    // Change this.
    UIColor *color = [UIColor colorWithWhite:1 alpha:.75f];
    self.addTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add new item" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
