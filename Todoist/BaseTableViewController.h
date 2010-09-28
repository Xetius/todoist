//
//  BaseTableViewController.h
//  Todoist
//
//  Created by Chris Hudson on 17/09/2010.
//  Copyright (c) 2010 Xetius Services Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDataEngineDelegate.h"

@interface BaseTableViewController : UITableViewController<XDataEngineDelegate> {
    NSString* emptyTableText;
}

-(UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)tableView:(UITableView *)tableView loadingCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, retain) NSString* emptyTableText;

@end