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
#import "CameraBag.h"
#import "CameraViewController.h"
#import "CoCViewController.h"
#import "CustomCoCViewController.h"
#import "FlipsideTableViewDataSource.h"
#import "FieldToolsAppDelegate.h"
#import "Lens.h"
#import "LensViewController.h"
#import "Notifications.h"
#import "SubjectDistanceRangesViewController.h"
#import "UserDefaults.h"

@interface FlipsideViewController ()

-(void)cameraWasEdited:(NSNotification *)notification;
-(void)editCamera:(NSNotification*)notification;
-(void)editCoC:(NSNotification*)notification;
-(void)editCustomCoC:(NSNotification*)notification;
-(void)editLens:(NSNotification*)notification;
-(void)editSubjectDistanceRange:(NSNotification*)notification;
-(void)lensWasEdited:(NSNotification *)notification;

@end

@implementation FlipsideViewController

@synthesize navigationController;
@synthesize rootViewController;
@synthesize tableViewDataSource;
@synthesize tableViewDelegate;

// The designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) 
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
											 selector:@selector(editCustomCoC:)
												 name:CUSTOM_COC_SELECTED_FOR_EDIT_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(editLens:)
												 name:LENS_SELECTED_FOR_EDIT_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(editSubjectDistanceRange:)
												 name:EDIT_SUBJECT_DISTANCE_RANGE_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(cameraWasAdded:)
												 name:CAMERA_WAS_ADDED_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(cameraWasEdited:)
												 name:CAMERA_WAS_EDITED_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(lensWasAdded:)
												 name:LENS_WAS_ADDED_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(lensWasEdited:)
												 name:LENS_WAS_EDITED_NOTIFICATION
											   object:nil];
	
	return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:kSettings withError:&error]) 
    {
        NSLog(@"Error recording analytics page view: %@", error);
    }

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
	[[self tableViewDataSource] setController:self];
	
	[[self tableView] setAllowsSelectionDuringEditing:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	[[self tableViewDelegate] setEditing:editing];
	[[self tableViewDataSource] setEditing:editing];
	
	int cameraCount = [[CameraBag sharedCameraBag] cameraCount];
	int lensCount = [[CameraBag sharedCameraBag] lensCount];
	UITableView* tableView = (UITableView*) [self view];
    UITableViewCell* extraLensCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lensCount inSection:LENSES_SECTION]];
	
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
		
		[indexPaths release];
        
        if (nil != extraLensCell)
        {
            [[extraLensCell textLabel] setText:NSLocalizedString(@"ADD_LENS", "ADD_LENS")];
        }
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
				
		[indexPaths release];
        
        if (nil != extraLensCell)
        {
            [[extraLensCell textLabel] setText:NSLocalizedString(@"SUBJECT_DISTANCE_RANGE", "SUBJECT_DISTANCE_RANGE")];
        }
	}
	
	// Force the units section to reload so the selection style can be set appropriately.
	[tableView reloadSections:[NSIndexSet indexSetWithIndex:UNITS_SECTION]
			 withRowAnimation:UITableViewRowAnimationNone];
	
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

- (void)editCustomCoC:(NSNotification*)notification
{
	Camera* camera = (Camera*)[notification object];
	UIViewController* viewController = 
		[[CustomCoCViewController alloc] initWithNibName:@"CustomCoCView" 
												  bundle:nil
											   forCamera:camera];
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)editLens:(NSNotification*)notification
{
	UIViewController* viewController = 
	[[LensViewController alloc] initWithNibName:@"LensView" 
										 bundle:nil
									    forLens:(Lens*)[notification object]];
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)editSubjectDistanceRange:(NSNotification*)notification
{
    UIViewController* viewController =
        [[SubjectDistanceRangesViewController alloc] initWithNibName:@"SubjectDistanceRangesViewController"
                                                              bundle:nil];
    [[self navigationController] pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)cameraWasAdded:(NSNotification*)notification
{
	[[CameraBag sharedCameraBag] addCamera:[notification object]];
	[self cameraWasEdited:notification];
}

- (void)cameraWasEdited:(NSNotification*)notification
{
	UITableView* tableView = (UITableView*) [self view];
	
	[[CameraBag sharedCameraBag] save];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
	
	[tableView reloadData];
}

- (void)lensWasAdded:(NSNotification*)notification
{
	[[CameraBag sharedCameraBag] addLens:[notification object]];
	[self lensWasEdited:notification];
}

- (void)lensWasEdited:(NSNotification*)notification
{
	UITableView* tableView = (UITableView*) [self view];
	Lens* lens = (Lens*)[notification object];
	
	[[CameraBag sharedCameraBag] save];
	
	int selectedLens = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	if ([lens identifier] == selectedLens)
	{
		[[NSNotificationCenter defaultCenter]
		 postNotification:[NSNotification notificationWithName:LENS_CHANGED_NOTIFICATION object:lens]];
	}
	
	[tableView reloadData];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObject:self];
	
	[self setNavigationController:nil];
	[self setRootViewController:nil];
	[self setTableViewDataSource:nil];
	[self setTableViewDelegate:nil];
	
    [super dealloc];
}

@end
