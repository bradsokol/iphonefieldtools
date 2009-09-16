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
	[[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							  target:rootViewController
																							  action:@selector(toggleView)]];
	
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
		
		[path release];
		path = [NSIndexPath indexPathForRow:lensCount 
								  inSection:LENSES_SECTION];
		[indexPaths replaceObjectAtIndex:0
							  withObject:path];
		[tableView insertRowsAtIndexPaths:indexPaths
						 withRowAnimation:UITableViewRowAnimationTop];
		[path release];
		[indexPaths release];
	}
	else
	{
		[[self navigationItem] 
		 setRightBarButtonItem:[[UIBarButtonItem alloc] 
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:rootViewController
								action:@selector(toggleView)]];
		
		NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:2];
		NSIndexPath* path = [NSIndexPath indexPathForRow:cameraCount 
											   inSection:CAMERAS_SECTION];
		
		[tableView deleteRowsAtIndexPaths:indexPaths 
						 withRowAnimation:UITableViewRowAnimationTop];
		
		[path release];
		path = [NSIndexPath indexPathForRow:lensCount
								  inSection:LENSES_SECTION];
		[tableView deleteRowsAtIndexPaths:indexPaths
						 withRowAnimation:UITableViewRowAnimationTop];
		
		[path release];
		[indexPaths release];
	}
	[tableView endUpdates];
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
}

- (void)editCoC:(NSNotification*)notification
{
	UIViewController* viewController = 
	[[CoCViewController alloc] initWithNibName:@"CoCView" 
										bundle:nil
									 forCamera:(Camera*)[notification object]];
	[[self navigationController] pushViewController:viewController animated:YES];
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

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObject:self];
	
	[navigationController release];
	[rootViewController release];
	
    [super dealloc];
}

@end
