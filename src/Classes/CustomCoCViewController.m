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

#import "CustomCoCViewTableDataSource.h"
#import "FTCamera.h"
#import "FTCameraBag.h"
#import "FTCoC.h"

#import "Notifications.h"

@interface CustomCoCViewController ()

- (void)cancelWasSelected;
- (void)makeTextFieldFirstResponder;
- (void)saveWasSelected;

@property(nonatomic, strong) FTCamera* camera;
@property(nonatomic, assign) float coc;
@property(nonatomic, strong) NSNumberFormatter* numberFormatter;
@property(nonatomic, strong) UIBarButtonItem* saveButton;

@end

@implementation CustomCoCViewController

@synthesize camera;
@synthesize coc;
@synthesize cocValueCell;
@synthesize cocValueField;
@synthesize cocValueLabel;
@synthesize numberFormatter;
@synthesize saveButton;
@synthesize tableViewDataSource;

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
	
	[self setTitle:NSLocalizedString(@"CUSTOM_COC_VIEW_TITLE", "CoC view")];

	[self setNumberFormatter:[[NSNumberFormatter alloc] init]];
    
	return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
	[[self analyticsPolicy] trackView:kSettingsCustomCoC];
    
	[[self view] setBackgroundColor:[UIColor blackColor]];
	
	[self setTableViewDataSource: [[self tableView] dataSource]];
	[[self tableViewDataSource] setCamera:[self camera]];
	[[self tableViewDataSource] setController:self];
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
	[[self cocValueField] resignFirstResponder];

	if (coc <= 0.0 || coc >= 1.0)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COC_VALIDATION_ERROR", "COC_VALIDATION_ERROR")
														message:NSLocalizedString(@"COC_ERROR_OUT_OF_RANGE", "COC_ERROR_OUT_OF_RANGE")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"CLOSE_BUTTON_LABEL", "CLOSE_BUTTON_LABEL")
											  otherButtonTitles:nil];
		[alert show];
		
		[self makeTextFieldFirstResponder];
	}
	else
	{
        FTCoC* customCoc = [[FTCameraBag sharedCameraBag] newCoC];
        [customCoc setValueValue:coc];
        [customCoc setName:CUSTOM_COC_KEY];

        if ([[self camera] coc] != nil)
        {
            FTCoC* oldCoC = [[self camera] coc];
            [oldCoC setCamera:nil];
            [[FTCameraBag sharedCameraBag] deleteCoC:oldCoC];
        }
		[[self camera] setCoc:customCoc];
		
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CUSTOM_COC_NOTIFICATION 
																							 object:customCoc]];
		

		[[self navigationController] popViewControllerAnimated:YES];
	}
}

- (void)makeTextFieldFirstResponder
{
	[[self cocValueField] becomeFirstResponder];
}

#pragma mark UITableViewDelegateMethods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];

	// If the cell is touched anywhere, not just in the text field, make the text field the first responder.
	[self makeTextFieldFirstResponder];
}
	
#pragma mark UITextViewDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	coc = [[numberFormatter numberFromString:[textField text]] floatValue];
}


@end

