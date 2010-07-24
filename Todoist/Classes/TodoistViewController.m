//
//  TodoistViewController.m
//  Todoist
//
//  Created by Chris Hudson on 23/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import "TodoistViewController.h"

@implementation TodoistViewController

@synthesize projectsTableViewController;
@synthesize itemsTableViewController;
@synthesize frontVisible;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Added a comment here
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    projectsTableViewController = (ProjectsTableViewController*)[[ProjectsTableViewController alloc] initWithNibName:@"ProjectsTableViewController" bundle:nil];
	[self.view addSubview:projectsTableViewController.view];
	
	itemsTableViewController = [[ItemsTableViewController alloc] initWithNibName:@"ItemsTableViewController" bundle:nil];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
