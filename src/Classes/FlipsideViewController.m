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

#import "AnalyticsPolicy.h"
#import "CameraViewController.h"
#import "CoCViewController.h"
#import "CustomCoCViewController.h"
#import "FlipsideTableViewDataSource.h"
#import "FlipsideTableViewDelegate.h"
#import "FieldToolsAppDelegate.h"
#import "FTCamera.h"
#import "FTCameraBag.h"
#import "FTLens.h"
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

@synthesize analyticsPolicy;
@synthesize navigationController;
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
    
    [[self analyticsPolicy] trackView:kSettings];

	[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
	UIBarButtonItem* rightBarButtonItem = 
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
													  target:self
													  action:@selector(done)];
	[[self navigationItem] setRightBarButtonItem:rightBarButtonItem];
	
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
	
	NSInteger cameraCount = [[FTCameraBag sharedCameraBag] cameraCount];
	NSInteger lensCount = [[FTCameraBag sharedCameraBag] lensCount];
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
			 target:self
			 action:@selector(done)];
		
		[[self navigationItem] setRightBarButtonItem:rightBarButtonItem];
		
		NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:2];
		NSIndexPath* path = [NSIndexPath indexPathForRow:cameraCount 
											   inSection:CAMERAS_SECTION];
		[indexPaths addObject:path];
		
		[tableView deleteRowsAtIndexPaths:indexPaths 
						 withRowAnimation:UITableViewRowAnimationTop];
				
        
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

- (void)done
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)editCamera:(NSNotification*)notification
{
	CameraViewController* viewController =
		[[CameraViewController alloc] initWithNibName:@"CameraView" 
											   bundle:nil
											forCamera:(FTCamera*)[notification object]];
    [viewController setAnalyticsPolicy:[self analyticsPolicy]];
    
	[[self navigationController] pushViewController:viewController animated:YES];
}

- (void)editCoC:(NSNotification*)notification
{
	CoCViewController* viewController =
	[[CoCViewController alloc] initWithNibName:@"CoCView" 
										bundle:nil
									 forCamera:(FTCamera*)[notification object]];
    [viewController setAnalyticsPolicy:[self analyticsPolicy]];
	[[self navigationController] pushViewController:viewController animated:YES];
}

- (void)editCustomCoC:(NSNotification*)notification
{
	FTCamera* camera = (FTCamera*)[notification object];
	CustomCoCViewController* viewController =
		[[CustomCoCViewController alloc] initWithNibName:@"CustomCoCView" 
												  bundle:nil
											   forCamera:camera];
    [viewController setAnalyticsPolicy:[self analyticsPolicy]];
    
	[[self navigationController] pushViewController:viewController animated:YES];
}

- (void)editLens:(NSNotification*)notification
{
	LensViewController* viewController =
	[[LensViewController alloc] initWithNibName:@"LensView" 
										 bundle:nil
									    forLens:(FTLens*)[notification object]];
    [viewController setAnalyticsPolicy:[self analyticsPolicy]];
    
	[[self navigationController] pushViewController:viewController animated:YES];
}

- (void)editSubjectDistanceRange:(NSNotification*)notification
{
    SubjectDistanceRangesViewController* viewController =
        [[SubjectDistanceRangesViewController alloc] initWithNibName:@"SubjectDistanceRangesViewController"
                                                              bundle:nil];
    [viewController setAnalyticsPolicy:[self analyticsPolicy]];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)cameraWasAdded:(NSNotification*)notification
{
	[self cameraWasEdited:notification];
}

- (void)cameraWasEdited:(NSNotification*)notification
{
	UITableView* tableView = (UITableView*) [self view];
	
	[[FTCameraBag sharedCameraBag] save];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
	
	[tableView reloadData];
}

- (void)lensWasAdded:(NSNotification*)notification
{
	[self lensWasEdited:notification];
}

- (void)lensWasEdited:(NSNotification*)notification
{
	UITableView* tableView = (UITableView*) [self view];
	FTLens* lens = (FTLens*)[notification object];
	
	[[FTCameraBag sharedCameraBag] save];
	
	NSInteger selectedLens = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	if ([lens indexValue] == selectedLens)
	{
		[[NSNotificationCenter defaultCenter]
		 postNotification:[NSNotification notificationWithName:LENS_CHANGED_NOTIFICATION object:lens]];
	}
	
	[tableView reloadData];
}


@end
