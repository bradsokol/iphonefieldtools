// Copyright 2009 Brad Sokol
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  FlipsideViewController.m
//  FieldTools
//
//  Created by Brad on 2008/11/29.
//

#import "FlipsideViewController.h"

#import "Camera.h"
#import "CameraViewController.h"
#import "CoCViewController.h"
#import "FlipsideTableViewDataSource.h"
#import "FieldToolsAppDelegate.h"
#import "Lens.h"
#import "Notifications.h"
#import "UserDefaults.h"

@interface FlipsideViewController (Private)

-(void)adjustAccessoriesInSection:(int)section inSelectedRow:(int)row inTableView:(UITableView*) tableView editing:(BOOL)editing;
-(void)editCamera:(NSNotification*)notification;
-(void)editCoC:(NSNotification*)notification;

@end

@implementation FlipsideViewController

@synthesize navigationController;
@synthesize rootViewController;
@synthesize tableViewDataSource;
@synthesize tableViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (nil == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        return nil;
    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(editCamera:)
												 name:CAMERA_SELECTED_FOR_EDIT_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(editCoC:)
												 name:COC_SELECTED_FOR_EDIT_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(cameraWasEdited:)
												 name:CAMERA_WAS_EDITED_NOTIFICATION
											   object:nil];
	
	return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
	UIBarButtonItem* rightBarButtonItem = 
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
													  target:rootViewController
													  action:@selector(toggleView)];
	[[self navigationItem] setRightBarButtonItem:rightBarButtonItem];
	[rightBarButtonItem release];
	
	[self setTableViewDelegate:(FlipsideTableViewDelegate*) [[self tableView] delegate]];
	[self setTableViewDataSource: [[self tableView] dataSource]];
	
	[[self tableView] setAllowsSelectionDuringEditing:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	[tableViewDelegate setEditing:editing];
	[tableViewDataSource setEditing:editing];
	
	int cameraCount = [Camera count];
	int lensCount = [Lens count];
	UITableView* tableView = (UITableView*) [self view];
	
	[tableView beginUpdates];
	
	if (editing)
	{
		[[self navigationItem] setRightBarButtonItem:nil];

		NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:2];
		NSIndexPath* path = [NSIndexPath indexPathForRow:cameraCount 
											   inSection:CAMERAS_SECTION];
		[indexPaths addObject:path];
		
		[tableView insertRowsAtIndexPaths:indexPaths 
						 withRowAnimation:UITableViewRowAnimationTop];
		
		path = [NSIndexPath indexPathForRow:lensCount 
								  inSection:LENSES_SECTION];
		[indexPaths replaceObjectAtIndex:0
							  withObject:path];
		[tableView insertRowsAtIndexPaths:indexPaths
						 withRowAnimation:UITableViewRowAnimationTop];
		[indexPaths release];
	}
	else
	{
		UIBarButtonItem* rightBarButtonItem = 
			[[UIBarButtonItem alloc] 
			 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
			 target:rootViewController
			 action:@selector(toggleView)];
		
		[[self navigationItem] setRightBarButtonItem:rightBarButtonItem];
		[rightBarButtonItem release];
		
		NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:2];
		NSIndexPath* path = [NSIndexPath indexPathForRow:cameraCount 
											   inSection:CAMERAS_SECTION];
		[indexPaths addObject:path];
		
		[tableView deleteRowsAtIndexPaths:indexPaths 
						 withRowAnimation:UITableViewRowAnimationTop];
		
		path = [NSIndexPath indexPathForRow:lensCount
								  inSection:LENSES_SECTION];
		[indexPaths replaceObjectAtIndex:0
							  withObject:path];
		
		[tableView deleteRowsAtIndexPaths:indexPaths
						 withRowAnimation:UITableViewRowAnimationTop];
		
		[indexPaths release];
	}
	[tableView endUpdates];
	
	NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	[self adjustAccessoriesInSection:CAMERAS_SECTION 
					   inSelectedRow:row 
						 inTableView:tableView
							 editing:editing];
	
	// TODO: Same as above but for lenses
}

#pragma mark Events

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)editCamera:(NSNotification*)notification
{
	UIViewController* viewController = 
		[[CameraViewController alloc] initWithNibName:@"CameraView" 
											   bundle:nil
											forCamera:(Camera*)[notification object]];
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)editCoC:(NSNotification*)notification
{
	UIViewController* viewController = 
	[[CoCViewController alloc] initWithNibName:@"CoCView" 
										bundle:nil
									 forCamera:(Camera*)[notification object]];
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)cameraWasEdited:(NSNotification*)notification
{
	UITableView* tableView = (UITableView*) [self view];
	Camera* camera = (Camera*)[notification object];
	[camera save];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
	
	[tableView reloadData];
}

- (void)adjustAccessoriesInSection:(int)section inSelectedRow:(int)row inTableView:(UITableView*) tableView editing:(BOOL)editing 
{
	int limit = editing ? [Camera count] + 1 : [Camera count];
	for (int i = 0; i < limit; ++i)
	{
		NSIndexPath* path = [NSIndexPath indexPathForRow:i
											   inSection:section];
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:path];
		if (editing)
		{
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		else
		{
			[cell setAccessoryType:(i == row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
		}
	}
	
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObject:self];
	
	[navigationController release];
	[rootViewController release];
	
    [super dealloc];
}

@end
