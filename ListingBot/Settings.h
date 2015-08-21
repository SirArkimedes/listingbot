//
//  Settings.h
//  ListingBot
//
//  Created by Andrew Robinson on 8/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic, assign) BOOL doesWantDraggable;

@property (strong, nonatomic) NSMutableArray *themes;

- (id)init;
+ (Settings*)instance;

@end
