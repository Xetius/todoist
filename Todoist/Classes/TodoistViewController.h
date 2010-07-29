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

typedef enum {
	CONTROLLERTYPEPROJECTS,
	CONTROLLERTYPEITEMS
} CONTROLLERTYPE;

@interface TodoistViewController : UIViewController {

	NSInteger projectId;
	UIButton* flipTableButton;
    ProjectsTableViewController* projectsTableViewController;
    ItemsTableViewController* itemsTableViewController;
    bool frontVisible;
    
}

@property (readwrite, assign) NSInteger projectId;
@property (nonatomic, retain) UIButton* flipTableButton;
@property (nonatomic, retain) ProjectsTableViewController* projectsTableViewController;
@property (nonatomic, retain) ItemsTableViewController* itemsTableViewController;
@property bool frontVisible;

-(void)flipCurrentView;
-(id) initWithProjectId:(NSInteger) pId;
-(void) pushViewController:(CONTROLLERTYPE)controllerType projectId:(NSInteger)pId;

@end

