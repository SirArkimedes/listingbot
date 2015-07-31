//
//  List.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "List.h"

static List *inst = nil;

@implementation List

- (id)init {
    if(self=[super init]) {
        self.listName = @"";
        self.listUuid = @"";
        self.sharedWith = [[NSMutableArray alloc] init];
        self.listItems = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (List*)instance {
    if (!inst) {
        inst = [[List alloc] init];
    }
    return inst;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_listName forKey:@"listName"];
    [coder encodeObject:_listUuid forKey:@"listUuid"];
    [coder encodeObject:_sharedWith forKey:@"sharedWith"];
    [coder encodeObject:_listItems forKey:@"listItems"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _listName = [coder decodeObjectForKey:@"listName"];
        _listUuid = [coder decodeObjectForKey:@"listUuid"];
        _sharedWith = [coder decodeObjectForKey:@"sharedWith"];
        _listItems = [coder decodeObjectForKey:@"listItems"];
        
    }
    return self;
}

@end
