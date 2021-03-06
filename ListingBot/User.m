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
        self.userID = @"";
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
        _userName = name;
        _userID = list;
        _lists = [[NSMutableArray alloc] init];
        [_lists addObject:list];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_userName forKey:@"userName"];
    [coder encodeObject:_userID forKey:@"userID"];
    [coder encodeObject:_lists forKey:@"lists"];
    
    [coder encodeBool:_didNotSaveParseUser forKey:@"didNotSaveParseUser"];
    [coder encodeBool:_userDoesNotExistOnServer forKey:@"userDoesNotExistOnServer"];
    
    [coder encodeBool:_userDidChangeAdd forKey:@"userDidChangeAdd"];
    [coder encodeBool:_userDidChangeDelete forKey:@"userDidChangeDelete"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _userName = [coder decodeObjectForKey:@"userName"];
        _userID = [coder decodeObjectForKey:@"userID"];
        _lists = [coder decodeObjectForKey:@"lists"];
        
        _didNotSaveParseUser = [coder decodeBoolForKey:@"didNoteSaveParseUser"];
        _userDoesNotExistOnServer = [coder decodeBoolForKey:@"userDoesNotExistOnServer"];
        
        _userDidChangeAdd = [coder decodeBoolForKey:@"userDidChangeAdd"];
        _userDidChangeDelete = [coder decodeBoolForKey:@"userDidChangeDelete"];
        
    }
    return self;
}

@end
