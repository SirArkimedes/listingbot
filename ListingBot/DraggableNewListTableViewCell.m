//
//  DraggableNewListTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "DraggableNewListTableViewCell.h"

#import "Settings.h"

@implementation DraggableNewListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    if ([Settings instance].doesWantDraggable) {
        [self.draggableSwitch setOn:YES animated:YES];
    } else {
        [self.draggableSwitch setOn:NO animated:YES];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (IBAction)draggableNewListSwitch:(id)sender {
    
    if ([sender isOn]) {
        [Settings instance].doesWantDraggable = YES;
    } else {
        [Settings instance].doesWantDraggable = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshFarLeft" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newList" object:nil userInfo:nil];
    
}

@end
