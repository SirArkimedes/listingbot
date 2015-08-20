//
//  AddListTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "AddListTableViewCell.h"

@implementation AddListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Buttons

- (IBAction)createNewList:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createNewList" object:nil userInfo:nil];
    
}

@end
