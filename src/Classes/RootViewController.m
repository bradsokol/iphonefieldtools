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
//  RootViewController.m
//  FieldTools
//
//  Created by Brad on 2008/11/30.
//

#import "RootViewController.h"

#import "FieldToolsAppDelegate.h"
#import "FlipsideViewController.h"
#import "MainViewController.h"

@implementation RootViewController

@synthesize infoButton;
@synthesize mainViewController;
@synthesize flipsideNavigationBar;
@synthesize flipsideViewController;

- (void)viewDidLoad 
{
	MainViewController *viewController = [[MainViewController alloc] 
										  initWithNibName:@"MainView" bundle:nil];
	[self setMainViewController:viewController];
	[viewController release];
	
	[[self view] insertSubview:[mainViewController view] belowSubview:infoButton];
}

// Helper method to load the flipside view and controller
- (void)loadFlipsideViewController 
{
	FlipsideViewController *viewController = 
		[[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	[self setFlipsideViewController:viewController];
	[viewController release];

	UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	aNavigationBar.barStyle = UIBarStyleBlackOpaque;
	[self setFlipsideNavigationBar:aNavigationBar];
	[aNavigationBar release];
	
	UIBarButtonItem *doneButtonItem = 
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
													  target:self 
													  action:@selector(toggleView)];
	UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"FIELD_TOOLS_TITLE", "Field tools title")];
	[navigationItem setRightBarButtonItem:doneButtonItem];
	[flipsideNavigationBar pushNavigationItem:navigationItem animated:NO];
	[navigationItem release];
	[doneButtonItem release];
}

// This method is called when the info or Done button is pressed.
// It flips the displayed view from the main view to the flipside view and vice-versa.
- (IBAction)toggleView 
{	
	if (flipsideViewController == nil) 
	{
		[self loadFlipsideViewController];
	}
	
	UIView* mainView = [mainViewController view];
	UIView* flipsideView = [flipsideViewController view];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) 
						   forView:[self view]
							 cache:YES];
	
	if ([mainView superview] != nil) 
	{
		// Switch to flipside view
		
		[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [infoButton removeFromSuperview];
		[[self view] addSubview:flipsideView ];
		[[self view] insertSubview:flipsideNavigationBar 
					  aboveSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];
	}
	else
	{
		// Switch to main view
		
		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[[self view] addSubview:mainView];
		[[self view] insertSubview:infoButton 
					  aboveSubview:[mainViewController view]];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[infoButton release];
	[flipsideNavigationBar release];
	[mainViewController release];
	[flipsideViewController release];
	[super dealloc];
}

@end
