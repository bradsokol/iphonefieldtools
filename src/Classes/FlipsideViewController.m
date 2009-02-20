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

#import "FieldToolsAppDelegate.h"
#import "GearCell.h"
#import "Notifications.h"
#import "UserDefaults.h"

// Enumerate sections in UITable
const NSInteger SECTION_COUNT = 2;
const NSInteger CAMERAS_SECTION = 0;
const NSInteger UNITS_SECTION = 1;

// Enumerate rows in units section of table
const NSInteger FEET_ROW = 0;
const NSInteger METRES_ROW = 1;

const NSInteger CAMERAS_COUNT = 8;
const NSInteger UNITS_COUNT = 2;

// Private methods
@interface FlipsideViewController(Private)

- (UITableViewCell*) cellForCameraRowAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*) tableView;
- (UITableViewCell*) cellForUnitsRowAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*)tableView;
- (void)didSelectCameraInTableView:(UITableView*) tableView atIndexPath:(NSIndexPath*)indexPath;
- (void)didSelectUnitsInTableView:(UITableView*) tableView atIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)rowForDefaultCamera;
- (NSInteger)rowForDefaultUnits;

@end

@implementation FlipsideViewController

@synthesize navigationController;
@synthesize rootViewController;

- (void)viewDidLoad 
{
    [super viewDidLoad];

	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return section == CAMERAS_SECTION ? CAMERAS_COUNT : UNITS_COUNT;
}

// Customize the appearance of table view cells. Cells for the units and
// camera sections are formatted differently and handled by helper methods.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell* cell;
	if ([indexPath section] == UNITS_SECTION)
	{
		cell = [self cellForUnitsRowAtIndexPath:indexPath inTableView:tableView];
	}
	else if ([indexPath section] == CAMERAS_SECTION)
	{
		cell = [self cellForCameraRowAtIndexPath:indexPath inTableView:tableView];
	}
	
    return cell;
}

// Forward handling of row selection to appropriate helper method
// depending on whether a units or camera row was selected.
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
	if ([indexPath section] == CAMERAS_SECTION)
	{
		[self didSelectCameraInTableView:tableView atIndexPath:indexPath];
	}
	else
	{
		[self didSelectUnitsInTableView:tableView atIndexPath:indexPath];
	}
}

#pragma mark Events

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

#pragma mark Helper methods

// Format table cell for rows in the cameras section of the table view.
- (UITableViewCell *) cellForCameraRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *) tableView
{
	static NSString *GearCellIdentifier = @"Gear";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GearCellIdentifier];
	if (cell == nil) 
	{
		NSArray* nibContents = [[NSBundle mainBundle] 
								loadNibNamed:@"GearCell" 
								owner:self
								options:nil];
		
		// Find the customized table cell in the nib
		NSEnumerator* nibEnumerator = [nibContents objectEnumerator];
		cell = nil;
		NSObject* nibItem = nil;
		while ((nibItem = [nibEnumerator nextObject]) != nil)
		{
			if ([nibItem isKindOfClass:[GearCell class]])
			{
				cell = (GearCell*) nibItem;
				if ([[cell reuseIdentifier] isEqualToString:GearCellIdentifier])
				{
					// Found it
					break;
				}
				else
				{
					cell = nil;
				}
			}
		}
	}

	// Set the elements of the customized table cell
	GearCell* gearCell = (GearCell*) cell;
	
	NSString* key = [NSString stringWithFormat:@"CAMERA_DESCRIPTION_%d", [indexPath row]];
	[[gearCell name] setText:NSLocalizedString(key, "Camera description")];
	
	key = [NSString stringWithFormat:@"CAMERA_COC_%d", [indexPath row]];
	[[gearCell type] setText:NSLocalizedString(key, "Camera CoC")];

	// Set the check mark if this is the currently selected camera.
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	if (index == [indexPath row])
	{
		[gearCell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	return cell;
}

// Format table cell for rows in the units section of the table view
- (UITableViewCell *) cellForUnitsRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*)tableView
{
    static NSString *CellIdentifier = @"Cell";

	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero
				 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell setText:[indexPath row] == FEET_ROW ? NSLocalizedString(@"FEET", "Feet") : 
	 NSLocalizedString(@"METRES", "Metres")];
	
	// Set the check mark if this is the current units
	bool metric = [[NSUserDefaults standardUserDefaults] boolForKey:FTMetricKey];
	if ((metric && [indexPath row] == METRES_ROW) || (!metric && [indexPath row] == FEET_ROW))
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	return cell;
}

// Handles selection of a row in the cameras section of the table view
- (void)didSelectCameraInTableView:(UITableView*) tableView atIndexPath:(NSIndexPath*)indexPath
{
	NSIndexPath* oldIndexPath = [NSIndexPath indexPathForRow:[self rowForDefaultCamera] 
												   inSection:[indexPath section]];
	
	UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
	if ([newCell accessoryType] == UITableViewCellAccessoryNone)
	{
		// Selected row is not the current camera so change the selection
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		[[NSUserDefaults standardUserDefaults] setInteger:[indexPath row]
												   forKey:FTCameraIndex];
		[[NSNotificationCenter defaultCenter] 
		 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
	}
	
	UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if ([oldCell accessoryType] == UITableViewCellAccessoryCheckmark)
	{
		[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	}
}

// Handles select of a row in the units section of the table view
- (void)didSelectUnitsInTableView:(UITableView*) tableView atIndexPath:(NSIndexPath*)indexPath
{
	NSIndexPath* oldIndexPath = [NSIndexPath indexPathForRow:[self rowForDefaultUnits] 
												   inSection:[indexPath section]];
	
	UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
	if ([newCell accessoryType] == UITableViewCellAccessoryNone)
	{
		// Selectedrow is not the current units so change the selection
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		[[NSUserDefaults standardUserDefaults] setBool:[indexPath row] == METRES_ROW
												forKey:FTMetricKey];
		[[NSNotificationCenter defaultCenter] 
		 postNotification:[NSNotification notificationWithName:UNITS_CHANGED_NOTIFICATION object:nil]];
	}
	
	UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if ([oldCell accessoryType] == UITableViewCellAccessoryCheckmark)
	{
		[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	}
}

// Returns the row index for the current default camera
- (NSInteger)rowForDefaultCamera
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	return index;
}

// Returns the row index for the current units
- (NSInteger)rowForDefaultUnits
{
	bool metric = [[NSUserDefaults standardUserDefaults] boolForKey:FTMetricKey];
	return metric ? METRES_ROW : FEET_ROW;
}

- (void)dealloc 
{
	[navigationController release];
	[rootViewController release];
	
    [super dealloc];
}

@end
