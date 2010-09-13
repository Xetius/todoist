//
//  XDataEngine.m
//  Todoist
//
//  Created by Chris Hudson on 20/03/2010.
//  Copyright 2010 Xetius Software. All rights reserved.
//

#import "XDataEngine.h"
#import "JSON/JSON.h"

static XDataEngine* sharedDataEngine = nil;

@implementation XDataEngine

@synthesize userDetails;
@synthesize labels;
@synthesize projects;
@synthesize incompleteItems;
@synthesize completeItems;
@synthesize loadingDictionary;
@synthesize incompleteItemsAreLoading;
@synthesize completeItemsAreLoading;
@synthesize userDetailsAreLoading;
@synthesize labelsAreLoading;

#pragma mark -
#pragma mark XDataEngine methods
-(NSMutableDictionary*) userDetailsWithDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	if (self.userDetails) {
		return self.userDetails;
	}
	else {
		return nil;
	}
}

-(NSMutableArray*) labelsWithDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	if (self.labels) {
		return self.labels;
	}
	else {
		return nil;
	}

}

-(NSMutableArray*) projectsForProjectId:(NSInteger)projectId WithDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	DLog(@"projectsWithDelegate");
	NSMutableArray* returnArray = [[NSMutableArray alloc] initWithCapacity:0];
	if (self.projects) {

        [self setIsLoading:DATATYPEPROJECTS withBoolean:false];
		Boolean wantThese = (projectId == 0)?YES:NO;
		NSInteger requiredLevel = 1;
		for (NSDictionary* projectItem in self.projects) {
			NSInteger itemProjectId = [[projectItem objectForKey:@"id"] intValue];
			NSInteger itemLevel = [[projectItem objectForKey:@"indent"] intValue];
			
			DLog (@"%d, %d", itemProjectId, itemLevel);
			
			if (wantThese) {
				if (itemLevel == requiredLevel) {
					NSString* hasChildrenBool = [[projectItem objectForKey:@"hasChildren"]boolValue] ? @"YES" : @"NO";
					DLog(@"Level Matched, adding to array... hasChildren %@", hasChildrenBool);
		
					[returnArray addObject:projectItem];
				}
				else if (itemLevel < requiredLevel){
					DLog(@"Level lower than required.  We are out of that branch... Leave loop.");
					wantThese = NO;
					break;	
				}
				else {
					DLog(@"Level higher than required... skipping");
				}
			}
			else {
				if (itemProjectId == projectId) {
					wantThese = YES;
					requiredLevel = itemLevel + 1; 
				}
			}

		}
		
		DLog(@"Projects not nil, returning projects");
		return [returnArray autorelease];
	}
	else {
		DLog(@"Projects are nil, setting selector to perform initProjects in 3 seconds");
		[self setIsLoading:DATATYPEPROJECTS withBoolean:true];
		[self performSelector:@selector(initProjects:) withObject:delegate afterDelay:1];
		
		return nil;
	}
}

-(NSMutableArray*) incompleteItemsForProjectId:(NSInteger)projectId WithDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	if (self.incompleteItems != nil) {
		NSMutableArray* itemsForProject = [self.incompleteItems objectForKey:[NSNumber numberWithInt:projectId]];
		if (itemsForProject != nil) {
			return itemsForProject;
		}
	}
	else {
		self.incompleteItems = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	
	MessageObjects* messageObject = [[[MessageObjects alloc] init] autorelease];
	messageObject.delegate = delegate;
	messageObject.projectId = projectId;
	
	[self performSelector:@selector(initIncompleteItems:) withObject:messageObject afterDelay:2];
	return nil;
}

-(NSMutableArray*) completeItemsForProjectId:(NSInteger)projectId WithDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	if (self.completeItems != nil) {
		NSMutableArray* itemsForProject = [self.completeItems objectForKey:[NSNumber numberWithInt:projectId]];
		if (itemsForProject != nil) {
			return itemsForProject;
		}
	}
	else {
		self.completeItems = [[NSMutableDictionary alloc] initWithCapacity:1];
	}

	
	MessageObjects* messageObject = [[[MessageObjects alloc] init] autorelease];
	messageObject.delegate = delegate;
	messageObject.projectId = projectId;
			
	[self performSelector:@selector(initCompleteItems:) withObject:messageObject afterDelay:3];
	return nil;
}

-(void) initProjects:(NSObject<XDataEngineDelegate>*) delegate {
	DLog(@"initProjects");
	NSString* jsonString = @"[{\"user_id\": 124278, \"name\": \"My Project 1\", \"color\": \"#ff8581\", \"collapsed\": 0, \"item_order\": 1, \"cache_count\": 7, \"indent\": 1, \"id\": 666082}, {\"user_id\": 124278, \"name\": \"*Group 1\", \"color\": \"#ff8581\", \"collapsed\": 0, \"item_order\": 2, \"cache_count\": 0, \"indent\": 1, \"id\": 841899}, {\"user_id\": 124278, \"name\": \"My Sub Project 1 With a very very long name indeed which should go over a number of lines indeed.\", \"color\": \"#ff8581\", \"collapsed\": 0, \"item_order\": 3, \"cache_count\": 18, \"indent\": 2, \"id\": 666085}, {\"user_id\": 124278, \"name\": \"My Sub Project 2\", \"color\": \"#bde876\", \"collapsed\": 0, \"item_order\": 4, \"cache_count\": 3, \"indent\": 2, \"id\": 666086}, {\"user_id\": 124278, \"name\": \"My Sub Project 3\", \"color\": \"#ff8581\", \"collapsed\": 0, \"item_order\": 5, \"cache_count\": 3, \"indent\": 2, \"id\": 666088}, {\"user_id\": 124278, \"name\": \"My Project 2\", \"color\": \"#3cd6fc\", \"collapsed\": 0, \"item_order\": 6, \"cache_count\": 3, \"indent\": 1, \"id\": 666083}, {\"user_id\": 124278, \"name\": \"My Sub Project 1\", \"color\": \"#3cd6fc\", \"collapsed\": 0, \"item_order\": 7, \"cache_count\": 3, \"indent\": 2, \"id\": 666089}, {\"user_id\": 124278, \"name\": \"My Sub Project 2\", \"color\": \"#3cd6fc\", \"collapsed\": 0, \"item_order\": 8, \"cache_count\": 3, \"indent\": 2, \"id\": 666090}, {\"user_id\": 124278, \"name\": \"My New Project\", \"color\": \"#ff8581\", \"collapsed\": 0, \"item_order\": 9, \"cache_count\": 3, \"indent\": 1, \"id\": 693957}]";
	NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[jsonString JSONValue]];
	[self calculateHasChildren:tempArray];
	self.projects = tempArray;
	[tempArray release];
    [self setIsLoading:DATATYPEPROJECTS withBoolean:true];
	DLog(@"Projects initialised.  Calling protocol method dataHasLoaded on delegate");
	[delegate dataHasLoaded:DATA_REQUEST_PROJECTS];
}

-(void) initIncompleteItems:(MessageObjects*)messageObjects {
	NSString* jsonString = @"[{\"due_date\": \"Sun Sep 13 23:59:59 2009\", \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": \"\", \"content\": \"item %1 %(b)blah %(i)blah% blah% long%(b)bigword% word%(b) word% word\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5462879, \"priority\": 4, \"item_order\": 1, \"project_id\": 666085, \"chains\": null, \"date_string\": \"next sunday\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": \"\", \"content\": \"normal %(b)BOLD% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5462880, \"priority\": 2, \"item_order\": 2, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": \"\", \"content\": \"string%(b)string%\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5462882, \"priority\": 1, \"item_order\": 3, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"string string\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5678653, \"priority\": 1, \"item_order\": 4, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(b)bold% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683970, \"priority\": 1, \"item_order\": 5, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(i)italic% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683972, \"priority\": 1, \"item_order\": 6, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(u)underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683975, \"priority\": 1, \"item_order\": 7, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(hl)highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683976, \"priority\": 1, \"item_order\": 8, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bi)bold italic% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683980, \"priority\": 1, \"item_order\": 9, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bu)bold underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683984, \"priority\": 1, \"item_order\": 10, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bhl)bold highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683986, \"priority\": 1, \"item_order\": 11, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(iu)italic underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683994, \"priority\": 1, \"item_order\": 12, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(ihl)italic highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683995, \"priority\": 1, \"item_order\": 13, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(uhl)underline highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684003, \"priority\": 1, \"item_order\": 14, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(biu)bold italic underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684006, \"priority\": 1, \"item_order\": 15, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bihl)bold italic highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684008, \"priority\": 1, \"item_order\": 16, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(buhl)bold underline highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684009, \"priority\": 1, \"item_order\": 17, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(iuhl)italic underline highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684010, \"priority\": 1, \"item_order\": 18, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}]";
	NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[jsonString JSONValue]];
	[self.incompleteItems setObject:tempArray forKey:[NSNumber numberWithInt:messageObjects.projectId]];
	[tempArray release];
	[messageObjects.delegate dataHasLoaded:DATA_REQUEST_INCOMPLETE_ITEMS];
}

-(void) initCompleteItems:(MessageObjects*)messageObjects {
	NSString* jsonString = @"[{\"due_date\": \"Sun Sep 13 23:59:59 2009\", \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": \"\", \"content\": \"item %1 %(b)blah %(i)blah% blah% long%(b)bigword% word%(b) word% word\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5462879, \"priority\": 4, \"item_order\": 1, \"project_id\": 666085, \"chains\": null, \"date_string\": \"next sunday\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": \"\", \"content\": \"normal %(b)BOLD% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5462880, \"priority\": 2, \"item_order\": 2, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": \"\", \"content\": \"string%(b)string%\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5462882, \"priority\": 1, \"item_order\": 3, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"string string\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5678653, \"priority\": 1, \"item_order\": 4, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(b)bold% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683970, \"priority\": 1, \"item_order\": 5, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(i)italic% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683972, \"priority\": 1, \"item_order\": 6, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(u)underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683975, \"priority\": 1, \"item_order\": 7, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(hl)highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683976, \"priority\": 1, \"item_order\": 8, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bi)bold italic% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683980, \"priority\": 1, \"item_order\": 9, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bu)bold underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683984, \"priority\": 1, \"item_order\": 10, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bhl)bold highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683986, \"priority\": 1, \"item_order\": 11, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(iu)italic underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683994, \"priority\": 1, \"item_order\": 12, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(ihl)italic highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5683995, \"priority\": 1, \"item_order\": 13, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(uhl)underline highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684003, \"priority\": 1, \"item_order\": 14, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(biu)bold italic underline% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684006, \"priority\": 1, \"item_order\": 15, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(bihl)bold italic highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684008, \"priority\": 1, \"item_order\": 16, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(buhl)bold underline highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684009, \"priority\": 1, \"item_order\": 17, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}, {\"due_date\": null, \"collapsed\": 0, \"labels\": [], \"is_dst\": 1, \"has_notifications\": 0, \"checked\": 0, \"indent\": 1, \"children\": null, \"content\": \"normal %(iuhl)italic underline highlight% normal\", \"user_id\": 124278, \"mm_offset\": 60, \"in_history\": 0, \"id\": 5684010, \"priority\": 1, \"item_order\": 18, \"project_id\": 666085, \"chains\": null, \"date_string\": \"\"}]";
	NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[jsonString JSONValue]];
	[self.completeItems setObject:tempArray forKey:[NSNumber numberWithInt:messageObjects.projectId]];
	[tempArray release];
	[messageObjects.delegate dataHasLoaded:DATA_REQUEST_COMPLETE_ITEMS];
}

#pragma mark -
#pragma mark Class instance methods

-(void) calculateHasChildren:(NSMutableArray*)aList {
	
	NSMutableDictionary* prevItem = nil;
	NSInteger prevItemLevel = 1;
	
	// Iterate through all items
	for (NSMutableDictionary* anItem in aList) {
		NSInteger itemLevel = [[anItem objectForKey:@"indent"] intValue];
		if (prevItem != nil) {
			NSNumber* hasChildren = nil;
			if (itemLevel > prevItemLevel) {
				hasChildren = [NSNumber numberWithBool:YES];
			}
			else {
				hasChildren = [NSNumber numberWithBool:NO];
			}
			[prevItem setObject:hasChildren forKey:@"hasChildren"];
		}
		prevItem = anItem;
		prevItemLevel = itemLevel;
	}
	// Set the last item (no Children)
	[prevItem setObject:[NSNumber numberWithBool:NO] forKey:@"hasChildren"];	
}

#pragma mark -
#pragma mark Singleton methods

+(XDataEngine*) sharedDataEngine {
	@synchronized(self)
	{
		if (sharedDataEngine == nil) {
			sharedDataEngine = [[XDataEngine alloc] init];
		}
		
		return sharedDataEngine;
	}
	return nil;
}

+(id)allocWithZone:(NSZone*)zone {
	@synchronized(self)
	{
		if (sharedDataEngine == nil) {
			sharedDataEngine = [super allocWithZone:zone];
			return sharedDataEngine;
		}
	}
	return nil;
}

-(id)copyWithZone:(NSZone *)zone {
	return self;
}

-(id)retain {
	return self;
}

-(unsigned)retainCount {
	return UINT_MAX;
}

-(void) release {
	// do nothing
}

-(id)autorelease {
	return self;
}

-(bool)isLoading:(DATATYPE)dataType {
	NSNumber* bValue = [[self.loadingDictionary objectForKey:[NSNumber numberWithInt:dataType]]retain];
	if (bValue == nil) {
		return true;
	}
	else {
       return [bValue boolValue];
	}
}

-(void)setIsLoading:(DATATYPE)dataType withBoolean:(_Bool)bValue {
    if (self.loadingDictionary == nil) {
        self.loadingDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
	NSNumber* key = [NSNumber numberWithInt:dataType];
	NSNumber* value = [NSNumber numberWithBool:bValue];
	[self.loadingDictionary setObject:value forKey:key];
}

@end
