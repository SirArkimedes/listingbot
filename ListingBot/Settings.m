//
//  Settings.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "Settings.h"

static Settings *inst = nil;

@implementation Settings

- (id)init {
    if(self=[super init]) {
        
    }
    return self;
}

+ (Settings*)instance {
    if (!inst) {
        inst = [[Settings alloc] init];
    }
    return inst;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeBool:_doesWantDraggable forKey:@"doesWantDraggable"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _doesWantDraggable = [coder decodeBoolForKey:@"doesWantDraggable"];
        
    }
    return self;
}

@end
