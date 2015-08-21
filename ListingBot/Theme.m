//
//  Theme.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/20/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "Theme.h"

@implementation Theme

- (id)init {
    if(self=[super init]) {
        // This controls the settings launch state. This will be set at first launch.
        self.backgroundColor = nil;
        self.textColor = nil;
    }
    return self;
}

@end
