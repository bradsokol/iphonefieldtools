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
//  GearCell.m
//  FieldTools
//
//  Created by Brad on 2008/11/15.
//

#import "GearCell.h"

@implementation GearCell

@synthesize name;
@synthesize type;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)reuseIdentifier
{
    if (nil == [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
	{
		return nil;
	}
	
	// Add the labels to the content view of the cell.
	
	// Important: although UITableViewCell inherits from UIView, you should add subviews to its content view
	// rather than directly to the cell so that they will be positioned appropriately as the cell transitions 
	// into and out of editing mode.
	
	[self.contentView addSubview:type];
	[self.contentView addSubview:name];

    return self;
}

- (void)dealloc
{
	[name release];
	[type release];

	[super dealloc];
}

@end
