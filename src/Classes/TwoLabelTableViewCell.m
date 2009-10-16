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
//  TwoLabelTableViewCell.h
//  FieldTools
//
//  Created by Brad on 2009/07/20.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "TwoLabelTableViewCell.h"

@implementation TwoLabelTableViewCell

#define LEFT_COLUMN_OFFSET		10
#define LEFT_COLUMN_WIDTH		200
		
#define UPPER_ROW_TOP			0

- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	if (nil == self)
	{
		return nil;
	}

	// Create label views to contain the various pieces of text that make up the cell.
	// Add these as subviews.
	label = [[UILabel alloc] initWithFrame:CGRectZero];	// layoutSubViews will decide the final frame
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textColor = [UIColor blackColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	[self.contentView addSubview:label];
	
	text = [[UILabel alloc] initWithFrame:CGRectZero];	// layoutSubViews will decide the final frame
	text.backgroundColor = [UIColor clearColor];
	text.opaque = NO;
	text.textColor = [UIColor grayColor];
	text.highlightedTextColor = [UIColor whiteColor];
	text.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	text.textAlignment = UITextAlignmentRight;
	[self.contentView addSubview:text];
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
    CGRect contentRect = [[self contentView] bounds];
	CGFloat rowHeight = [(UITableView*)[self superview] rowHeight] - 4.0;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    CGRect frame = CGRectMake(contentRect.origin.x + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, rowHeight);
	label.frame = frame;
	
	frame = CGRectMake(contentRect.origin.x + 65.0 + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, rowHeight);
	text.frame = frame;
}

- (void)setLabel:(NSString*)s
{
	[label setText:s];
}

- (void)setText:(NSString*)s
{
	[text setText:s];
}

- (void)dealloc
{
	[label release];
	[text release];

    [super dealloc];
}

@end
