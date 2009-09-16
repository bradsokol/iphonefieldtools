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
	
	CGRect newInfoButtonRect = CGRectMake(infoButton.frame.origin.x-25, 
										  infoButton.frame.origin.y-25, infoButton.frame.size.width+50, 
										  infoButton.frame.size.height+50);
	[infoButton setFrame:newInfoButtonRect];	
}

// Helper method to load the flipside view and controller
- (void)loadFlipsideViewController 
{
	FlipsideViewController *viewController = 
		[[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	[self setFlipsideViewController:viewController];
	[viewController setRootViewController:self];
	
	navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController setNavigationController:navigationController];
	[viewController release];
	UINavigationItem* navigationItem = [[[navigationController navigationBar] items] objectAtIndex:0];
	[navigationItem setTitle:NSLocalizedString(@"SETTINGS_TITLE", "Settings title")];
	[[navigationController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
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
	UIWindow* window = [[self view] window];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) 
						   forView:window
							 cache:YES];
	
	if ([mainView superview] != nil) 
	{
		// Switch to flipside view
		
		[navigationController.topViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [infoButton removeFromSuperview];
		[window addSubview:[navigationController view]];
	}
	else
	{
		// Switch to main view
		
		[mainViewController viewWillAppear:YES];
		[navigationController.topViewController viewWillDisappear:YES];
		[[navigationController view] removeFromSuperview];
		[[self view] addSubview:mainView];
		[[self view] insertSubview:infoButton 
					  aboveSubview:[mainViewController view]];
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
