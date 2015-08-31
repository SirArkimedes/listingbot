//
//  Item.h
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSNumber *itemUuid;
@property (strong, nonatomic) NSString *itemNote;
@property BOOL isDone;

- (id)initWithName:(NSString *)name withQuantity:(NSNumber *)quantity withUuid:(NSNumber *)uuid;

- (id)init;
+ (Item*)instance;

@end
