//
//  ItemsTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/2/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ItemsTableViewCell.h"

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
