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
//  CoCViewController.m
//  FieldTools
//
//  Created by Brad on 2009/08/23.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CoCViewController.h"

#import "Camera.h"
#import "CoC.h"
#import "CoCViewTableDataSource.h"

#import "Notifications.h"

@interface CoCViewController ()

- (void)cancelWasSelected;
- (void)didSelectCoCPresetAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (void)didSelectCustomCoCInTableView:(UITableView *)tableView;
- (NSString*)keyForRow:(int)row;
- (int)rowForSelectedCoC;
- (void)saveWasSelected;

@property(nonatomic, retain) Camera* camera;
@property(nonatomic, retain) Camera* cameraWorking;
@property(nonatomic, retain) UIBarButtonItem* saveButton;

@end

@implementation CoCViewController

@synthesize camera;
@synthesize cameraWorking;
@synthesize saveButton;
@synthesize tableViewDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	return [self initWithNibName:nibNameOrNil
						  bundle:nibBundleOrNil
					   forCamera:nil];
}

// The designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCamera:(Camera*)aCamera
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) 
    {
		return nil;
    }
	
	[self setCamera:aCamera];
	[self setCameraWorking:[[[self camera] copy] autorelease]];
	
	UIBarButtonItem* cancelButton = 
	[[[UIBarButtonItem alloc] 
	  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel									 
	  target:self
	  action:@selector(cancelWasSelected)] autorelease];
	[self setSaveButton:[[[UIBarButtonItem alloc] 
	 initWithBarButtonSystemItem:UIBarButtonSystemItemSave	 
	 target:self
	 action:@selector(saveWasSelected)] autorelease]];
	[saveButton setEnabled:NO];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	
	[self setTitle:NSLocalizedString(@"COC_VIEW_TITLE", "CoC view")];
    
	return self;
}

- (void)cancelWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
	[[self camera] setCoc:[[self cameraWorking] coc]];
	
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	[self setTableViewDataSource: [[self tableView] dataSource]];
	[[self tableViewDataSource] setCamera:[self camera]];
	[[self tableViewDataSource] setController:self];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];

	if ([indexPath row] < [[CoC cocPresets] count])
	{
		[self didSelectCoCPresetAtIndexPath:indexPath inTableView:tableView];
	}
	else
	{
		[self didSelectCustomCoCInTableView:tableView];
	}
}

#pragma mark Helper methods

- (void) didSelectCoCPresetAtIndexPath:(NSIndexPath *)indexPath
						   inTableView:(UITableView *)tableView  
{
	NSIndexPath* oldIndexPath = [NSIndexPath indexPathForRow:[self rowForSelectedCoC] 
												   inSection:[indexPath section]];
	
	if ([oldIndexPath row] == [indexPath row])
	{
		// User selected the currently selected CoC - take no action
		return;
	}
	
	[saveButton setEnabled:YES];
	
	UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
	if ([newCell accessoryType] == UITableViewCellAccessoryNone)
	{
		// Selected row is not the current CoC so change the selection
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		NSString* description = [self keyForRow:[indexPath row]];
		CoC* coc = [[CoC alloc] initWithValue:[[CoC findFromPresets:description] value]
								  description:description];
		[[self cameraWorking] setCoc:coc];
		[coc release];
		
		[[NSNotificationCenter defaultCenter] 
		 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
	}
	
	UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if ([oldCell accessoryType] == UITableViewCellAccessoryCheckmark)
	{
		[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	}
}

- (void)didSelectCustomCoCInTableView:(UITableView *)tableView
{
	[[NSNotificationCenter defaultCenter] 
	 postNotification:
	 [NSNotification notificationWithName:CUSTOM_COC_SELECTED_FOR_EDIT_NOTIFICATION 
								   object:nil]];
}

- (NSString*)keyForRow:(int)row
{
	NSArray* keys = [[CoC cocPresets] allKeys];
	NSArray* sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	return [sortedKeys objectAtIndex:row];
}

- (int)rowForSelectedCoC
{
	NSArray* keys = [[CoC cocPresets] allKeys];
	NSArray* sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (int i = 0; i < [sortedKeys count]; ++i)
	{
		if ([[[[self cameraWorking] coc] description] compare:[sortedKeys objectAtIndex:i]] == 0)
		{
			return i;
		}
	}
	return -1;
}

- (void)dealloc 
{
	[self setSaveButton:nil];
	[self setCamera:nil];
	[self setCameraWorking:nil];
	
    [super dealloc];
}

@end