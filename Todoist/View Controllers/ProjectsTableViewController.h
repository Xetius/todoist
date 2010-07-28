//
//  ProjectsTableViewController.h
//  Todoist
//
//  Created by Chris Hudson on 24/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDataEngineDelegate.h"

@interface ProjectsTableViewController : UITableViewController<XDataEngineDelegate> {
	
	NSInteger projectId;
	NSMutableArray* projects;
}

@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, retain) NSMutableArray* projects;

@end