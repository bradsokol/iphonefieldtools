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

#import "Lens.h"
#import "LensViewTableDataSource.h"

static const int TITLE_SECTION = 0;
static const int APERTURE_SECTION = 1;

static const float SectionHeaderHeight = 44.0;

@interface LensViewController (Private)

- (void)cancelWasSelected;
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
	[lens retain];
	
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
	[saveButton setEnabled:NO];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:saveButton];
//	[self enableSaveButtonForCamera:camera];
	
	[self setTitle:NSLocalizedString(@"LENS_VIEW_TITLE", "Lens view")];
	
	return self;
}

- (void)cancelWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
//	[[NSNotificationCenter defaultCenter] postNotificationName:SAVING_NOTIFICATION
//														object:self];
//	
//	[camera setDescription:[cameraWorkingCopy description]];
//	[camera setCoc:[cameraWorkingCopy coc]];
//	
//	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CAMERA_WAS_EDITED_NOTIFICATION
//																						 object:camera]];
	
	[[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark "UITableViewDelegateMethods

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
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(18, 0, 320, SectionHeaderHeight)] autorelease];
	UILabel *label = [[[UILabel alloc] initWithFrame:headerView.frame] autorelease];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor blackColor]];
	[label setText:section == APERTURE_SECTION ? NSLocalizedString(@"LENS_VIEW_APERTURE_SECTION_TITLE", "LENS_VIEW_APERTURE_SECTION_TITLE") :
		NSLocalizedString(@"LENS_VIEW_FOCAL_LENGTH_SECTION_TITLE", "LENS_VIEW_FOCAL_LENGTH_SECTION_TITLE")];
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

- (void)dealloc 
{
	[saveButton release];
	[lens release];
	[lensWorkingCopy release];

    [super dealloc];
}

@end

