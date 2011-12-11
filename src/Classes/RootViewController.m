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

#import "Camera.h"
#import "CameraBag.h"
#import "FieldToolsAppDelegate.h"
#import "FlipsideViewController.h"
#import "Lens.h"
#import "MainViewController.h"

#import "UserDefaults.h"

@interface RootViewController ()

- (void)updateCameraAndLensDescription;

@property(nonatomic, retain) UINavigationController* navigationController;

@end

@implementation RootViewController

@synthesize cameraAndLensDescription;
@synthesize infoButton;
@synthesize mainViewController;
@synthesize navigationController;
@synthesize flipsideNavigationBar;
@synthesize flipsideViewController;

- (void)viewDidLoad 
{
	MainViewController *viewController = [[MainViewController alloc] 
										  initWithNibName:@"MainView" bundle:nil];
	[self setMainViewController:viewController];
	[viewController release];
	
	[[self view] insertSubview:[mainViewController view] belowSubview:infoButton];
	
	CGRect newInfoButtonRect = CGRectMake([self infoButton].frame.origin.x-25, 
										  [self infoButton].frame.origin.y-25, [self infoButton].frame.size.width+50, 
										  [self infoButton].frame.size.height+50);
	[[self infoButton] setFrame:newInfoButtonRect];	
	
	[[self view] insertSubview:[mainViewController view] belowSubview:cameraAndLensDescription];

	[self updateCameraAndLensDescription];
}

// Helper method to load the flipside view and controller
- (void)loadFlipsideViewController 
{
	FlipsideViewController *viewController = 
		[[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	[self setFlipsideViewController:viewController];
	[viewController setRootViewController:self];
	
	[self setNavigationController:[[[UINavigationController alloc] initWithRootViewController:viewController] autorelease]];
	[viewController setNavigationController:[self navigationController]];
	[viewController release];
	UINavigationItem* navigationItem = [[[[self navigationController] navigationBar] items] objectAtIndex:0];
	[navigationItem setTitle:NSLocalizedString(@"SETTINGS_TITLE", "Settings title")];
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackOpaque];
}

// This method is called when the info or Done button is pressed.
// It flips the displayed view from the main view to the flipside view and vice-versa.
- (IBAction)toggleView 
{	
	if ([self flipsideViewController] == nil) 
	{
		[self loadFlipsideViewController];
	}
	
	UIView* mainView = [[self mainViewController] view];
	UIWindow* window = [[self view] window];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) 
						   forView:window
							 cache:YES];
	
	if ([mainView superview] != nil) 
	{
		// Switch to flipside view
		
		[[self navigationController].topViewController viewWillAppear:YES];
		[[self mainViewController] viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [[self infoButton] removeFromSuperview];
		[[self cameraAndLensDescription] removeFromSuperview];
		[window addSubview:[[self navigationController] view]];
	}
	else
	{
		// Switch to main view
		
		[[self mainViewController] viewWillAppear:YES];
		[[self navigationController].topViewController viewWillDisappear:YES];
		[[[self navigationController] view] removeFromSuperview];
		[[self view] addSubview:mainView];
		[[self view] insertSubview:[self infoButton] 
					  aboveSubview:[[self mainViewController] view]];
		[[self view] insertSubview:[self cameraAndLensDescription]
					  aboveSubview:[[self mainViewController] view]];
		
		[self updateCameraAndLensDescription];
	}
	[UIView commitAnimations];
}

- (void)updateCameraAndLensDescription
{
	CameraBag* cameraBag = [CameraBag sharedCameraBag];
	
    NSString* title = [NSString stringWithFormat:@"%@ - %@",
                       [cameraBag findSelectedCamera], [cameraBag findSelectedLens]];
    
	[cameraAndLensDescription setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[self setCameraAndLensDescription:nil];
	[self setInfoButton:nil];
	[self setFlipsideNavigationBar:nil];
	[self setMainViewController:nil];
	[self setFlipsideViewController:nil];
	
	[super dealloc];
}

@end
