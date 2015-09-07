//
//  ListTableTableViewCell.m
//  ListingBot
//
//  Created by Andrew Robinson on 9/6/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "ListTableTableViewCell.h"

#import "User.h"
#import "List.h"

#define kAnimation .5f

@implementation ListTableTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    
    [self.listTable setEditing:YES animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Buttons

- (IBAction)deleteAllLists:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayDeleteContainer" object:nil userInfo:nil];
    
}

#pragma mark - Tableview delegates and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[User instance].lists count] == 0) {
        return 1;
    }
    
    return [[User instance].lists count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *listTableCell = @"";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listTableCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listTableCell];
    }
    
    if ([[User instance].lists count] == 0) {
        
        cell.textLabel.layer.opacity = 0.f;
        cell.textLabel.text = @"No Lists to display!";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.f];
        
        [self.listTable setEditing:NO animated:YES];
        
        // Fade duh button - Fade in textlabel
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kAnimation];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.deleteAllListsBtn.alpha = 0.f;
        cell.textLabel.layer.opacity = 1.f;
        
        [UIView commitAnimations];
        
        // Hide duh button
//        self.deleteAllListsBtn.hidden = YES;
        
    } else {
    
        List *list = [[User instance].lists objectAtIndex:indexPath.row];
        
        cell.textLabel.text = list.listName;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.f];
    
    }

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

// Removes swiping to delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Disable swipe to delete
    if (self.listTable.editing)
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        List *list = [[User instance].lists objectAtIndex:indexPath.row];
        
        [[User instance].lists removeObject:list];
                
        [self saveUserObject:[User instance] key:@"user"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeListTable" object:nil userInfo:nil];
        
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // Did move cell
    List *sourceList = [[User instance].lists objectAtIndex:sourceIndexPath.row];
    
    [[User instance].lists removeObjectAtIndex:sourceIndexPath.row];
    [[User instance].lists insertObject:sourceList atIndex:destinationIndexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeListTable" object:nil userInfo:nil];
    
}

#pragma mark - Save

- (void)saveUserObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

@end
