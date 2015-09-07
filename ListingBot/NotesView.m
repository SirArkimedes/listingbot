//
//  NotesView.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/30/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "NotesView.h"

#define kAnimation .5f

@implementation NotesView

- (void)awakeFromNib {
    
    self.textView.delegate = self;
    
}

#pragma mark - TextView delegates

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    // Post notif to move label up
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moveUpItem" object:nil userInfo:nil];
    
    if (self.emptyNote.hidden == NO)
        self.emptyNote.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Move everything up
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 120, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimation/2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Move everything up
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 120, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
