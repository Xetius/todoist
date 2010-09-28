//
//  ItemsTableViewController.h
//  Todoist
//
//  Created by Chris Hudson on 24/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class TodoistViewController;

@interface ItemsTableViewController : BaseTableViewController {

    NSInteger projectId;
	NSMutableArray* incompleteItems;
	NSMutableArray* completeItems;
	TodoistViewController* parentController;
}

@property (readwrite, assign) NSInteger projectId;
@property (nonatomic, retain) NSMutableArray* incompleteItems;
@property (nonatomic, retain) NSMutableArray* completeItems;
@property (nonatomic, retain) TodoistViewController* parentViewController;

-(NSArray*) itemsForSection:(NSInteger)section;
-(ITEMTABLECELLTYPE) cellTypeForCellAtIndexPath:(NSIndexPath*)indexPath;
-(UITableViewCell *)tableView:(UITableView *)tableView itemCellForRowAtIndexPath:(NSIndexPath *)indexPath withChildren:(bool)hasChildren;

@end