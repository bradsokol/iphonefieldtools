// Copyright 2011 Brad Sokol
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
//  SubjectDistanceRangesViewController.m
//  FieldTools
//
//  Created by Brad Sokol on 2011-08-23.
//  Copyright 2011 by Brad Sokol. All rights reserved.
//

#import "SubjectDistanceRangesViewController.h"

@interface SubjectDistanceRangesViewController ()

- (void)cancelWasSelected;
- (void)saveWasSelected;

@property(nonatomic, retain) UIBarButtonItem* saveButton;

@end

@implementation SubjectDistanceRangesViewController

@synthesize saveButton, tableViewDataSource;

// The designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) 
    {
		return nil;
    }
	
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
	[[self navigationItem] setRightBarButtonItem:saveButton];
	
	[self setTitle:NSLocalizedString(@"SUBJECT_DISTANCE_RANGES_VIEW_TITLE", "subject distance ranges view")];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(customCoCSpecified:)
//												 name:CUSTOM_COC_NOTIFICATION
//											   object:nil];
    
	return self;
}

- (void)cancelWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
    UITableView* tv = [self tableView];
    SubjectDistanceRangesViewTableDataSource* sdrvtds = [tv dataSource];
    [self setTableViewDataSource:sdrvtds];
	[self setTableViewDataSource:[[self tableView] dataSource]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self setSaveButton:nil];
	
    [super dealloc];
}

@end
