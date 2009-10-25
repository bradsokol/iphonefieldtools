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

@interface LensViewController ()

- (void)cancelWasSelected;
- (NSString*)cellTextForRow:(int)row inSection:(int)section;
- (NSIndexPath*) nextCellForTag:(int)tag;
- (BOOL)validateAndLoadInput;
- (void)saveWasSelected;

@property(nonatomic, retain) Lens* lens;
@property(nonatomic, retain) Lens* lensWorking;
@property(nonatomic, retain) NSNumberFormatter* numberFormatter;
@property(nonatomic, retain) UIBarButtonItem* saveButton;

@end

@implementation LensViewController

@synthesize lens;
@synthesize lensWorking;
@synthesize numberFormatter;
@synthesize saveButton;
@synthesize tableViewDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	return [self initWithNibName:nibNameOrNil
						  bundle:nibBundleOrNil
   					     forLens:nil];
}

// The designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forLens:(Lens*)aLens
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (nil == self)
	{
		return nil;
	}

	[self setLens:aLens];
	if (nil != [self lens])
	{
		lensIsZoom = [[self lens] isZoom];
	}
	
	[self setLensWorking:[[[self lens] copy] autorelease]];
	
	UIBarButtonItem* cancelButton = 
	[[[UIBarButtonItem alloc] 
	  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel									 
	  target:self
	  action:@selector(cancelWasSelected)] autorelease];
	[self setSaveButton:[[[UIBarButtonItem alloc] 
	 initWithBarButtonSystemItem:UIBarButtonSystemItemSave	 
	 target:self
	 action:@selector(saveWasSelected)] autorelease]];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	
	[self setTitle:NSLocalizedString(@"LENS_VIEW_TITLE", "Lens view")];

	[self setNumberFormatter:[[[NSNumberFormatter alloc] init] autorelease]];
	
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
		[[self lens] setDescription:[[self lensWorking] description]];
		[[self lens] setMinimumAperture:[[self lensWorking] minimumAperture]];
		[[self lens] setMaximumAperture:[[self lensWorking] maximumAperture]];
		[[self lens] setMinimumFocalLength:[[self lensWorking] minimumFocalLength]];
		[[self lens] setMaximumFocalLength:[[self lensWorking] maximumFocalLength]];
		
		if (!lensIsZoom)
		{
			[[self lens] setMaximumFocalLength:[[self lens] minimumFocalLength]];
		}

		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:LENS_WAS_EDITED_NOTIFICATION
																							 object:[self lens]]];
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	// Force the keyboard to hide by asking editable cells to resign as first responder
	EditableTableViewCell* cell = (EditableTableViewCell*)[tableView dequeueReusableCellWithIdentifier:EditableCellIdentifier];
	[[cell textField] resignFirstResponder];
	cell = (EditableTableViewCell*)[tableView dequeueReusableCellWithIdentifier:EditableNumericCellIdentifier];
	[[cell textField] resignFirstResponder];
	
	
	// ALl cells except the type section have a UITextField. If the cell is touched 
	// anywhere, not just in the text field, make the text field the first responder.
	if ([indexPath section] != TYPE_SECTION)
	{
		EditableTableViewCell* editableCell = 
			(EditableTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
		[[editableCell textField] becomeFirstResponder];
		
		return;
	}
	
	// From this point on we're handling only the type section cells.
	
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
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
	[[self tableViewDataSource] setLens:[self lensWorking]];
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
	NSString* description = [[self lensWorking] description];
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
	
	NSNumber* maximumAperture = [[self lensWorking] maximumAperture];
	NSNumber* minimumAperture = [[self lensWorking] minimumAperture];
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
	
	NSNumber* minimumFocalLength = [[self lensWorking] minimumFocalLength];
	NSNumber* maximumFocalLength = [[self lensWorking] maximumFocalLength];
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

- (NSIndexPath*) nextCellForTag:(int)tag
{
	int section = (tag & SECTION_MASK) >> SECTION_SHIFT;
	int row = tag & ROW_MASK;
	
	if (section == TITLE_SECTION)
	{
		return [NSIndexPath indexPathForRow:0 inSection:section + 1];
	}
	else if (section == FOCAL_LENGTH_SECTION)
	{
		if (row == 0 && lensIsZoom)
		{
			return [NSIndexPath indexPathForRow:1 inSection:section];
		}
		else
		{
			return [NSIndexPath indexPathForRow:0 inSection:section + 1];
		}
	}
	else
	{
		// Aperture section
		if (row == 0)
		{
			return [NSIndexPath indexPathForRow:1 inSection:section];
		}
		else
		{
			return nil;
		}
	}

	return nil;
}

#pragma mark UITextViewDelegate methods

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
		[[self lensWorking] setDescription:[textField text]];
		NSLog(@"Set description to %@", [[self lensWorking] description]);
	}
	else
	{
		if (APERTURE_SECTION == section)
		{
			if (row == 0)
			{
				[[self lensWorking] setMaximumAperture:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set maximum aperture to %@", [[self lensWorking] maximumAperture]);
			}
			else 
			{
				[[self lensWorking] setMinimumAperture:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set minimum aperture to %@", [[self lensWorking] minimumAperture]);
			}

		}
		else if (FOCAL_LENGTH_SECTION == section)
		{
			if (row == 0)
			{
				[[self lensWorking] setMinimumFocalLength:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set minimum focal length to %@", [[self lensWorking] minimumFocalLength]);
			}
			else
			{
				[[self lensWorking] setMaximumFocalLength:[numberFormatter numberFromString:[textField text]]];
				NSLog(@"Set maximum focal length to %@", [[self lensWorking] maximumFocalLength]);
			}
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSIndexPath* nextCellPath = [self nextCellForTag:[[textField superview] tag]];
	if (nil == nextCellPath)
	{
		return YES;
	}
	
	NSLog(@"Next cell is section %d row %d", [nextCellPath section], [nextCellPath row]);
	[textField resignFirstResponder];
	
	UITableView* tableView = (UITableView*)[self view];
	[tableView scrollToRowAtIndexPath:nextCellPath
					 atScrollPosition:UITableViewScrollPositionBottom
							 animated:YES];
	EditableTableViewCell* nextCell = (EditableTableViewCell*)[tableView cellForRowAtIndexPath:nextCellPath];
	[[nextCell textField] becomeFirstResponder];
	
	return NO;
}

- (void)dealloc 
{
	[self setSaveButton:nil];
	[self setLens:nil];
	[self setLensWorking:nil];
	[self setNumberFormatter:nil];

    [super dealloc];
}

@end

