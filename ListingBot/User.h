//
//  User.h
//  ListingBot
//
//  Created by Andrew Robinson on 7/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userUuid;
@property (strong, nonatomic) NSMutableArray *lists;

@property (nonatomic, assign) BOOL userDidChangeAdd;
@property (nonatomic, assign) BOOL userDidChangeDelete;

@property (nonatomic, assign) BOOL didNotSaveParseUser;
@property (nonatomic, assign) BOOL userDoesNotExistOnServer;

- (id)initWithName:(NSString *)name withUUID:(NSString *)uuid withList:(NSString *)list;

- (id)init;
+ (User*)instance;

@end
