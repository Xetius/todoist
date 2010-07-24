//
//  TodoistAppDelegate.h
//  Todoist
//
//  Created by Chris Hudson on 23/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//


#import <UIKit/UIKit.h>

@class TodoistViewController;

@interface TodoistAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController* navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;


@end

