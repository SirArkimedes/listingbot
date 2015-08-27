//
//  FarLeftViewController.m
//  ListingBot
//
//  Created by Andrew Robinson on 8/14/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "FarLeftViewController.h"

#import "AddListTableViewCell.h"
#import "DraggableNewListTableViewCell.h"
#import "ThemeTableViewCell.h"
#import "ThemeDisplayView.h"
#import "WelcomeTableViewCell.h"

#import "Settings.h"
#import "Theme.h"
#import "User.h"

#define UIColorFromRGB(rgbValue, ...) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                      green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                       blue:((float)(rgbValue & 0xFF))/255.0 alpha:__VA_ARGS__]

typedef NS_ENUM(NSUInteger, cellType) {
    welcomeCell,
    addNewListCell,
    underNewSeperatorCell,
    draggableNewList,
    underDraggbleSeperatorCell,
    themeCell,
};

@interface FarLeftViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end

@implementation FarLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.settingTable.dataSource = self;
    self.settingTable.delegate =  self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshFarLeft" object:nil];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableWithNotification:(NSNotification *)notification {
    [self.settingTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if ([Settings instance].doesWantDraggable) {
        return 4;
    } else {
        return 6;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case welcomeCell:
            cell = [self setupWelcomeCellWithTableView:tableView];
            break;
        case addNewListCell:
            cell = [self setupAddNewListCellWithTableView:tableView];
            break;
        case underNewSeperatorCell:
            cell = [self setupSeperatorCellWithTableView:tableView];
            break;
        case draggableNewList:
            cell = [self setupDraggableNewListCellWithTableView:tableView];
            break;
        case underDraggbleSeperatorCell:
            cell = [self setupSeperatorCellWithTableView:tableView];
            break;
        case themeCell:
            cell = [self setupThemeCellWithTableView:tableView];
            break;
    }
    
    return cell;
}

- (UITableViewCell *)setupWelcomeCellWithTableView:(UITableView *)tableView {
    
    static NSString *welcomeCellIdentifier = @"welcomeCell";
    
    // this is a textfield cell
    WelcomeTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:welcomeCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WelcomeCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
        cell.mainHeaderText.text = @"ListingBot";
    else
        cell.mainHeaderText.text = [NSString stringWithFormat:@"Hello, %@", [User instance].userName];
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupAddNewListCellWithTableView:(UITableView *)tableView {
    
    static NSString *addNewListCellIdentifier = @"addNewList";
    
    // this is a textfield cell
    AddListTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:addNewListCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddListCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupSeperatorCellWithTableView:(UITableView *)tableView {
    
    static NSString *seperatorCellIdentifier = @"farLeftSeperator";
    
    // this is a textfield cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:seperatorCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FarLeftSeperator" owner:self options:nil] objectAtIndex:0];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupDraggableNewListCellWithTableView:(UITableView *)tableView {
    
    static NSString *draggableNewListCellIdentifier = @"draggableNewList";
    
    // this is a textfield cell
    DraggableNewListTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:draggableNewListCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DraggableNewList" owner:self options:nil] objectAtIndex:0];
    }
    
    // Set cell to actual state - Fixes the cell reloading to on or off state incorrectly
    if ([Settings instance].doesWantDraggable) {
        [cell.draggableSwitch setOn:YES animated:YES];
    } else {
        [cell.draggableSwitch setOn:NO animated:YES];
    }
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCell *)setupThemeCellWithTableView:(UITableView *)tableView {
    
    static NSString *draggableNewListCellIdentifier = @"themeSelectorCell";
    
    // this is a textfield cell
    ThemeTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:draggableNewListCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ThemeCell" owner:self options:nil] objectAtIndex:0];
    }
    
    for (int i = 1; i <= [[Settings instance].themes count]; i++) {
        
        [self layoutNewListViewWithCount:i withCell:cell];
        
    }
    
    CGFloat scrollWidth = [[Settings instance].themes count] * 166;
    CGFloat scrollHeight = cell.themeScrollView.frame.size.height;
    cell.themeScrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    
    // Forces some color somewhere to not be white, causing cells to have a white background.
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (void)layoutNewListViewWithCount:(int)i withCell:(ThemeTableViewCell *)cell {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ThemeDisplayView" owner:self options:nil];
    ThemeDisplayView *view = (ThemeDisplayView *)[nibContents objectAtIndex:0];
    
    Theme *viewTheme = [[Settings instance].themes objectAtIndex:i - 1];
    unsigned int backgroundHex = 0;
    unsigned int textHex = 0;
    
    [[NSScanner scannerWithString:viewTheme.backgroundColor] scanHexInt:&backgroundHex];
    [[NSScanner scannerWithString:viewTheme.textColor] scanHexInt:&textHex];

    view.viewBackgroundColor.backgroundColor = UIColorFromRGB(backgroundHex, 1);
    view.viewTextColor.textColor = UIColorFromRGB(textHex, 1);
    [cell.themeScrollView addSubview:view];
    
    //    UIViewController *listView = [[UIViewController alloc] initWithNibName:@"ThemeCell" bundle:nil];
    //
    //    [self.themeScrollView addSubview:listView.view];
    //    [listView didMoveToParentViewController:self];
    
    view.tag = i;
    
    // Spacially places the new view inside of the scrollview
    CGRect listFrame = view.frame;
    listFrame.origin.x = (i - 1) * 166;
    listFrame.size = CGSizeMake(166, 166);
    view.frame = listFrame;
    
}

- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Settings instance].doesWantDraggable) {
        
        switch (indexPath.row) {
            case 0:
                return welcomeCell;
                break;
            case 1:
                return draggableNewList;
                break;
            case 2:
                return underDraggbleSeperatorCell;
                break;
            case 3:
                return themeCell;
                break;
            default:
                return welcomeCell;
                break;
        }
        
    } else {
    
        switch (indexPath.row) {
            case 0:
                return welcomeCell;
                break;
            case 1:
                return addNewListCell;
                break;
            case 2:
                return underNewSeperatorCell;
                break;
            case 3:
                return draggableNewList;
                break;
            case 4:
                return underDraggbleSeperatorCell;
            case 5:
                return themeCell;
                break;
            default:
                return welcomeCell;
                break;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self typeForRowAtIndexPath:indexPath]) {
        case welcomeCell:
            return 177.f;
            break;
        case addNewListCell:
            return 44.f;
            break;
        case underNewSeperatorCell:
            return 11.f;
            break;
        case draggableNewList:
            return 44.f;
            break;
        case underDraggbleSeperatorCell:
            return 11.f;
            break;
        case themeCell:
            return 209;
            break;
        default:
            return 44.f;
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
