//
//  TodoistAppDelegate.m
//  Todoist
//
//  Created by Chris Hudson on 23/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//


#import "TodoistAppDelegate.h"

#import "TodoistViewController.h"

@implementation TodoistAppDelegate


@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    // Create Navigation Controller
    TodoistViewController* rootController = [[TodoistViewController alloc] initWithNibName:@"TodoistViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [rootController release];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [navigationController release];
    [super dealloc];
}

@end

