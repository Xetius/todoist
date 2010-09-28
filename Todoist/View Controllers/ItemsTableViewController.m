//
//  ItemsTableViewController.m
//  Todoist
//
//  Created by Chris Hudson on 24/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "XDataEngine.h"
#import "TodoistViewController.h"

@implementation ItemsTableViewController

@synthesize projectId;
@synthesize incompleteItems;
@synthesize completeItems;
@synthesize parentViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
	XDataEngine* engine = [XDataEngine sharedDataEngine];
	incompleteItems = [[engine incompleteItemsForProjectId:[self projectId] WithDelegate:self]retain];
	completeItems = [[engine completeItemsForProjectId:[self projectId] WithDelegate:self]retain];
   
    self.emptyTableText = @"No Sub Items";
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numRowsForSection = [[self itemsForSection:section] count];
	DLog(@"section %d [%d items]", section, numRowsForSection);
	return numRowsForSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case ITEMTABLESECTIONINCOMPLETE:
			return @"Incomplete Items";
		case ITEMTABLESECTIONCOMPLETE:
			return @"CompleteItems";
	}
	return @"-";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	NSArray* items = [self itemsForSection:section];
	return [NSString stringWithFormat:@"%d items", items.count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ITEMTABLECELLTYPE cellType = [self cellTypeForCellAtIndexPath:indexPath];
    switch (cellType) {
        ITEMTABLECELLTYPEEMPTY:
            return [self tableView:tableView emptyCellForRowAtIndexPath:indexPath];
            break;
        ITEMTABLECELLTYPELOADING:
            return [super tableView:tableView loadingCellForRowAtIndexPath:indexPath];
            break;
        ITEMTABLECELLTYPEITEM:
            return [self tableView:tableView itemCellForRowAtIndexPath:indexPath withChildren:false];
            break;
        ITEMTABLECELLTYPEITEMWITHCHILDREN:
            return [self tableView:tableView itemCellForRowAtIndexPath:indexPath withChildren:true];
            break;
            
    }
    	
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray* items = [self itemsForSection:indexPath.section];
	NSDictionary* item = [items objectAtIndex:indexPath.row];
	NSInteger newProjectId = [[item objectForKey:@"id"] intValue];
	bool hasChildren = [item objectForKey:@"hasChildren"];
	
	if (hasChildren) {
		[parentController pushViewController:CONTROLLERTYPEITEMS projectId:newProjectId];		
	}
	else {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)dataHasLoaded:(int)requestType {
	XDataEngine* engine = [XDataEngine sharedDataEngine];
	switch (requestType) {
		case DATA_REQUEST_INCOMPLETE_ITEMS:
		{
			[incompleteItems release];
			incompleteItems = [[engine incompleteItemsForProjectId:[self projectId] WithDelegate:self] retain];
			[self.tableView reloadData];
		}
		break;
		case DATA_REQUEST_COMPLETE_ITEMS:
		{
			[completeItems release];
			completeItems = [[engine completeItemsForProjectId:[self projectId] WithDelegate:self]retain];
			[self.tableView reloadData];
		}
		break;
		default:
		{
			
		}
		break;
	}
}

-(NSArray *)itemsForSection:(NSInteger)section {
	
	if (section == ITEMTABLESECTIONINCOMPLETE) {
		return incompleteItems;
	}
	else {
		return completeItems;
	}
}

-(ITEMTABLECELLTYPE) cellTypeForCellAtIndexPath:(NSIndexPath*)indexPath {
    
    XDataEngine* engine = [XDataEngine sharedDataEngine];
    NSMutableArray* itemArray = nil;
    bool isLoading = false;
    if (indexPath.section == ITEMTABLESECTIONINCOMPLETE) {
        itemArray = [engine incompleteItemsForProjectId:self.projectId WithDelegate:nil];
        isLoading = [engine isLoading:DATATYPEINCOMPLETEITEMS];
    }
    else {
        itemArray = [engine completeItemsForProjectId:self.projectId WithDelegate:nil];
        isLoading = [engine isLoading:DATATYPECOMPLETEITEMS];
    }
    
    if (itemArray != nil) {
        NSDictionary* item = [itemArray objectAtIndex:indexPath.row];
        bool hasChildren = [[item objectForKey:@"hasChildren"] boolValue];
        
        if (hasChildren) {
            return ITEMTABLECELLTYPEITEMWITHCHILDREN;
        }
        else {
            return ITEMTABLECELLTYPEITEM;
        }
    }
    else {
        if (isLoading) {
            return ITEMTABLECELLTYPELOADING;
        }
        else {
            return ITEMTABLECELLTYPEEMPTY;
        }
    }
    return ITEMTABLECELLTYPEEMPTY;
}

-(UITableViewCell *)tableView:(UITableView *)tableView itemCellForRowAtIndexPath:(NSIndexPath *)indexPath withChildren:(bool)hasChildren {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSArray* items = [self itemsForSection:indexPath.section];
	NSDictionary* item = [items objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [item objectForKey:@"content"];

    return cell;
}

@end

