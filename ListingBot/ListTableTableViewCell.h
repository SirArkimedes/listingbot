//
//  ListTableTableViewCell.h
//  ListingBot
//
//  Created by Andrew Robinson on 9/6/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIButton *deleteAllListsBtn;

@end
