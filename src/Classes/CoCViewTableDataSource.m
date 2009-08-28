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

//
//  CoCViewTableDataSource.m
//  FieldTools
//
//  Created by Brad on 2009/08/23.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CoCViewTableDataSource.h"

#import "Camera.h"
#import "CoC.h"
#import "TwoLabelTableViewCell.h"

static const int NUM_SECTIONS = 1;

int cocPresetsCount = 0;

@implementation CoCViewTableDataSource

@synthesize camera;
@synthesize controller;

- (id)init
{
	if (nil == [super init])
	{
		return nil;
	}
	
	if (cocPresetsCount == 0)
	{
		cocPresetsCount = [[CoC cocPresets] count];
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	// Return one extra row for the custom setting
	return [[CoC cocPresets] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TwoLabelTableViewCell* cell = (TwoLabelTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		cell = [[[TwoLabelTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
    }
    
	if ([indexPath row] < cocPresetsCount)
	{
		NSArray* keys = [[CoC cocPresets] allKeys];
		NSArray* sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		NSString* key = [sortedKeys objectAtIndex:[indexPath row]];
		[cell setText:[NSString stringWithFormat:@"%.3f", [[[CoC cocPresets] objectForKey:key] floatValue]]];
		[cell setLabel:key];
		
		if ([key compare:[[camera coc] description]] == 0)
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
	}
	else
	{
		[cell setLabel:NSLocalizedString(@"CUSTOM_COC_DESCRIPTION", "CUSTOM")];
		[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	}
	
    return cell;
}

@end
