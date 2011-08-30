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
//  SubjectDistanceRangesViewTableDataSource.m
//  FieldTools
//
//  Created by Brad Sokol on 2011-08-23.
//  Copyright 2011 by Brad Sokol. All rights reserved.
//

#import "SubjectDistanceRangesViewTableDataSource.h"

static const int NUM_SECTIONS = 1;
static const int NUM_ROWS = 3;

@implementation SubjectDistanceRangesViewTableDataSource

- (id)init
{
    self = [super init];
    if (self == nil) 
    {
        return nil;
    }
    
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return NUM_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";

	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero
				 reuseIdentifier:CellIdentifier] autorelease];
	}

    [[cell textLabel] setText:[NSString stringWithFormat:@"Subject distance range %d", [indexPath row]]];
    
    return cell;
}

@end
