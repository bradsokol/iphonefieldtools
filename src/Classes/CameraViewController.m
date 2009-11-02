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
//  CameraViewController.m
//  FieldTools
//
//  Created by Brad on 2009/04/14.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CameraViewController.h"

#import "Camera.h"
#import "CameraViewTableDataSource.h"
#import "CoC.h"
#import "EditableTableViewCell.h"

#import "Notifications.h"
#import "UserDefaults.h"

@interface CameraViewController ()

- (void)cancelWasSelected;
- (void)cocChanged:(NSNotification*)notification;
- (void)saveWasSelected;

@property(nonatomic, retain) Camera* camera;
@property(nonatomic, retain) Camera* cameraWorking;
@property(nonatomic, retain) UIBarButtonItem* saveButton;

@end

@implementation CameraViewController

@synthesize camera;
@synthesize cameraWorking;
@synthesize saveButton;
@synthesize tableViewDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	return [self initWithNibName:nibNameOrNil
						  bundle:nibBundleOrNil
					   forCamera:nil];
}

// The designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCamera:(Camera*)aCamera
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) 
    {
		return nil;
    }
	
	[self setCamera:aCamera];
	
	[self setCameraWorking:[[[self camera] copy] autorelease]];
	
	UIBarButtonItem* cancelButton = 
		[[[UIBarButtonItem alloc] 
		  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel									 
							   target:self
							   action:@selector(cancelWasSelected)] autorelease];
	[self setSaveButton: 
		[[[UIBarButtonItem alloc] 
		 initWithBarButtonSystemItem:UIBarButtonSystemItemSave	 
							  target:self
							  action:@selector(saveWasSelected)] autorelease]];
	
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	
	[self setTitle:NSLocalizedString(@"CAMERA_VIEW_TITLE", "Camera view")];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(cocChanged:)
												 name:COC_CHANGED_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(cocChanged:)
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
	UITableView* tableView = (UITableView*)[self view];
	EditableTableViewCell* cell = 
	 (EditableTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[[cell textField] resignFirstResponder];
	
	NSString* message = nil;
	if ([cameraWorking description] == nil || [[cameraWorking description] length] == 0)
	{
		message = NSLocalizedString(@"CAMERA_ERROR_MISSING_NAME", "CAMERA_ERROR_MISSING_NAME");
	}
	else if ([[cameraWorking coc] value] <= 0.0)
	{
		message = NSLocalizedString(@"CAMERA_ERROR_INVALID_COC", "CAMERA_ERROR_INVALID_COC");
	}
	
	if (message == nil)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:SAVING_NOTIFICATION
															object:self];
		
		[[self camera] setDescription:[[self cameraWorking] description]];
		[[self camera] setCoc:[[self cameraWorking] coc]];
		
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CAMERA_WAS_EDITED_NOTIFICATION
																							 object:[self camera]]];
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
	else
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CAMERA_DATA_VALIDATION_ERROR", "CAMERA_DATA_VALIDATION_ERROR")
														message:message
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"CLOSE_BUTTON_LABEL", "CLOSE_BUTTON_LABEL")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];

	[self setTableViewDataSource: [[self tableView] dataSource]];
	[[self tableViewDataSource] setCamera:[self cameraWorking]];
	[[self tableViewDataSource] setController:self];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

#pragma mark UITextFieldDelegate methods
	 
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[[self cameraWorking] setDescription:[textField text]];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotification:
	 [NSNotification notificationWithName:COC_SELECTED_FOR_EDIT_NOTIFICATION 
								   object:[self cameraWorking]]];
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// The alert view is displayed only if the camera name was not specified.
	// Help the user by making the camera name text field the first responder.
	UITableView* tableView = (UITableView*)[self view];
	EditableTableViewCell* cell = 
		(EditableTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[[cell textField] becomeFirstResponder];
}

- (void)cocChanged:(NSNotification*)notification
{
	UITableView* tableView = (UITableView*) [self view];
	[tableView reloadData];
}

- (void)dealloc 
{
	[self setSaveButton:nil];
	[self setCamera:nil];
	[self setCameraWorking:nil];
	[self setTableViewDataSource:nil];
	
    [super dealloc];
}

@end
