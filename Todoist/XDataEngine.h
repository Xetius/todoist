//
//  XDataEngine.h
//  Todoist
//
//  Created by Chris Hudson on 20/03/2010.
//  Copyright 2010 Xetius Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON/JSON.h"
#import "MessageObjects.h"
#import "XDataEngineDelegate.h"
#import "XConnectionHandler.h"

#pragma mark -
#pragma mark XDataEngine definition

@interface XDataEngine : NSObject {
	NSMutableDictionary* userDetails;
	NSMutableArray* labels;
	NSMutableArray* projects;
	NSMutableDictionary* incompleteItems;
	NSMutableDictionary* completeItems;
}

+(XDataEngine*) sharedDataEngine;
-(NSMutableDictionary*) userDetailsWithDelegate:(NSObject<XDataEngineDelegate>*)delegate;
-(NSMutableArray*) labelsWithDelegate:(NSObject<XDataEngineDelegate>*)delegate;
-(NSMutableArray*) projectsForProjectId:(NSInteger)projectId WithDelegate:(NSObject<XDataEngineDelegate>*)delegate;
-(NSMutableArray*) incompleteItemsForProjectId:(NSInteger)projectId WithDelegate:(NSObject<XDataEngineDelegate>*)delegate;
-(NSMutableArray*) completeItemsForProjectId:(NSInteger)projectId WithDelegate:(NSObject<XDataEngineDelegate>*)delegate;

-(void) initProjects:(NSObject<XDataEngineDelegate>*) delegate;
-(void) initIncompleteItems:(MessageObjects*)messageObjects;
-(void) initCompleteItems:(MessageObjects*)messageObjects;
-(void) calculateHasChildren:(NSMutableArray*)aList;

@property (nonatomic, retain) NSMutableDictionary* userDetails;
@property (nonatomic, retain) NSMutableArray* labels;
@property (nonatomic, retain) NSMutableArray* projects;
@property (nonatomic, retain) NSMutableDictionary* incompleteItems;
@property (nonatomic, retain) NSMutableDictionary* completeItems;

@end
