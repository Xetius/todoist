//
//  MessageObjects.h
//  Todoist
//
//  Created by Chris Hudson on 01/06/2010.
//  Copyright 2010 Xetius Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDataEngineDelegate.h"

@interface MessageObjects : NSObject {
	NSObject<XDataEngineDelegate>* delegate;
	NSInteger projectId;
}

@property (nonatomic, retain) NSObject<XDataEngineDelegate>* delegate;
@property NSInteger projectId;

@end
