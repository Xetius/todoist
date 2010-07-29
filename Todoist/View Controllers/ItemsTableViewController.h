//
//  ItemsTableViewController.h
//  Todoist
//
//  Created by Chris Hudson on 24/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDataEngineDelegate.h"

@class TodoistViewController;

@interface ItemsTableViewController : UITableViewController<XDataEngineDelegate> {

    NSInteger projectId;
	NSMutableArray* incompleteItems;
	NSMutableArray* completeItems;
	TodoistViewController* parentController;
}

@property (readwrite, assign) NSInteger projectId;
@property (nonatomic, retain) NSMutableArray* incompleteItems;
@property (nonatomic, retain) NSMutableArray* completeItems;
@property (nonatomic, retain) TodoistViewController* parentViewController;

@end