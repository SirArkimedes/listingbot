//
//  DataHandler.h
//  ListingBot
//
//  Created by Andrew Robinson on 11/24/15.
//  Copyright © 2015 Robinson Bros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "List.h"
#import "Item.h"

typedef void (^DataHandlerCompletionBlock)(BOOL success);

@interface DataHandler : NSObject

- (void)createNewUserWithBlock:(DataHandlerCompletionBlock)completion;

- (id)init;
+ (DataHandler *)instance;

@end
