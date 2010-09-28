//
//  ProjectsTableViewController.h
//  Todoist
//
//  Created by Chris Hudson on 24/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class TodoistViewController;

@interface ProjectsTableViewController : BaseTableViewController {
	
	NSInteger projectId;
	NSMutableArray* projects;
	TodoistViewController* parentViewController;
}

@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, retain) NSMutableArray* projects;
@property (nonatomic, retain) TodoistViewController* parentViewController;

-(PROJECTSTABLECELLTYPE) cellTypeForCellAtIndexPath:(NSIndexPath*)indexPath;

-(UITableViewCell *)tableView:(UITableView *)tableView groupCellForRowAtIndexPath:(NSIndexPath *)indexPath withChildren:(bool)hasChildren;
-(UITableViewCell *)tableView:(UITableView *)tableView projectCellForRowAtIndexPath:(NSIndexPath *)indexPath withChildren:(bool)hasChildren;
-(UIImage*)cellImageForProjectWithCount:(NSInteger)cellCount AndColour:(UIColor*)cellColour;
-(UIImage*)cellImageForGroupWithColour:(UIColor*)cellColour;

@end