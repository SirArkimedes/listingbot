//
//  AppDelegate.m
//  ListingBot
//
//  Created by Andrew Robinson on 7/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

#import "User.h"
#import "List.h"
#import "Item.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // TODO: REMOVE
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
    
    // Grab Keys
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ParseKeys" ofType:@"plist"];
    NSDictionary *plistData = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *appKey = [plistData objectForKey:@"ApplicationID"];
    NSString *clientKey = [plistData objectForKey:@"ClientKey"];
    
    if ([appKey isEqual: @""] || [clientKey isEqual: @""]) {
        NSLog(@"Parse ApplicationId and clientKey do not exist!");
    } else {
        // Enabling Parse
        [Parse setApplicationId:appKey
                      clientKey:clientKey];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] isKindOfClass:[User class]]) {
        
        User *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        
        // Not equal to nothing
        [PFCloud callFunctionInBackground:@"newUserId"
                           withParameters:nil
                                    block:^(NSNumber *results, NSError *error) {
                                        if (!error) {
                                            [self performSelector:@selector(saveUserWithData:withUUID:) withObject:user withObject:results];
                                        } else {
                                            NSLog(@"Uuid function grab error: %@", error.description);
                                        }
                                    }];
        
    }
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    // Creates 1 User, 2 Lists, and 4 Items in total.
    User *newUser = [[User alloc] init];
    newUser.userName = @"Andrew Robinson";
    newUser.userUuid = @"1234567890";
    
    // List
    List *firstList = [[List alloc] init];
    firstList.listName = @"San Francisco";
    firstList.listUuid = @"1234567891";
    NSArray *firstShared = @[@"Tim", @"Nancy"];
    [firstList.sharedWith addObjectsFromArray:firstShared];
    
    // Items
    Item *firstItem = [[Item alloc] init];
    firstItem.itemName = @"Phone";
    firstItem.quantity = [NSNumber numberWithInteger:1];
    
    Item *secondItem = [[Item alloc] init];
    secondItem.itemName = @"Soap";
    secondItem.quantity = [NSNumber numberWithInteger:3];
    
    // Add created items to list
    NSArray *firstItems = @[firstItem, secondItem];
    [firstList.listItems addObjectsFromArray:firstItems];
    
    List *secondList = [[List alloc] init];
    secondList.listName = @"Shopping";
    secondList.listUuid = @"1234567891";
    NSArray *secondShared = @[@"Matthew", @"Kai"];
    [firstList.sharedWith addObjectsFromArray:secondShared];
    
    Item *thirdItem = [[Item alloc] init];
    thirdItem.itemName = @"Milk";
    thirdItem.quantity = [NSNumber numberWithInteger:2];
    
    Item *fourthItem = [[Item alloc] init];
    fourthItem.itemName = @"Paper";
    fourthItem.quantity = [NSNumber numberWithInteger:21];
    
    Item *fifthItem = [[Item alloc] init];
    fifthItem.itemName = @"Chocolate";
    fifthItem.quantity = [NSNumber numberWithInteger:4];
    
    NSArray *secondItems = @[thirdItem, fourthItem, fifthItem];
    [secondList.listItems addObjectsFromArray:secondItems];
    
    NSArray *newLists = @[firstList, secondList];
    [newUser.lists addObjectsFromArray:newLists];
    
    // Add to instance for safe keeping
    [User instance].userName = newUser.userName;
    [User instance].userUuid = newUser.userUuid;
    [User instance].lists = newUser.lists;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"] != nil) {
        
        User *user = [self loadCustomObjectWithKey:@"user"];
        
        [User instance].userName = user.userName;
        [User instance].userUuid = user.userUuid;
        [User instance].lists= user.lists;
        
        // Not equal to nothing
        [PFCloud callFunctionInBackground:@"newUserId"
                           withParameters:nil
                                    block:^(NSNumber *results, NSError *error) {
                                        if (!error) {
                                            [self performSelector:@selector(saveUserWithData:withUUID:) withObject:user withObject:results];
                                        } else {
                                            NSLog(@"Uuid function grab error: %@", error.description);
                                        }
                                    }];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)saveUserWithData:(User*)user withUUID:(NSNumber*)uuid {
    
    PFObject *parseUser = [PFObject objectWithClassName:@"ListUsers"];
    parseUser[@"name"] = user.userName;
    parseUser[@"uuid"] = uuid;
    parseUser[@"lists"] = user.lists;
    [parseUser saveEventually];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user"];
    
}

- (void)saveCustomObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (User *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    User *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "org.andrewrobinson.ListingBot" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ListingBot" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ListingBot.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
