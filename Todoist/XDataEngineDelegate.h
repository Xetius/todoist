//
//  XDataEngineDelegate.h
//  Todoist
//
//  Created by Chris Hudson on 01/06/2010.
//  Copyright 2010 Xetius Software. All rights reserved.
//

#pragma mark -
#pragma mark XDataEngineDelegate definition

@protocol XDataEngineDelegate

-(void)dataHasLoaded:(int)requestType;

@end
