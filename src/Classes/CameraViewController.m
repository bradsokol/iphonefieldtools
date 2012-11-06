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

#import "AnalyticsPolicy.h"
#import "CameraViewTableDataSource.h"
#import "FTCamera.h"
#import "FTCameraBag.h"
#import "FTCoC.h"

#import "Notifications.h"
#import "UserDefaults.h"

static const int TEXT_FIELD_TAG = 99;

@interface CameraViewController ()

- (void)cancelWasSelected;
- (void)cocChanged:(NSNotification*)notification;
- (void)saveWasSelected;

@property(nonatomic, retain) Camera* camera;
@property(nonatomic, getter=isNewCamera) bool newCamera;
@property(nonatomic, retain) UIBarButtonItem* saveButton;

@end

@implementation CameraViewController

@synthesize analyticsPolicy;
@synthesize camera;
@synthesize cameraNameField;
@synthesize cameraNameCell;
@synthesize cameraNameLabel;
@synthesize newCamera;
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
	
	[self setNewCamera:[[[self camera] description] length] == 0];
	
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
    [[FTCameraBag sharedCameraBag] rollback];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)saveWasSelected
{
	[[self cameraNameField] resignFirstResponder];
	
	NSString* message = nil;
	if ([camera description] == nil || [[camera description] length] == 0)
	{
		message = NSLocalizedString(@"CAMERA_ERROR_MISSING_NAME", "CAMERA_ERROR_MISSING_NAME");
	}
	else if ([[camera coc] valueValue] <= 0.0)
	{
		message = NSLocalizedString(@"CAMERA_ERROR_INVALID_COC", "CAMERA_ERROR_INVALID_COC");
	}
	
	if (message == nil)
	{
		NSString* notificationName = [self isNewCamera] ? CAMERA_WAS_ADDED_NOTIFICATION : CAMERA_WAS_EDITED_NOTIFICATION;
		
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notificationName
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

    NSString* viewName = [self isNewCamera] ? kSettingsAddCamera : kSettingsEditCamera;
    [[self analyticsPolicy] trackView:viewName];
	
	[[self view] setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];

	[self setTableViewDataSource: [[self tableView] dataSource]];
	[[self tableViewDataSource] setCamera:[self camera]];
	[[self tableViewDataSource] setController:self];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

#pragma mark UITextFieldDelegate methods
	 
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[[self camera] setName:[textField text]];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
    
    if ([indexPath row] == 0)
    {
        // Camera name row. Touching this row anywhere including on the 
        // label makes in the text field the first responder, bringing up
        // the keyboard.
        [[self cameraNameField] becomeFirstResponder];
    }
    else 
    {
        // CoC row
        [[self cameraNameField] resignFirstResponder];

        [[NSNotificationCenter defaultCenter] 
         postNotification:
         [NSNotification notificationWithName:COC_SELECTED_FOR_EDIT_NOTIFICATION 
                                       object:[self camera]]];
    }
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// The alert view is displayed only if the camera name was not specified.
	// Help the user by making the camera name text field the first responder.
	[[self cameraNameField] becomeFirstResponder];
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
	[self setTableViewDataSource:nil];
	
    [super dealloc];
}

@end
