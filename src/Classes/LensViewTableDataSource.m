// Copyright 2009-2025 Brad Sokol
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
//  Copyright 2009-2025 Brad Sokol. 
//

#import "LensViewTableDataSource.h"

#import "FTLens.h"
#import "LensViewController.h"

#import "LensViewSections.h"

NSString* CellIdentifier = @"Cell";

@implementation LensViewTableDataSource

@synthesize lensIsZoom;
@synthesize controller;

- (FTLens*)lens
{
	return lens;
}

- (void)setLens:(FTLens*)aLens
{
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
		DLog(@"Rows in focal length section: %d",lensIsZoom ? 2 : 1);
		return lensIsZoom ? 2 : 1;
	}
	else
	{
		return 2;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger tag = ([indexPath section] << 4) | [indexPath row];
	LensViewController* lensViewController = (LensViewController*) [self controller];
		
	UITableViewCell* cell;

	if (TITLE_SECTION == [indexPath section])
	{
		if (LENS_TITLE_ROW == [indexPath row])
		{
			cell = [lensViewController lensNameCell];
		}
		else
		{
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (nil == cell)
			{
				cell = [[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:CellIdentifier];
			}
		}
	}
	else
	{
		if (APERTURE_SECTION == [indexPath section])
		{
			cell = (0 == [indexPath row]) ? [lensViewController maximumApertureCell] : [lensViewController minimumApertureCell];
		}
		else
		{
			cell = (0 == [indexPath row]) ? [lensViewController minimumFocalLengthCell] : [lensViewController maximumFocalLengthCell];
		}
	}
	
	// Tag the cell with section and row so that the delegate can handle data
	[cell setTag:tag];
	DLog(@"Tag for cell %08lx is %04lx", (unsigned long) cell, (long)[cell tag]);
	
	if (TYPE_SECTION == [indexPath section] && [indexPath row] != LENS_TITLE_ROW)
	{
		NSString* text = [indexPath row] == PRIME_ROW ? NSLocalizedString(@"LENS_TYPE_PRIME", "LENS_TYPE_PRIME") :
			NSLocalizedString(@"LENS_TYPE_ZOOM", "LENS_TYPE_ZOOM");
		[[cell textLabel] setText:text];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		
		if (([indexPath row] == PRIME_ROW && !lensIsZoom) ||
			([indexPath row] == ZOOM_ROW && lensIsZoom))
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
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

		if (TITLE_SECTION == [indexPath section])
		{
			[[lensViewController lensNameLabel] setText:NSLocalizedString(@"LENS_NAME_TITLE", "Name")];
			[[lensViewController lensNameField] setText:[lens description]];
		}
		else 
		{
			NSString* key = nil;
			if (lensIsZoom || [indexPath section] != FOCAL_LENGTH_SECTION)
			{
				NSInteger index = [indexPath row] + ([indexPath section] - 1) * 2;
				key = [NSString stringWithFormat:@"LENS_EDIT_%ld", (long)index];
			}
			else
			{
				key = @"LENS_EDIT_FOCAL_LENGTH";
			}
			
			if (APERTURE_SECTION == [indexPath section])
			{
				if ([indexPath row] == 0)
				{
					[[lensViewController maximumApertureLabel] setText:NSLocalizedString(key, "Lens attribute label")];
					[[lensViewController maximumApertureField] setText:[[lens maximumAperture] description]];
				}
				else
				{
					[[lensViewController minimumApertureLabel] setText:NSLocalizedString(key, "Lens attribute label")];
					[[lensViewController minimumApertureField] setText:[[lens minimumAperture] description]];
				}
			}
			else
			{
				if ([indexPath row] == 0)
				{
					[[lensViewController minimumFocalLengthLabel] setText:NSLocalizedString(key, "Lens attribute label")];
					[[lensViewController minimumFocalLengthField] setText:[[lens minimumFocalLength] description]];
				}
				else
				{
					[[lensViewController maximumFocalLengthLabel] setText:NSLocalizedString(key, "Lens attribute label")];
					[[lensViewController maximumFocalLengthField] setText:[[lens maximumFocalLength] description]];
				}
			}
		}
	}
	
	return cell;
}

- (void)dealloc
{
	[self setLens:nil];
	
}

@end
