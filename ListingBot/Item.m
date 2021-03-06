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
        self.itemUuid = nil;
        self.isDone = NO;
        self.itemNote = nil;
    }
    return self;
}

+ (Item*)instance {
    if (!inst) {
        inst = [[Item alloc] init];
    }
    return inst;
}

- (id)initWithName:(NSString *)name withQuantity:(NSNumber *)quantity withUuid:(NSNumber *)uuid {
    
    if(self=[super init]) {
        
        self.itemName = name;
        self.quantity = quantity;
        self.itemUuid = uuid;
        self.isDone = NO;
        self.itemNote = nil;
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_itemName forKey:@"itemName"];
    [coder encodeObject:_quantity forKey:@"quantity"];
    [coder encodeObject:_itemUuid forKey:@"itemUuid"];
    [coder encodeBool:_isDone forKey:@"isDone"];
    [coder encodeObject:_itemNote forKey:@"itemNote"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _quantity = [coder decodeObjectForKey:@"quantity"];
        _itemUuid = [coder decodeObjectForKey:@"itemUuid"];
        _isDone = [coder decodeBoolForKey:@"isDone"];
        _itemNote = [coder decodeObjectForKey:@"itemNote"];
        
    }
    return self;
}

@end
