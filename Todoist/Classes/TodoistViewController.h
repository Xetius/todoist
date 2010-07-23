//
//  TodoistViewController.h
//  Todoist
//
//  Created by Chris Hudson on 23/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectViewController.h"
#import "ItemViewController.h"

@interface TodoistViewController : UIViewController {

    ProjectViewController* projectViewController;
    ItemViewController* itemViewController;
    bool frontVisible;
    
}

@property (nonatomic, retain) ProjectViewController* projectViewController;
@property (nonatomic, retain) ItemViewController* itemViewController;
@property bool frontVisible;

@end

