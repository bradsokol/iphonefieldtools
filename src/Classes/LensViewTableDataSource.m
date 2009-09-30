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

static const int SECTION_COUNT = 3;
static const int TITLE_SECTION = 0;
static const int APERTURE_SECTION = 1;
static const int FOCAL_LENGTH_SECTION = 2;


@interface LensViewTableDataSource (Private)

- (NSString*)formatForAperture:(float)value;

@end

@implementation LensViewTableDataSource

@synthesize lens;
@synthesize controller;

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return section == TITLE_SECTION ? 1 : section == APERTURE_SECTION ? 2 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString* EditableCellIdentifier = @"EditableCell";
	
	EditableTableViewCell* cell = 
		(EditableTableViewCell*) [tableView dequeueReusableCellWithIdentifier:EditableCellIdentifier];
	if (nil == cell)
	{
		cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero
											 reuseIdentifier:EditableCellIdentifier
													delegate:[self controller]] autorelease];
	}
	
	if (TITLE_SECTION == [indexPath section])
	{
		[cell setLabel:NSLocalizedString(@"LENS_NAME_TITLE", "Name")];
		[cell setText:[lens description]];
	}
	else 
	{
		int index = [indexPath row] + ([indexPath section] - 1) * 2;
		NSString* key = [NSString stringWithFormat:@"LENS_EDIT_%d", index];
		[cell setLabel:NSLocalizedString(key, "Lens attribute label")];
		[cell setTextAlignment:UITextAlignmentRight];

		if (APERTURE_SECTION == [indexPath section])
		{
			float apertureValue = [indexPath row] == 0 ? [lens maximumAperture] : [lens minimumAperture];
			[cell setText:[NSString stringWithFormat:[self formatForAperture:apertureValue], apertureValue]];
		}
		else
		{
			int focalLength = [indexPath row] == 0 ? [lens minimumFocalLength] : [lens maximumFocalLength];
			[cell setText:[NSString stringWithFormat:@"%d", focalLength]];
		}
	}
	
	return cell;
}

- (NSString*)formatForAperture:(float)value
{
	if (floor(value + 0.9) == floor(value))
	{
		return @"%.0f";
	}
	else
	{
		return @"%.1f";
	}
}

@end
