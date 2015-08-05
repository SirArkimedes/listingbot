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

- (id)initWithName:(NSString *)name withQuantity:(NSNumber *)quantity;

- (id)init;
+ (Item*)instance;

@end
