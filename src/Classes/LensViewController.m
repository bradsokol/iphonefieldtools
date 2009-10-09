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
//  LensViewController.m
//  FieldTools
//
//  Created by Brad on 2009/09/28.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "LensViewController.h"

#import "EditableTableViewCell.h"
#import "Lens.h"
#import "LensViewTableDataSource.h"

#import "LensViewSections.h"
#import "Notifications.h"

static const int ROW_MASK = 0x0f;
static const int SECTION_MASK = 0xf0;
static const int SECTION_SHIFT = 4;

static const float APERTURE_LOWER_LIMIT = 0.0;
static const float APERTURE_UPPER_LIMIT = 100.0;
static const float FOCAL_LENGTH_LOWER_LIMIT = 0.0;
static const float FOCAL_LENGTH_UPPER_LIMIT = 2000.0;

static const float SectionHeaderHeight = 44.0;

@interface LensViewController (Private)

- (void)cancelWasSelected;
- (NSString*)cellTextForRow:(int)row inSection:(int)section;
- (BOOL)validateAndLoadInput;
- (void)saveWasSelected;

@end

@implementation LensViewController

@synthesize tableViewDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	return [self initWithNibName:nibNameOrNil
						  bundle:nibBundleOrNil
   					     forLens:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forLens:(Lens*)aLens
{
	if (nil == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		return nil;
	}

	lens = aLens;
	if (nil != lens)
	{
		[lens retain];
		lensIsZoom = [lens isZoom];
	}
	
	lensWorkingCopy = [[Lens alloc] initWithDescription:[lens description]
										minimumAperture:[lens minimumAperture]
										maximumAperture:[lens maximumAperture]
									 minimumFocalLength:[lens minimumFocalLength]
									 maximumFocalLength:[lens maximumFocalLength]
											 identifier:[lens identifier]];
	
	UIBarButtonItem* cancelButton = 
	[[[UIBarButtonItem alloc] 
	  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel									 
	  target:self
	  action:@selector(cancelWasSelected)] autorelease];
	saveButton = 
	[[UIBarButtonItem alloc] 
	 initWithBarButtonSystemItem:UIBarButtonSystemItemSave	 
	 target:self
	 action:@selector(saveWasSelected)];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	
	[self setTitle:NSLocalizedString(@"LENS_VIEW_TITLE", "Lens view")];

	numberFormatter = [[NSNumberFormatter alloc] init];
	
	return self;
}

- (void)cancelWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
	[[NSNotificationCenter defaultCenter] postNotificationName:SAVING_NOTIFICATION
														object:self];
	
	if ([self validateAndLoadInput])
	{
		[lens setDescription:[lensWorkingCopy description]];
		[lens setMinimumAperture:[lensWorkingCopy minimumAperture]];
		[lens setMaximumAperture:[lensWorkingCopy maximumAperture]];
		[lens setMinimumFocalLength:[lensWorkingCopy minimumFocalLength]];
		[lens setMaximumFocalLength:[lensWorkingCopy maximumFocalLength]];
		
		if (!lensIsZoom)
		{
			[lens setMaximumFocalLength:[lens minimumFocalLength]];
		}

		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:LENS_WAS_EDITED_NOTIFICATION
																							 object:lens]];
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
}

#pragma mark "UITableViewDelegateMethods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
	if ([indexPath section] != TYPE_SECTION)
	{
		return;
	}
	
	// Force the keyboard to hide by finding the first responder and asking it to resign.
	UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
	if (keyWindow)
	{
		UIView* firstResponder = [keyWindow performSelector:@selector(firstResponder)];
		[firstResponder resignFirstResponder];
	}
	
	NSIndexPath* oldIndexPath = [NSIndexPath indexPathForRow:lensIsZoom ? ZOOM_ROW : PRIME_ROW
												   inSection:[indexPath section]];
	
	if ([oldIndexPath row] == [indexPath row])
	{
		// User selected the currently selected lens type - take no action
		return;
	}
	
	UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
	if ([newCell accessoryType] == UITableViewCellAccessoryNone)
	{
		// Selected row is not the current type so change the selection
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		lensIsZoom = !lensIsZoom;
		[tableViewDataSource setLensIsZoom:lensIsZoom];
		
		[tableView reloadSections:[NSIndexSet indexSetWithIndex:FOCAL_LENGTH_SECTION]
				 withRowAnimation:UITableViewRowAnimationNone];
	}
	
	UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if ([oldCell accessoryType] == UITableViewCellAccessoryCheckmark)
	{
		[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	}
}
	
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return section == TITLE_SECTION ? 0 : SectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return nil;
	}
	
	NSString* headerText = nil;
	switch (section)
	{
		case APERTURE_SECTION:
			headerText = NSLocalizedString(@"LENS_VIEW_APERTURE_SECTION_TITLE", "LENS_VIEW_APERTURE_SECTION_TITLE");
			break;
		case FOCAL_LENGTH_SECTION:
			headerText = NSLocalizedString(@"LENS_VIEW_FOCAL_LENGTH_SECTION_TITLE", "LENS_VIEW_FOCAL_LENGTH_SECTION_TITLE");
			break;
		case TYPE_SECTION:
			headerText = NSLocalizedString(@"LENS_VIEW_TYPE_SECTION_TITLE", "LENS_VIEW_TYPE_SECTION_TITLE");
			break;
	}
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(18, 0, 320, SectionHeaderHeight)] autorelease];
	UILabel *label = [[[UILabel alloc] initWithFrame:headerView.frame] autorelease];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor blackColor]];
	[label setText:headerText];
	[label setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
	
	[headerView addSubview:label];
	return headerView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	[self setTableViewDataSource: (LensViewTableDataSource*)[[self tableView] dataSource]];
	[[self tableViewDataSource] setLens:lensWorkingCopy];
	[[self tableViewDataSource] setController:self];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (NSString*)cellTextForRow:(int)row inSection:(int)section
{
	UITableView* tableView = (UITableView*)[self view];
	EditableTableViewCell* cell = 
		(EditableTableViewCell*) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
	return [cell text];
}

- (BOOL)validateAndLoadInput
{
	NSString* description = [lensWorkingCopy description];
	if (description == nil || [description length] == 0)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LENS_DATA_VALIDATION_ERROR", "LENS_DATA_VALIDATION_ERROR")
														message:NSLocalizedString(@"LENS_ERROR_MISSING_NAME", "LENS_ERROR_MISSING_NAME")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"CLOSE_BUTTON_LABEL", "CLOSE_BUTTON_LABEL")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}
	
	NSNumber* maximumAperture = [lensWorkingCopy maximumAperture];
	NSNumber* minimumAperture = [lensWorkingCopy minimumAperture];
	if (nil == maximumAperture || nil == minimumAperture || 
		[maximumAperture floatValue] <= APERTURE_LOWER_LIMIT || [maximumAperture floatValue] >= APERTURE_UPPER_LIMIT ||
		[minimumAperture floatValue] <= APERTURE_LOWER_LIMIT || [minimumAperture floatValue] >= APERTURE_UPPER_LIMIT)
	{
		NSString* message = [NSString stringWithFormat:NSLocalizedString(@"LENS_ERROR_BAD_APERTURE", "LENS_ERROR_BAD_APERTURE"),
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:APERTURE_LOWER_LIMIT]],
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:APERTURE_UPPER_LIMIT]]];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LENS_DATA_VALIDATION_ERROR", "LENS_DATA_VALIDATION_ERROR")
														message:message
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"CLOSE_BUTTON_LABEL", "CLOSE_BUTTON_LABEL")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}
	
	NSNumber* minimumFocalLength = [lensWorkingCopy minimumFocalLength];
	NSNumber* maximumFocalLength = [lensWorkingCopy maximumFocalLength];
	if (nil == minimumFocalLength || nil == maximumFocalLength || 
		[minimumFocalLength floatValue] <= FOCAL_LENGTH_LOWER_LIMIT || [minimumFocalLength floatValue] >= FOCAL_LENGTH_UPPER_LIMIT ||
		[maximumFocalLength floatValue] <= FOCAL_LENGTH_LOWER_LIMIT || [maximumFocalLength floatValue] >= FOCAL_LENGTH_UPPER_LIMIT)
	{
		NSString* message = [NSString stringWithFormat:NSLocalizedString(@"LENS_ERROR_BAD_FOCAL_LENGTH", "LENS_ERROR_BAD_FOCAL_LENGTH"),
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:FOCAL_LENGTH_LOWER_LIMIT]],
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:FOCAL_LENGTH_UPPER_LIMIT]]];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LENS_DATA_VALIDATION_ERROR", "LENS_DATA_VALIDATION_ERROR")
														message:message
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"CLOSE_BUTTON_LABEL", "CLOSE_BUTTON_LABEL")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}
	
	return YES;
}

// UITextViewDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	// The super view of the text field is the cell. The cell's tag identifies
	// which field. Bits 4-7 are the section, bits 0-3 the row.
	NSInteger tag = [[textField superview] tag];
	int section = (tag & SECTION_MASK) >> SECTION_SHIFT;
	int row = tag & ROW_MASK;
	NSLog(@"Text field did end editing for section %d row %d for cell %08x", section, row, [textField superview]);
	
	if (TITLE_SECTION == section)
	{
		[lensWorkingCopy setDescription:[textField text]];
		NSLog(@"Set description to %@", [lensWorkingCopy description]);
	}
	else
	{
		if (APERTURE_SECTION == section)
		{
			if (row == 0)
			{
				[lensWorkingCopy setMaximumAperture:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set maximum aperture to %@", [lensWorkingCopy maximumAperture]);
			}
			else 
			{
				[lensWorkingCopy setMinimumAperture:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set minimum aperture to %@", [lensWorkingCopy minimumAperture]);
			}

		}
		else if (FOCAL_LENGTH_SECTION == section)
		{
			if (row == 0)
			{
				[lensWorkingCopy setMinimumFocalLength:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set minimum focal length to %@", [lensWorkingCopy minimumFocalLength]);
			}
			else
			{
				[lensWorkingCopy setMaximumFocalLength:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set maximum focal length to %@", [lensWorkingCopy maximumFocalLength]);
			}
		}
	}
}

- (void)dealloc 
{
	[saveButton release];
	[lens release];
	[lensWorkingCopy release];
	[numberFormatter release];

    [super dealloc];
}

@end

