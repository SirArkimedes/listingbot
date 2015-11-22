//
//  AlertView.h
//  ListingBot
//
//  Created by Andrew Robinson on 11/21/15.
//  Copyright © 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertView;

@protocol AlertViewDelegate <NSObject>

- (void)topButtonPressedOnAlertView:(AlertView *)alertView;
- (void)bottomButtonPressedOnAlertView:(AlertView *)alertView;

@end

@interface AlertView : UIView

@property (weak, nonatomic) id<AlertViewDelegate> delegate;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *redColor;

@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) UIImage *exImage;

- (void)setAlertWithTitle:(NSString *)title withButton:(NSString *)top withButton:(NSString *)bottom;

@end
