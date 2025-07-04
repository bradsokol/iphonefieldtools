// Copyright 2009-2025 Brad Sokol
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
//  Copyright 2009-2025 Brad Sokol. 
//

#import "LensViewController.h"

#import "FTLens.h"
#import "LensViewTableDataSource.h"

#import "FTCameraBag.h"
#import "LensViewSections.h"
#import "Notifications.h"

static const int TEXT_FIELD_TAG = 99;

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
- (UITableViewCell*)cellForView:(UIView*)view;
- (NSString*)cellTextForRow:(NSInteger)row inSection:(NSInteger)section;
- (NSIndexPath*) nextCellForTag:(NSInteger)tag;
- (void)resignAllFirstResponders;
- (BOOL)validateAndLoadInput;
- (void)saveWasSelected;

@property(nonatomic, strong) FTLens* lens;
@property(nonatomic, getter=isNewLens) bool newLens;
@property(nonatomic, strong) NSNumberFormatter* numberFormatter;
@property(nonatomic, strong) UIBarButtonItem* saveButton;

@end

@implementation LensViewController

@synthesize lens;
@synthesize lensNameField;
@synthesize lensNameCell;
@synthesize lensNameLabel;
@synthesize maximumApertureField;
@synthesize maximumApertureCell;
@synthesize maximumApertureLabel;
@synthesize minimumApertureField;
@synthesize minimumApertureCell;
@synthesize minimumApertureLabel;
@synthesize maximumFocalLengthField;
@synthesize maximumFocalLengthCell;
@synthesize maximumFocalLengthLabel;
@synthesize minimumFocalLengthField;
@synthesize minimumFocalLengthCell;
@synthesize minimumFocalLengthLabel;
@synthesize newLens;
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forLens:(FTLens*)aLens
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
	
	[self setNewLens:[[[self lens] description] length] == 0];
	
	UIBarButtonItem* cancelButton = 
	[[UIBarButtonItem alloc] 
	  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel									 
	  target:self
	  action:@selector(cancelWasSelected)];
	[self setSaveButton:[[UIBarButtonItem alloc] 
	 initWithBarButtonSystemItem:UIBarButtonSystemItemSave	 
	 target:self
	 action:@selector(saveWasSelected)]];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	
	[self setTitle:NSLocalizedString(@"LENS_VIEW_TITLE", "Lens view")];

	[self setNumberFormatter:[[NSNumberFormatter alloc] init]];
	
	return self;
}

- (void)cancelWasSelected
{
    [[FTCameraBag sharedCameraBag] rollback];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
	[self resignAllFirstResponders];
	
	if ([self validateAndLoadInput])
	{
		if (!lensIsZoom)
		{
			[[self lens] setMaximumFocalLength:[[self lens] minimumFocalLength]];
		}
		
		NSString* notificationName = [self isNewLens] ? LENS_WAS_ADDED_NOTIFICATION : LENS_WAS_EDITED_NOTIFICATION;

		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notificationName
																							 object:[self lens]]];
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
}

- (void) resignAllFirstResponders 
{
	// Force the keyboard to hide by asking editable cells to resign as first responder
	[[self lensNameField] resignFirstResponder];
	[[self minimumApertureField] resignFirstResponder];
	[[self maximumApertureField] resignFirstResponder];
	[[self minimumFocalLengthField] resignFirstResponder];
	[[self maximumFocalLengthField] resignFirstResponder];
	
}

- (UITableViewCell*)cellForView:(UIView*)view
{
	if (view == nil)
	{
		return nil;
	}
	
	for (;;)
	{
		if ([view isKindOfClass:[UITableViewCell class]])
		{
			return (UITableViewCell*)view;
		}
		
		view = [view superview];
		if (view == nil)
		{
			return nil;
		}
	}
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[self resignAllFirstResponders];

	// All cells except the first two of the type section have a UITextField. If the cell is touched 
	// anywhere, not just in the text field, make the text field the first responder.
	if ([indexPath section] != TYPE_SECTION ||
		([indexPath section] == TYPE_SECTION && [indexPath row] == LENS_TITLE_ROW))
	{
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
		UITextField* textField = (UITextField*)[cell viewWithTag:TEXT_FIELD_TAG];
		NSAssert(textField != nil, @"No text field found");
		[textField becomeFirstResponder];
		
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

		// We should use reloadSections but when used, the inserted or deleted
		// row vanishes after briefly being displayed. reloadData does not
		// have that issue.
		[tableView reloadData];
//		[tableView reloadSections:[NSIndexSet indexSetWithIndex:FOCAL_LENGTH_SECTION]
//				 withRowAnimation:UITableViewRowAnimationNone];
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
	if (section == TITLE_SECTION)
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
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 320, SectionHeaderHeight)];
	UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
	[label setText:headerText];
	[label setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
	
	[headerView addSubview:label];
	return headerView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self setTableViewDataSource: (LensViewTableDataSource*)[[self tableView] dataSource]];
	[[self tableViewDataSource] setLens:[self lens]];
	[[self tableViewDataSource] setController:self];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (NSString*)cellTextForRow:(NSInteger)row inSection:(NSInteger)section
{
	UITableView* tableView = (UITableView*)[self view];
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
	UITextField* textField = (UITextField*)[cell viewWithTag:TEXT_FIELD_TAG];
	NSAssert(textField != nil, @"No text field found");
	
	return [textField text];
}

- (BOOL)validateAndLoadInput
{
	NSString* description = [[self lens] description];
	if (description == nil || [description length] == 0)
	{
        [self presentDataValidationAlertWithMessage:NSLocalizedString(@"LENS_ERROR_MISSING_NAME", "LENS_ERROR_MISSING_NAME")];

		return NO;
	}
	
	NSNumber* maximumAperture = [[self lens] maximumAperture];
	NSNumber* minimumAperture = [[self lens] minimumAperture];
	if (nil == maximumAperture || nil == minimumAperture || 
		[maximumAperture floatValue] <= APERTURE_LOWER_LIMIT || [maximumAperture floatValue] >= APERTURE_UPPER_LIMIT ||
		[minimumAperture floatValue] <= APERTURE_LOWER_LIMIT || [minimumAperture floatValue] >= APERTURE_UPPER_LIMIT)
	{
		NSString* message = [NSString stringWithFormat:NSLocalizedString(@"LENS_ERROR_BAD_APERTURE", "LENS_ERROR_BAD_APERTURE"),
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:APERTURE_LOWER_LIMIT]],
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:APERTURE_UPPER_LIMIT]]];
        [self presentDataValidationAlertWithMessage:message];

		return NO;
	}
	
	NSNumber* minimumFocalLength = [[self lens] minimumFocalLength];
	NSNumber* maximumFocalLength = [[self lens] maximumFocalLength];
	if (nil == minimumFocalLength || nil == maximumFocalLength || 
		[minimumFocalLength floatValue] <= FOCAL_LENGTH_LOWER_LIMIT || [minimumFocalLength floatValue] >= FOCAL_LENGTH_UPPER_LIMIT ||
		[maximumFocalLength floatValue] <= FOCAL_LENGTH_LOWER_LIMIT || [maximumFocalLength floatValue] >= FOCAL_LENGTH_UPPER_LIMIT)
	{
		NSString* message = [NSString stringWithFormat:NSLocalizedString(@"LENS_ERROR_BAD_FOCAL_LENGTH", "LENS_ERROR_BAD_FOCAL_LENGTH"),
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:FOCAL_LENGTH_LOWER_LIMIT]],
							 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:FOCAL_LENGTH_UPPER_LIMIT]]];
        [self presentDataValidationAlertWithMessage:message];
		
		return NO;
	}
	
	return YES;
}

- (NSIndexPath*) nextCellForTag:(NSInteger)tag
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

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	// The super view of the text field is the cell. The cell's tag identifies
	// which field. Bits 4-7 are the section, bits 0-3 the row.
	UITableViewCell* cell = [self cellForView:textField];
	NSInteger tag = [cell tag];
	int section = (tag & SECTION_MASK) >> SECTION_SHIFT;
	int row = tag & ROW_MASK;
    DLog(@"Text field %08lx did end editing for section %d row %d for cell %08lx", 
          (unsigned long) textField, section, row, (unsigned long) cell);
	
	if (TITLE_SECTION == section)
	{
		[[self lens] setName:[textField text]];
		DLog(@"Set description to %@", [[self lens] description]);
	}
	else
	{
		if (APERTURE_SECTION == section)
		{
			if (row == 0)
			{
				[[self lens] setMaximumAperture:[numberFormatter numberFromString:[textField text]]];
				DLog(@"Set maximum aperture to %@", [[self lens] maximumAperture]);
			}
			else 
			{
				[[self lens] setMinimumAperture:[numberFormatter numberFromString:[textField text]]];
				DLog(@"Set minimum aperture to %@", [[self lens] minimumAperture]);
			}

		}
		else if (FOCAL_LENGTH_SECTION == section)
		{
			if (row == 0)
			{
				[[self lens] setMinimumFocalLength:[numberFormatter numberFromString:[textField text]]];
				DLog(@"Set minimum focal length to %@", [[self lens] minimumFocalLength]);
			}
			else
			{
				[[self lens] setMaximumFocalLength:[numberFormatter numberFromString:[textField text]]];
				DLog(@"Set maximum focal length to %@", [[self lens] maximumFocalLength]);
			}
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	UITableViewCell* cell = [self cellForView:textField];
	NSIndexPath* nextCellPath = [self nextCellForTag:[cell tag]];
	if (nil == nextCellPath)
	{
		return YES;
	}
	
	DLog(@"Next cell is section %ld row %ld", (long)[nextCellPath section], (long)[nextCellPath row]);
	[textField resignFirstResponder];
	
	UITableView* tableView = (UITableView*)[self view];
	[tableView scrollToRowAtIndexPath:nextCellPath
					 atScrollPosition:UITableViewScrollPositionBottom
							 animated:YES];
	UITableViewCell* nextCell = [tableView cellForRowAtIndexPath:nextCellPath];
	UITextField* nextTextField = (UITextField*)[nextCell viewWithTag:TEXT_FIELD_TAG];
	NSAssert(nextTextField != nil, @"No text field found");
	
	[nextTextField becomeFirstResponder];
	
	return NO;
}

#pragma mark Helpers

- (void)presentDataValidationAlertWithMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LENS_DATA_VALIDATION_ERROR", "LENS_DATA_VALIDATION_ERROR")
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* closeButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"CLOSE_BUTTON_LABEL", "CLOSE_BUTTON_LABEL")
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [alert addAction:closeButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
