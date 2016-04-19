//
//  List.h
//  ListingBot
//
//  Created by Andrew Robinson on 7/31/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject

@property (strong, nonatomic) NSString *listName;
@property (strong, nonatomic) NSString *listID;
@property (strong, nonatomic) NSMutableArray *listItems;

- (id)init;
+ (List*)instance;

@end
