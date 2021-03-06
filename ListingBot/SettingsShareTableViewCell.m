//
//  SettingsShareTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/15/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "SettingsShareTableViewCell.h"

@implementation SettingsShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.shareCopyButton.layer.cornerRadius = 5.f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Buttons

- (IBAction)shareCopyButtonPress:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareCopyButton.titleLabel.text;
    
}

@end
