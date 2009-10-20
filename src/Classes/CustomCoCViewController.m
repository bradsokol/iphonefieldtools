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
//  CustomCoCViewController.m
//  FieldTools
//
//  Created by Brad on 2009/10/19.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CustomCoCViewController.h"

@interface CustomCoCViewController ()

- (void)cancelWasSelected;
- (void)saveWasSelected;

@property(nonatomic, retain) UIBarButtonItem* saveButton;

@end

@implementation CustomCoCViewController

@synthesize saveButton;
@synthesize tableViewDataSource;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
//{
//	return [self initWithNibName:nibNameOrNil
//						  bundle:nibBundleOrNil
//					   forCamera:nil];
//}

// The designated initializer.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCamera:(Camera*)aCamera
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
	[saveButton setEnabled:NO];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	
	[self setTitle:NSLocalizedString(@"CUSTOM_COC_VIEW_TITLE", "CoC view")];
    
	return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
//	[self setTableViewDataSource: [[self tableView] dataSource]];
//	[[self tableViewDataSource] setCamera:[self camera]];
//	[[self tableViewDataSource] setController:self];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)cancelWasSelected
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
//	[[self camera] setCoc:[[self cameraWorking] coc]];
	
	[[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
    return cell;
}

- (void)dealloc 
{
	[self setSaveButton:nil];
	
    [super dealloc];
}

@end

