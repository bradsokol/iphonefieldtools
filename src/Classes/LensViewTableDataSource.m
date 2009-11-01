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
//  LensViewTableDataSource.m
//  FieldTools
//
//  Created by Brad on 2009/09/28.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "LensViewTableDataSource.h"

#import "EditableTableViewCell.h"
#import "Lens.h"

#import "LensViewSections.h"

NSString* CellIdentifier = @"Cell";
NSString* EditableCellIdentifier = @"EditableCell";
NSString* EditableNumericCellIdentifier = @"EditableNumericCell";

@implementation LensViewTableDataSource

@synthesize lensIsZoom;
@synthesize controller;

- (Lens*)lens
{
	return lens;
}

- (void)setLens:(Lens*)aLens
{
	[lens release];
	[aLens retain];
	lens = aLens;
	
	lensIsZoom = [lens isZoom];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (TITLE_SECTION == section)
	{
		return 3;
	}
	else if (FOCAL_LENGTH_SECTION == section)
	{
		NSLog(@"Rows in focal length section: %d",lensIsZoom ? 2 : 1);
		return lensIsZoom ? 2 : 1;
	}
	else
	{
		return 2;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int tag = ([indexPath section] << 4) | [indexPath row];
		
	NSString* identifier;
	UIKeyboardType keyboardType = UIKeyboardTypeDefault;
	if (TITLE_SECTION == [indexPath section])
	{
		if (LENS_TITLE_ROW == [indexPath row])
		{
			identifier = EditableCellIdentifier;
		}
		else
		{
			identifier = CellIdentifier;
		}
	}
	else
	{
		identifier = EditableNumericCellIdentifier;
		keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	}
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (nil == cell)
	{
		if (TYPE_SECTION == [indexPath section] && [indexPath row] != LENS_TITLE_ROW)
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:identifier] autorelease];
		}
		else
		{
			cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero
												 reuseIdentifier:identifier
														delegate:[self controller]
													keyboardType:keyboardType
												   returnKeyType:UIReturnKeyDefault] autorelease];
		}
	}
	
	// Tag the cell with section and row so that the delegate can handle data
	[cell setTag:tag];
	NSLog(@"Tag for cell %08x is %04x", cell, [cell tag]);
	
	if (TYPE_SECTION == [indexPath section] && [indexPath row] != LENS_TITLE_ROW)
	{
		NSString* text = [indexPath row] == PRIME_ROW ? NSLocalizedString(@"LENS_TYPE_PRIME", "LENS_TYPE_PRIME") :
			NSLocalizedString(@"LENS_TYPE_ZOOM", "LENS_TYPE_ZOOM");
		[[cell textLabel] setText:text];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		
		if ([indexPath row] == PRIME_ROW && !lensIsZoom ||
			[indexPath row] == ZOOM_ROW && lensIsZoom)
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		else
		{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
	else
	{
		EditableTableViewCell* editableCell = (EditableTableViewCell*)cell;
		[editableCell setSelectionStyle:UITableViewCellSelectionStyleNone];

		if (TITLE_SECTION == [indexPath section])
		{
			[editableCell setLabel:NSLocalizedString(@"LENS_NAME_TITLE", "Name")];
			[editableCell setText:[lens description]];
		}
		else 
		{
			NSString* key = nil;
			if (lensIsZoom || [indexPath section] != FOCAL_LENGTH_SECTION)
			{
				int index = [indexPath row] + ([indexPath section] - 1) * 2;
				key = [NSString stringWithFormat:@"LENS_EDIT_%d", index];
			}
			else
			{
				key = @"LENS_EDIT_FOCAL_LENGTH";
			}

			[editableCell setLabel:NSLocalizedString(key, "Lens attribute label")];
			[editableCell setTextAlignment:UITextAlignmentRight];
			
			if (APERTURE_SECTION == [indexPath section])
			{
				NSNumber* apertureValue = [indexPath row] == 0 ? [lens maximumAperture] : [lens minimumAperture];
				[editableCell setText:[apertureValue description]];
			}
			else
			{
				NSNumber* focalLength = [indexPath row] == 0 ? [lens minimumFocalLength] : [lens maximumFocalLength];
				[editableCell setText:[focalLength description]];
			}
		}
	}
	
	return cell;
}

- (void)dealloc
{
	[self setLens:nil];
	
	[super dealloc];
}

@end
