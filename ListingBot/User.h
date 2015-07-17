//
//  User.h
//  ListingBot
//
//  Created by Andrew Robinson on 7/17/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSMutableArray *lists;

- (id)initWithName:(NSString *)name withUUID:(NSString *)uuid withList:(NSString *)list;

- (id)init;
+ (User*)instance;

@end
