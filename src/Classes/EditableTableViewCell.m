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
//  EditableTableViewCell.m
//  FieldTools
//
//  Created by Brad on 2009/07/02.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "EditableTableViewCell.h"

#import "Notifications.h"

#define LEFT_COLUMN_OFFSET		10
#define LEFT_COLUMN_WIDTH		225

#define UPPER_ROW_TOP			0

@implementation EditableTableViewCell

@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate
{
	return [self initWithFrame:frame reuseIdentifier:reuseIdentifier delegate:delegate keyboardType:UIKeyboardTypeDefault];
}

// The designated initializer
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate keyboardType:(UIKeyboardType)aKeyboardType
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (nil == self)
	{
		return nil;
    }
	
	// Create label views to contain the various pieces of text that make up the cell.
	// Add these as subviews.
	label = [[UILabel alloc] initWithFrame:CGRectZero];	// layoutSubViews will decide the final frame
	[label setBackgroundColor:[UIColor clearColor]];
	[label setOpaque:NO];
	[label setTextColor:[UIColor blackColor]];
	[label setHighlightedTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
	[[self contentView] addSubview:label];
	
	textField = [[UITextField alloc] initWithFrame:CGRectZero];
	[textField setKeyboardType:aKeyboardType];
	[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[textField setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
	[textField setTextColor:[UIColor darkGrayColor]];
	[textField setDelegate:delegate];
	
	[self addSubview:textField];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(saving:)
												 name:SAVING_NOTIFICATION
											   object:nil];
	
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

    CGRect contentRect = [[self contentView] bounds];
	
	CGFloat rowHeight = [(UITableView*)[self superview] rowHeight] - 4.0;
	
    CGRect frame = CGRectMake(contentRect.origin.x + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, rowHeight);
	[label setFrame:frame];
	
	frame = CGRectMake(contentRect.origin.x + 65.0 + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP + 2.0, LEFT_COLUMN_WIDTH, rowHeight);
	[textField setFrame:frame];
}
	
- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];

    // Update the text colour so that it matches expected selection behaviour
	[textField setTextColor:selected ? [UIColor whiteColor] : [UIColor darkGrayColor]];
}

- (void)setLabel:(NSString*)s
{
	[label setText:s];
}

- (NSString*)text
{
	return [textField text];
}

- (void)setText:(NSString*)s
{
	[textField setText:s];
}

- (void)saving:(NSNotification*)notification
{
	if ([textField isFirstResponder])
	{
		[textField resignFirstResponder];
	}
}

- (void)setTextAlignment:(UITextAlignment)alignment
{
	[textField setTextAlignment:alignment];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	NSLog(@"Release text field %p cell tag %d",textField, [self tag]);
	[textField release]; 
	textField = nil;
	[label release]; 
	label = nil;
	
    [super dealloc];
}

@end
