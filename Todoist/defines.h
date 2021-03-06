/*
 *  defines.h
 *  Todoist
 *
 *  Created by Chris Hudson on 22/03/2010.
 *  Copyright 2010 Xetius Software. All rights reserved.
 *
 */

#define LOADING_PROJECTS_CELL_HEIGHT	55
#define ITEMS_CELL_HEIGHT				45

#define DATA_REQUEST_PROJECTS			1
#define DATA_REQUEST_INCOMPLETE_ITEMS	2
#define DATA_REQUEST_COMPLETE_ITEMS		4
#define DATA_REQUEST_LABELS				8

#define CELL_INDENT_SIZE				10

#define IMAGE_HEIGHT					25
#define IMAGE_WIDTH						25

#define ITEM_TEXT_SIZE					17.0

typedef enum {
	CONTROLLERTYPEPROJECTS,
	CONTROLLERTYPEITEMS
} CONTROLLERTYPE;

typedef enum {
	DATASTATUSNONE,
	DATASTATUSLOADING,
	DATASTATUSLOADED
} DATASTATUS;

typedef enum {
	PROJECTSTABLECELLTYPEEMPTY,
	PROJECTSTABLECELLTYPELOADING,
	PROJECTSTABLECELLTYPEGROUP,
	PROJECTSTABLECELLTYPEGROUPWITHCHILDREN,
	PROJECTSTABLECELLTYPEPROJECT,
	PROJECTSTABLECELLTYPEPROJECTWITHCHILDREN,
} PROJECTSTABLECELLTYPE;

typedef enum {
	ITEMTABLECELLTYPEEMPTY,
	ITEMTABLECELLTYPELOADING,
	ITEMTABLECELLTYPEITEM,
	ITEMTABLECELLTYPEITEMWITHCHILDREN
} ITEMTABLECELLTYPE;

typedef enum {
	ITEMTABLESECTIONINCOMPLETE,
	ITEMTABLESECTIONCOMPLETE
} ITEMTABLESECTION;

typedef enum {
	DATATYPEPROJECTS,
	DATATYPEINCOMPLETEITEMS,
	DATATYPECOMPLETEITEMS,
	DATATYPELABELS,
} DATATYPE;