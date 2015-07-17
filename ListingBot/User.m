//
//  User.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "User.h"

static User *inst = nil;

@implementation User

- (id)init {
    if(self=[super init]) {
        self.name = @"";
        self.uuid = @"";
        self.lists = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (User*)instance {
    if (!inst) {
        inst = [[User alloc] init];
    }
    return inst;
}

- (id)initWithName:(NSString *)name withUUID:(NSString *)uuid withList:(NSString *)list {
    
    if (self = [super init]) {
        _name = name;
        _uuid = list;
        _lists = [[NSMutableArray alloc] init];
        [_lists addObject:list];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_uuid forKey:@"uuid"];
    [coder encodeObject:_lists forKey:@"lists"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _name = [coder decodeObjectForKey:@"name"];
        _uuid = [coder decodeObjectForKey:@"uuid"];
        _lists = [coder decodeObjectForKey:@"lists"];
        
    }
    return self;
}

@end
