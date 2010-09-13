//
//  ProjectsTableViewController.m
//  Todoist
//
//  Created by Chris Hudson on 24/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "TodoistAppDelegate.h"
#import "XDataEngine.h"
#import "TodoistViewController.h"

@implementation ProjectsTableViewController

@synthesize projectId;
@synthesize projects;
@synthesize parentViewController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
	
	XDataEngine* engine = [XDataEngine sharedDataEngine];
	projects = [[engine projectsForProjectId:[self projectId] WithDelegate:self] retain];
}

-(PROJECTSTABLECELLTYPE)cellTypeForCellAtIndexPath:(NSIndexPath *)indexPath {
	XDataEngine* engine = [XDataEngine sharedDataEngine];
	NSArray* theseProjects = [engine projectsForProjectId:self.projectId WithDelegate:nil];
	if (theseProjects != nil)
	{
		// project or group
		NSDictionary* projectItem = [theseProjects objectAtIndex:indexPath.row];
		NSString* name = [projectItem objectForKey:@"name"];
		bool hasChildren = [[projectItem objectForKey:@"hasChildren"] boolValue];

		// Group
		if ([name hasPrefix:@"*"]) {
			if (hasChildren) {
				return PROJECTSTABLECELLTYPEGROUPWITHCHILDREN;
			}
			else {
				return PROJECTSTABLECELLTYPEGROUP;				
			}
		}
		else {
			if (hasChildren) {
				return PROJECTSTABLECELLTYPEPROJECTWITHCHILDREN;
			}
			else {
				return PROJECTSTABLECELLTYPEPROJECT;				
			}
		}
	}
	else {
		// Nothing so Loading or empty
		if ([engine isLoading:DATATYPEPROJECTS]) {
			return PROJECTSTABLECELLTYPELOADING;
		}
		else {
			return PROJECTSTABLECELLTYPEEMPTY;
		}
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (projects != nil) {
		return [projects count];
	}
	else {
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	PROJECTSTABLECELLTYPE cellType = [self cellTypeForCellAtIndexPath:indexPath];
	UITableViewCell* cell = nil;
	switch (cellType) {
		case PROJECTSTABLECELLTYPEEMPTY:
		{
			cell = [self tableView:tableView emptyCellForRowAtIndexPath:indexPath];
			break;
		}
		case PROJECTSTABLECELLTYPELOADING:
		{
			cell = [self tableView:tableView loadingCellForRowAtIndexPath:indexPath];
			break;
		}
		case PROJECTSTABLECELLTYPEGROUP:
		{
			cell = [self tableView:tableView groupCellForRowAtIndexPath:indexPath withChildren:false];
			break;
		}
		case PROJECTSTABLECELLTYPEPROJECT:
		{
			cell = [self tableView:tableView projectCellForRowAtIndexPath:indexPath withChildren:false];
			break;
		}
		case PROJECTSTABLECELLTYPEGROUPWITHCHILDREN:
		{
			cell = [self tableView:tableView groupCellForRowAtIndexPath:indexPath withChildren:true];
			break;
		}
		case PROJECTSTABLECELLTYPEPROJECTWITHCHILDREN:
		{
			cell = [self tableView:tableView projectCellForRowAtIndexPath:indexPath withChildren:true];
			break;
		}
		default:
		{
			cell = [self tableView:tableView loadingCellForRowAtIndexPath:indexPath];
			break;
		}
	}
	return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EmptyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = @"No Sub Projects";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
	
    return cell;
	
}

-(UITableViewCell*)tableView:(UITableView *)tableView loadingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LoadingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]; 
    cell.imageView.image = [UIImage imageNamed:@"white-background.png"]; 
    [cell.imageView addSubview:spinner]; 
    [spinner startAnimating]; 
    [spinner release];
    cell.textLabel.text = @"Loading...";
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    return cell;
	
}

-(UITableViewCell*)tableView:(UITableView *)tableView groupCellForRowAtIndexPath:(NSIndexPath *)indexPath withChildren:(_Bool)hasChildren {
    static NSString *CellIdentifier = @"GroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary* projectItem = [projects objectAtIndex:indexPath.row];
	cell.textLabel.text = [[projectItem objectForKey:@"name"] substringFromIndex:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.accessoryType = hasChildren?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
	NSString* colourString = [projectItem objectForKey:@"color"];
	UIColor* cellColour = [UIColor colorForHex:colourString];
	cell.imageView.image = [self cellImageForGroupWithColour:cellColour];

    return cell;
	
}

-(UITableViewCell*)tableView:(UITableView *)tableView projectCellForRowAtIndexPath:(NSIndexPath *)indexPath withChildren:(_Bool)hasChildren {
    static NSString *CellIdentifier = @"ProjectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary* projectItem = [projects objectAtIndex:indexPath.row];
	cell.textLabel.text = [projectItem objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.accessoryType = hasChildren?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
	NSInteger cellCount = [[projectItem objectForKey:@"cache_count"]intValue];
	NSString* colourString = [projectItem objectForKey:@"color"];
	UIColor* cellColour = [UIColor colorForHex:colourString];
	cell.imageView.image = [self cellImageForProjectWithCount:cellCount AndColour:cellColour];
	
	return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSDictionary* projectDetails = [self.projects objectAtIndex:indexPath.row];
//	bool hasChildren = [[projectDetails objectForKey:@"hasChildren"] boolValue];
	NSInteger newProjectId = [[projectDetails objectForKey:@"id"] intValue];
	
    [parentViewController pushViewController:CONTROLLERTYPEPROJECTS projectId:newProjectId];
//	if (hasChildren) {
//		
//	}
//	else {
//		[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	}
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
	switch(requestType) {
			
		case DATA_REQUEST_PROJECTS:
			[projects release];
			projects = [[engine projectsForProjectId:[self projectId] WithDelegate:self] retain];
			[self.tableView reloadData];
			break;
	}
}

-(UIImage*)cellImageForProjectWithCount:(NSInteger)cellCount AndColour:(UIColor*)cellColour {
	
	CGFloat height = IMAGE_HEIGHT;
	CGFloat width = IMAGE_WIDTH;
	
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [cellColour set];  //Set foreground and background color to your chosen color
    CGContextFillRect(context,CGRectMake(0,0,width,height));  //Fill in the background
    NSString* number = [NSString stringWithFormat:@"%i",cellCount];  //Turn the number into a string
    UIFont* font = [UIFont systemFontOfSize:12];  //Get a font to draw with.  Change 12 to whatever font size you want to use.
    CGSize size = [number sizeWithFont:font]; // Determine the size of the string you are about to draw
    CGFloat x = (width - size.width)/2;  //Center the string
    CGFloat y = (height - size.height)/2;
    [[UIColor blackColor] set];  //Set the color of the string drawing function
    [number drawAtPoint:CGPointMake(x,y) withFont:font];  //Draw the string
	
	UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return outputImage;
}

-(UIImage*)cellImageForGroupWithColour:(UIColor*)cellColour {
	
	CGFloat height = IMAGE_HEIGHT;
	CGFloat width = IMAGE_WIDTH;
	
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [cellColour set];  //Set foreground and background color to your chosen color
    CGContextFillRect(context,CGRectMake(0,0,width/2,height));  //Fill in the background
	
	UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return outputImage;
}

@end

