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
//  FlipsideTableViewDataSource.m
//  FieldTools
//
//  Created by Brad on 2009/05/28.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "FlipsideTableViewDataSource.h"

#import "Camera.h"
#import "Lens.h"
#import "Notifications.h"
#import "UserDefaults.h"

const NSInteger SECTION_COUNT = 3;
const NSInteger UNITS_COUNT = 2;

// Enumerate sections in UITable
const NSInteger LENSES_SECTION = 0;
const NSInteger CAMERAS_SECTION = 1;
const NSInteger UNITS_SECTION = 2;

// Enumerate rows in units section of table
const NSInteger FEET_ROW = 0;
const NSInteger METRES_ROW = 1;

static NSString *CellIdentifier = @"Cell";

// Private methods
@interface FlipsideTableViewDataSource (Private)

-(UITableViewCellAccessoryType) accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*) cellForCameraRowAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*) tableView;
- (UITableViewCell*) cellForLensRowAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*) tableView;
- (UITableViewCell*) cellForUnitsRowAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*)tableView;
- (UITableViewCell*) standardCellForTableView:(UITableView*)tableView;

@end

@implementation FlipsideTableViewDataSource

@synthesize editing;

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	// When in edit mode, add one more row for inserting new items.
	int adjustment = [self isEditing] ? 1 : 0;
	
	if (section == CAMERAS_SECTION)
	{
		return [Camera count] + adjustment;
	}
	else if (section == LENSES_SECTION)
	{
		return [Lens count] + adjustment;
	}
	else
	{
		return UNITS_COUNT;
	}
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
	else
	{
		// Lenses section
		cell = [self cellForLensRowAtIndexPath:indexPath inTableView:tableView];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView 
	commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
	forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		if ([[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex] == [indexPath row])
		{
			// Camera being deleted is the currently selected one. Choose the one above.
			int newSelection = [indexPath row] - 1;
			if (newSelection < 0)
			{
				newSelection = 0;
			}
			
			[[NSUserDefaults standardUserDefaults] setInteger:newSelection 
													   forKey:FTCameraIndex];
			
			[[NSNotificationCenter defaultCenter] 
			 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
		}
		
		Camera* camera = [Camera findFromDefaultsForIndex:[indexPath row]];
		[Camera delete:camera];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
		Camera* camera = [Camera findFromDefaultsForIndex:[indexPath row]];
		[[NSNotificationCenter defaultCenter] postNotification:
			[NSNotification notificationWithName:CAMERA_SELECTED_FOR_EDIT_NOTIFICATION 
										  object:camera]];
	}
}

#pragma mark Helper methods

// Format table cell for rows in the cameras section of the table view.
- (UITableViewCell *) cellForCameraRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *) tableView
{
	int cameraCount = [Camera count];
	bool nonCameraRow = [indexPath row] >= cameraCount;
	
	UITableViewCell *cell = [self standardCellForTableView:tableView];
	
	if (nonCameraRow)
	{
		[[cell textLabel] setText:NSLocalizedString(@"ADD_CAMERA", "Add camera")];
	}
	else
	{
		Camera* camera = [Camera findFromDefaultsForIndex:[indexPath row]];
		[[cell textLabel] setText:[camera description]];
	}
	
	[cell setAccessoryType:[self accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath]];
	
	return cell;
}
							
-(UITableViewCellAccessoryType) accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
	if ([indexPath section] == CAMERAS_SECTION)
	{
		if ([self isEditing])
		{
			return UITableViewCellAccessoryDisclosureIndicator;
		}
		else
		{
			NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
			if ([indexPath row] == index)
			{
				return UITableViewCellAccessoryCheckmark;
			}
		}
	}
	else if ([indexPath section] == LENSES_SECTION)
	{
		if ([self isEditing])
		{
			return UITableViewCellAccessoryDisclosureIndicator;
		}
		else
		{
		}
	}
	else if ([indexPath section] == UNITS_SECTION)
	{
		bool metric = [[NSUserDefaults standardUserDefaults] boolForKey:FTMetricKey];
		if ((metric && [indexPath row] == METRES_ROW) || (!metric && [indexPath row] == FEET_ROW))
		{
			return UITableViewCellAccessoryCheckmark;
		}
	}
	
	return UITableViewCellAccessoryNone;
}
							
- (UITableViewCell*) cellForLensRowAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*) tableView
{
	int lensCount = [Lens count];
	bool nonLensRow = [indexPath row] >= lensCount;
	
	UITableViewCell *cell = [self standardCellForTableView:tableView];
	
	if (nonLensRow)
	{
		[[cell textLabel] setText:NSLocalizedString(@"ADD_LENS", "ADD LENS")];
	}
	else
	{
		[[cell textLabel] setText:[NSString stringWithFormat:@"Lens row %d", [indexPath row]]];
	}
	
	return cell;
}

// Format table cell for rows in the units section of the table view
- (UITableViewCell *) cellForUnitsRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*)tableView
{
	UITableViewCell *cell = [self standardCellForTableView:tableView];
	
	[[cell textLabel] setText:[indexPath row] == FEET_ROW ? NSLocalizedString(@"FEET", "Feet") : 
	 NSLocalizedString(@"METRES", "Metres")];
	
	[cell setAccessoryType:[self accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath]];

	return cell;
}

- (UITableViewCell *) standardCellForTableView: (UITableView *) tableView  
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero
				 reuseIdentifier:CellIdentifier] autorelease];
	}
	return cell;
}

@end
