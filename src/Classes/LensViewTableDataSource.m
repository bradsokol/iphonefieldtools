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

static const int SECTION_COUNT = 1;
static const int ROW_COUNT = 5;

@interface LensViewTableDataSource (Private)

- (NSString*)formatAperture:(float)value;

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
	return ROW_COUNT;
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
	
	if (0 == [indexPath row])
	{
		[cell setLabel:NSLocalizedString(@"LENS_NAME_TITLE", "Name")];
		[cell setText:[lens description]];
	}
	else
	{
		NSString* key = [NSString stringWithFormat:@"LENS_EDIT_%d", [indexPath row] - 1];
		[cell setLabel:NSLocalizedString(key, "Lens attribute label")];
		[cell setTextAlignment:UITextAlignmentRight];
		
		switch ([indexPath row])
		{
			case 1:
				[cell setText:[NSString stringWithFormat:[self formatAperture:[lens maximumAperture]], [lens maximumAperture]]];
				break;
			case 2:
				[cell setText:[NSString stringWithFormat:[self formatAperture:[lens minimumAperture]], [lens minimumAperture]]];
				break;
			case 3:
				[cell setText:[NSString stringWithFormat:@"%d", [lens minimumFocalLength]]];
				break;
			case 4:
				[cell setText:[NSString stringWithFormat:@"%d", [lens maximumFocalLength]]];
				break;
		}
	}
	
	return cell;
}

- (NSString*)formatAperture:(float)value
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
