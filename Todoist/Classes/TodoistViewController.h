//
//  TodoistViewController.h
//  Todoist
//
//  Created by Chris Hudson on 23/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectsTableViewController.h"
#import "ItemsTableViewController.h"

@interface TodoistViewController : UIViewController {

    ProjectsTableViewController* projectsTableViewController;
    ItemsTableViewController* itemsTableViewController;
    bool frontVisible;
    
}

@property (nonatomic, retain) ProjectsTableViewController* projectsTableViewController;
@property (nonatomic, retain) ItemsTableViewController* itemsTableViewController;
@property bool frontVisible;

@end

