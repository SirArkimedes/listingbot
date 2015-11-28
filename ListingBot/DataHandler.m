//
//  DataHandler.m
//  ListingBot
//
//  Created by Andrew Robinson on 11/24/15.
//  Copyright © 2015 Robinson Bros. All rights reserved.
//

#import "DataHandler.h"

#import "Reachability.h"
#import <Parse/Parse.h>

static DataHandler *inst = nil;

@interface DataHandler()

@end

@implementation DataHandler

#pragma mark - init

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (DataHandler *)instance {
    if (!inst) {
        inst = [[DataHandler alloc] init];
    }
    return inst;
}

#pragma mark - Handlers

- (void)createNewUserWithBlock:(DataHandlerCompletionBlock)completion {
    
    PFObject *pUser = [PFObject objectWithClassName:@"user"];
    pUser[@"name"] = [User instance].userName;
    
    List *newList = [[User instance].lists lastObject];
    PFObject *pList = [PFObject objectWithClassName:@"list"];
    pList[@"name"] = newList.listName;
//    pList[@"owner"] = pUser;
    
    PFRelation *relation = [pList relationForKey:@"owner"];
    [relation addObject:pUser];
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.parse.com"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status != NotReachable) {
        [pUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [User instance].userID = [pUser objectId];
                [pList saveInBackgroundWithBlock:^(BOOL listSucceeded, NSError *listError) {
                    if (listSucceeded) {
                        newList.listID = [pList objectId];
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
            } else {
                // Failure queue
                completion(NO);
            }
        }];
    } else {
        // Failure queue
        completion(NO);
    }
    
}

@end
