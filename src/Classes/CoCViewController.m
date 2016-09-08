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
//  CoCViewController.m
//  FieldTools
//
//  Created by Brad on 2009/08/23.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CoCViewController.h"

#import "FTCamera.h"
#import "FTCameraBag.h"
#import "FTCoC.h"
#import "TwoLabelTableViewCell.h"

#import "Notifications.h"

static const int NUM_SECTIONS = 1;

@interface CoCViewController ()

- (void)cancelWasSelected;
- (void)customCoCSpecified:(NSNotification*)notification;
- (void)didSelectCoCPresetAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (void)didSelectCustomCoCInTableView:(UITableView *)tableView;
- (NSString*)keyForRow:(NSInteger)row;
- (NSInteger)rowForSelectedCoC;
- (void)saveWasSelected;

@property(nonatomic, strong) FTCamera* camera;
@property(nonatomic, strong) FTCoC* coc;
@property(nonatomic, strong) UIBarButtonItem* saveButton;

@end

@implementation CoCViewController

@synthesize analyticsPolicy;
@synthesize camera;
@synthesize coc;
@synthesize saveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	return [self initWithNibName:nibNameOrNil
						  bundle:nibBundleOrNil
					   forCamera:nil];
}

// The designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCamera:(FTCamera*)aCamera
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) 
    {
		return nil;
    }
	
	[self setCamera:aCamera];
	
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
	[[self navigationItem] setRightBarButtonItem:saveButton];
	
	[self setTitle:NSLocalizedString(@"COC_VIEW_TITLE", "CoC view")];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(customCoCSpecified:)
												 name:CUSTOM_COC_NOTIFICATION
											   object:nil];
    
	return self;
}

- (void)cancelWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
    if ([[self camera] coc] != [self coc])
    {
        FTCoC* oldCoc = [[self camera] coc];
        [[self camera] setCoc:[self coc]];
        [[FTCameraBag sharedCameraBag] deleteCoC:oldCoc];
    }
    
    [[self analyticsPolicy] trackEvent:kCategoryCoC
                                action:kActionChanged
                                 label:[[[self camera] coc] name] value:-1];

	
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self setCoc:[[FTCameraBag sharedCameraBag] newCoC]];
    [[self coc] setName:[[[self camera] coc] name]];
    [[self coc] setValue:[[[self camera] coc] value]];

    [[self analyticsPolicy] trackView:kSettingsCoC];
	
	[[self view] setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)setCoc:(FTCoC *)newCoc
{
    // If the CoC object doesn't have a camera, it was a temporary one for
    // editing purposes. It should be deleted.
    if (nil != coc && nil == [coc camera])
    {
        [[FTCameraBag sharedCameraBag] deleteCoC:coc];
    }
    
    coc = newCoc;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return one extra row for the custom setting
	return [[FTCoC cocPresets] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TwoLabelTableViewCell* cell = (TwoLabelTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[TwoLabelTableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:@"Cell"];
    }
    
	if ([indexPath row] < [[FTCoC cocPresets] count])
	{
		// This is one of the rows for the preset CoC values
		NSArray* keys = [[FTCoC cocPresets] allKeys];
		NSArray* sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		NSString* key = [sortedKeys objectAtIndex:[indexPath row]];
		[cell setText:[NSString stringWithFormat:@"%.3f", [[[FTCoC cocPresets] objectForKey:key] floatValue]]];
		[cell setLabel:key];
		
		if ([key compare:[[self coc] name]] == NSOrderedSame)
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		else
		{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
	else
	{
		// This is the custom CoC row
		
		// See if custom CoC is configured.
		NSString* customLabel = NSLocalizedString(@"CUSTOM_COC_DESCRIPTION", "CUSTOM");
		NSString* cocDescription = [[self coc] name];
		
		if ([cocDescription compare:customLabel] == NSOrderedSame)
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			[cell setText:[NSString stringWithFormat:@"%.3f", [[camera coc] valueValue]]];
		}
		else
		{
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			[cell setText:@""];
		}
		[cell setLabel:customLabel];
	}
	
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [[FTCoC cocPresets] count])
    {
        // Custom CoC row
        [self didSelectCustomCoCInTableView:tableView];
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];

	if ([indexPath row] < [[FTCoC cocPresets] count])
	{
		[self didSelectCoCPresetAtIndexPath:indexPath inTableView:tableView];
	}
	else
	{
		[self didSelectCustomCoCInTableView:tableView];
	}
}

#pragma mark Helper methods

- (void) didSelectCoCPresetAtIndexPath:(NSIndexPath *)indexPath
						   inTableView:(UITableView *)tableView  
{
	NSIndexPath* oldIndexPath = [NSIndexPath indexPathForRow:[self rowForSelectedCoC] 
												   inSection:[indexPath section]];
	
	if ([oldIndexPath row] == [indexPath row])
	{
		// User selected the currently selected CoC - take no action
		return;
	}
	
	UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
	if ([newCell accessoryType] == UITableViewCellAccessoryNone)
	{
		// Selected row is not the current CoC so change the selection
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		NSString* description = [self keyForRow:[indexPath row]];
        FTCoC* newCoc = [FTCoC findFromPresets:description];
        [self setCoc:newCoc];
		
		[[NSNotificationCenter defaultCenter] 
		 postNotification:[NSNotification notificationWithName:COC_CHANGED_NOTIFICATION object:nil]];
	}
	
	UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if ([oldCell accessoryType] == UITableViewCellAccessoryCheckmark)
	{
		if ([oldIndexPath row] == [[FTCoC cocPresets] count])
		{
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:oldIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
		}
		else
		{
			[oldCell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
}

- (void)didSelectCustomCoCInTableView:(UITableView *)tableView
{
	[[NSNotificationCenter defaultCenter] 
	 postNotification:
	 [NSNotification notificationWithName:CUSTOM_COC_SELECTED_FOR_EDIT_NOTIFICATION 
								   object:[self camera]]];
}

- (NSString*)keyForRow:(NSInteger)row
{
	NSArray* keys = [[FTCoC cocPresets] allKeys];
	NSArray* sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	return [sortedKeys objectAtIndex:row];
}

- (NSInteger)rowForSelectedCoC
{
	// Check if custom CoC
	if ([[[self coc] name] compare:NSLocalizedString(@"CUSTOM_COC_DESCRIPTION", "CUSTOM")] == NSOrderedSame)
	{
		return [[FTCoC cocPresets] count];
	}
	
	NSArray* keys = [[FTCoC cocPresets] allKeys];
	NSArray* sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (int i = 0; i < [sortedKeys count]; ++i)
	{
		if ([[[self coc] name] compare:[sortedKeys objectAtIndex:i]] == 0)
		{
			return i;
		}
	}
	return -1;
}

- (void)customCoCSpecified:(NSNotification*)notification
{
    [self setCoc:[[self camera] coc]];
	UITableView* tableView = (UITableView*)[self view];
	
	[tableView reloadData];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	
}

@end
