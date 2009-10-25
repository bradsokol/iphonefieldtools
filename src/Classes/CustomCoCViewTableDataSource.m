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
//  CustomCoCViewTableDataSource.m
//  FieldTools
//
//  Created by Brad on 2009/10/19.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CustomCoCViewTableDataSource.h"

#import "Camera.h"
#import "CoC.h"
#import "EditableTableViewCell.h"

@implementation CustomCoCViewTableDataSource

@synthesize camera;
@synthesize controller;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString* EditableCellIdentifier = @"EditableCell";
	
	EditableTableViewCell* cell = 
		(EditableTableViewCell*) [tableView dequeueReusableCellWithIdentifier:EditableCellIdentifier];
	if (nil == cell)
	{
		cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero
											 reuseIdentifier:EditableCellIdentifier
													delegate:[self controller]
												keyboardType:UIKeyboardTypeNumbersAndPunctuation
											   returnKeyType:UIReturnKeyDefault] autorelease];
	}
	
	[cell setLabel:NSLocalizedString(@"COC", "COC")];
	
	if ([[[camera coc] description] compare:NSLocalizedString(@"CUSTOM_COC_DESCRIPTION", "CUSTOM")] == NSOrderedSame)
	{
		[cell setText:[NSString stringWithFormat:@"%.3f", [[camera coc] value]]];
	}
	
	[[cell textField] becomeFirstResponder];
	
	return cell;
}

- (void)dealloc
{
	[self setCamera:nil];
	
	[super dealloc];
}

@end
