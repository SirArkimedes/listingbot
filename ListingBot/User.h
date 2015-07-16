//
//  User.h
//  ListingBot
//
//  Created by Andrew Robinson on 7/16/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSNumber *uuid;

- (void)setUsername:(NSString *)username;
- (void)setUuid:(NSNumber *)uuid;

@end
