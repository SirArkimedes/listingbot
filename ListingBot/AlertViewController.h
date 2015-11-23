//
//  AlertViewController.h
//  ListingBot
//
//  Created by Andrew Robinson on 11/22/15.
//  Copyright © 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertViewController;

@protocol AlertViewControllerDelegate <NSObject>

- (void)topButtonPressedOnAlertView:(AlertViewController *)alertView;
- (void)bottomButtonPressedOnAlertView:(AlertViewController *)alertView;

@end

@interface AlertViewController : UIViewController

@property (weak, nonatomic) id<AlertViewControllerDelegate> delegate;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *redColor;

@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) UIImage *exImage;

- (void)setAlertWithTitle:(NSString *)title withButton:(NSString *)top withButton:(NSString *)bottom;
- (void)displayAlertDialog;

@end
