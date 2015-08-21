//
//  ThemeTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/19/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ThemeTableViewCell.h"

@implementation ThemeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    // Generate views based on how many lists we have.
//    for (int i = 1; i <= 3; i++) {
//        
//        [self layoutNewListViewWithCount:i];
//        
//    }
//    
//    CGFloat scrollWidth = 3 * 166;
//    CGFloat scrollHeight = self.themeScrollView.frame.size.height;
//    self.themeScrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutNewListViewWithCount:(int)i {
//    
//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ThemeCell" owner:self options:nil];
//    UIView *view = [nibContents objectAtIndex:0];
//    [self.themeScrollView addSubview:view];
//    
////    UIViewController *listView = [[UIViewController alloc] initWithNibName:@"ThemeCell" bundle:nil];
////    
////    [self.themeScrollView addSubview:listView.view];
////    [listView didMoveToParentViewController:self];
//    
//    view.tag = i - 1;
//    
//    // Spacially places the new view inside of the scrollview
//    CGRect listFrame = view.frame;
//    listFrame.origin.x = (i) * 166;
//    listFrame.size = CGSizeMake(166, 166);
//    view.frame = listFrame;
//    
//}

@end
