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
        // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

+ (DataHandler *)instance {
    if (!inst) {
        inst = [[DataHandler alloc] init];
    }
    return inst;
}

#pragma mark - Reachbility

- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability *reach = [note object];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status != NotReachable) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
            if ([[User instance].userID isEqual:@""]) {
                [self createNewUser];
            } else {
                for (List *list in [User instance].lists) {
                    if ([list.listID isEqual:@""]) {
                        [self createNewList:list];
                    }
                }
            }
        }
    }
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
    
    // Will fail out and the notification will handle not being saved.
    if (status != NotReachable) {
        [pUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [User instance].userID = [pUser objectId];
                [User instance].parseUser = pUser;
                [pList saveInBackgroundWithBlock:^(BOOL listSucceeded, NSError *listError) {
                    if (listSucceeded) {
                        newList.listID = [pList objectId];
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
            } else {
                completion(NO);
            }
        }];
    } else {
        completion(NO);
    }
}

- (void)createNewUser {
    
    PFObject *pUser = [PFObject objectWithClassName:@"user"];
    pUser[@"name"] = [User instance].userName;
    
    // Will fail out and the notification will handle not being saved.
    [pUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [User instance].userID = [pUser objectId];
            [User instance].parseUser = pUser;
        }
    }];
}

- (void)createNewList:(List *)list {
    
    PFObject *pList = [PFObject objectWithClassName:@"list"];
    pList[@"name"] = list.listName;
    
    PFRelation *relation = [pList relationForKey:@"owner"];
    [relation addObject:[User instance].parseUser];
    
}

@end
