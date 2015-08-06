//
//  Item.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "Item.h"

static Item *inst = nil;

@implementation Item

- (id)init {
    if(self=[super init]) {
        self.itemName = @"";
        self.quantity = nil;
        self.isDone = NO;
    }
    return self;
}

+ (Item*)instance {
    if (!inst) {
        inst = [[Item alloc] init];
    }
    return inst;
}

- (id)initWithName:(NSString *)name withQuantity:(NSNumber *)quantity {
    
    if(self=[super init]) {
        
        self.itemName = name;
        self.quantity = quantity;
        self.isDone = NO;
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_itemName forKey:@"itemName"];
    [coder encodeObject:_quantity forKey:@"quantity"];
    [coder encodeBool:_isDone forKey:@"isDone"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _quantity = [coder decodeObjectForKey:@"quantity"];
        _isDone = [coder decodeBoolForKey:@"isDone"];
        
    }
    return self;
}

@end
