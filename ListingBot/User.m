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
        self.userName = @"";
        self.userUuid = @"";
        self.lists = [[NSMutableArray alloc] init];
        self.listQueue = [[NSMutableArray alloc] init];
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
        _userName = name;
        _userUuid = list;
        _lists = [[NSMutableArray alloc] init];
        [_lists addObject:list];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_userName forKey:@"userName"];
    [coder encodeObject:_userUuid forKey:@"userUuid"];
    [coder encodeObject:_lists forKey:@"lists"];
    
    [coder encodeBool:_userDidChange forKey:@"userDidChange"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _userName = [coder decodeObjectForKey:@"userName"];
        _userUuid = [coder decodeObjectForKey:@"userUuid"];
        _lists = [coder decodeObjectForKey:@"lists"];
        
        _userDidChange = [coder decodeBoolForKey:@"userDidChange"];
        
    }
    return self;
}

@end
