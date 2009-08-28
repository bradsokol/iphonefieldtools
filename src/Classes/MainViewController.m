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
//  MainViewController.m
//  FieldTools
//
//  Created by Brad on 2008/11/29.
//

#import "MainViewController.h"

#import "Camera.h"
#import "CoC.h"
#import "DistanceFormatter.h"
#import "FieldToolsAppDelegate.h"
#import "MainView.h"
#import "ResultView.h"

#import "Notifications.h"
#import "UserDefaults.h"

// Index in segmented control for focus type selections
#define HYPERFOCAL_SEGMENT_INDEX	0
#define NEAR_SEGMENT_INDEX			1
#define FAR_SEGMENT_INDEX			2
#define NEAR_FAR_SEGMENT_INDEX		3

float minimumDistanceToSubject = 0.25f;	// metres
float maximumDistanceToSubject = 25.0f;	// metres

// Private methods
@interface MainViewController(Private)

- (float)calculateFarLimit;
- (float)calculateHyperfocalDistance;
- (float)calculateNearLimit;
- (float)calculateResult;
- (void)cocDidChange;
- (void)customizeSliderAppearance:(UISlider*)slider;
- (void)gearButtonWasPressed;
- (void)initApertures;
- (void)readDefaultCircleOfLeastConfusion;
- (void)unitsButtonWasPressed;
- (void)unitsDidChange;
- (void)updateAperture;
- (void)updateFocalLength;
- (void)updateResult;
- (void)updateDistanceSliderLimits;
- (void)updateSubjectDistance;

@end

@implementation MainViewController

#pragma mark Accessors

@synthesize circleOfLeastConfusion;
@synthesize subjectDistance;

// Convert aperture index to an aperture which is set of values
// with a non-deterministic patter.
- (float)aperture 
{
	return [[apertures objectAtIndex:apertureIndex] floatValue];
}

- (float)focalLength
{
	return focalLength;
}

- (void)setFocalLength:(float)newValue
{
	focalLength = newValue;
	[self updateFocalLength];
}

// Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (nil == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        return nil;
    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(unitsDidChange)
												 name:UNITS_CHANGED_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(cocDidChange)
												 name:COC_CHANGED_NOTIFICATION
											   object:nil];
	
	[self initApertures];

	// Reading initial values from defaults
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	apertureIndex = [defaults integerForKey:FTApertureIndex];
	[self setFocalLength:[defaults floatForKey:FTFocalLengthKey]];
	[self setSubjectDistance:[defaults floatForKey:FTSubjectDistanceKey]];
	[self readDefaultCircleOfLeastConfusion];
	
	distanceFormatter = [[DistanceFormatter alloc] init];
	
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// Set initial values in to controls
	[distanceType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:FTDistanceTypeKey]];
	[apertureSlider setValue:apertureIndex];
	[focalLengthSlider setValue:[self focalLength]];
	[subjectDistanceSlider setValue:[self subjectDistance]];
	
	// Set limits on sliders
	[self updateDistanceSliderLimits];

	[self customizeSliderAppearance:focalLengthSlider];
	[self customizeSliderAppearance:apertureSlider];
	[self customizeSliderAppearance:subjectDistanceSlider];
	
	[self updateAperture];
	[self updateFocalLength];
	[self updateSubjectDistance];
	
	[self distanceTypeDidChange:self];
}

#pragma mark Action messages

// Aperture slider changed
- (void)apertureDidChange:(id)sender
{
	// Round slider value to nearest integer value to get index in to array
	apertureIndex = [apertureSlider value] + 0.5f;
	
	[[NSUserDefaults standardUserDefaults] setInteger:apertureIndex
											   forKey:FTApertureIndex];
	
	[self updateAperture];
}

// Low memory warning
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}

// Distance type changed in segment control
- (void)distanceTypeDidChange:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[distanceType selectedSegmentIndex]
											   forKey:FTDistanceTypeKey];
	
	// Show or hide the distance slider depending on the distance
	// type selected in the segment control.
	BOOL hide = [distanceType selectedSegmentIndex] == HYPERFOCAL_SEGMENT_INDEX;
	[subjectDistanceLabel setHidden:hide];
	[subjectDistanceText setHidden:hide];
	[subjectDistanceSlider setHidden:hide];
	[subjectDistanceMinimum setHidden:hide];
	[subjectDistanceMaximum setHidden:hide];
	
	[self updateResult];
}

// Focal length slider changed
- (void)focalLengthDidChange:(id)sender
{
	// Round slider value to nearest integer value
	[self setFocalLength:floorf([focalLengthSlider value] + 0.5f)];
	
	[[NSUserDefaults standardUserDefaults] setFloat:[self focalLength]
											 forKey:FTFocalLengthKey];
	
	[self updateFocalLength];
}

// Specify supported orientations - currently only portait.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Distance to subject slider was changed
- (void)subjectDistanceDidChange:(id)sender
{
	[self setSubjectDistance:[subjectDistanceSlider value]];
	
	[[NSUserDefaults standardUserDefaults] setFloat:[self subjectDistance]
											 forKey:FTSubjectDistanceKey];

	[self updateSubjectDistance];
}

// Notification that circle of confusion was changed. Need to 
// recalculate results.
- (void)cocDidChange
{
	[self readDefaultCircleOfLeastConfusion];
	[self updateResult];
}

// Notification that units changed. Need to re-display results.
- (void)unitsDidChange
{
	[self updateDistanceSliderLimits];
	[self updateSubjectDistance];
	[self updateResult];
}

#pragma mark Calculations

// Calculations are from Wikipedia: http://en.wikipedia.org/wiki/Hyperfocal_distance
// and http://en.wikipedia.org/wiki/Depth_of_field#Depth_of_field_formulas
//
// The following variables are used in the calculations:
//
// H - Hyperfocal distance in metres
// f - Focal length in millimetres
// c - circle of confusion
// N - f-number
// s - distance to subject in metres

// Calculates result for selected distance. Result is in metres.
- (float)calculateResult
{
	float distance = 0.0f;
	switch ([distanceType selectedSegmentIndex])
	{
		case HYPERFOCAL_SEGMENT_INDEX:
			distance = [self calculateHyperfocalDistance];
			break;
			
		case NEAR_SEGMENT_INDEX:
			distance = [self calculateNearLimit];
			break;
			
		case FAR_SEGMENT_INDEX:
			distance = [self calculateFarLimit];
			break;
			
		case NEAR_FAR_SEGMENT_INDEX:
			distance = 0.0;
			break;
	}
	return distance;
}

// Df = ((Hs)/(H - (s - f)))
- (float)calculateFarLimit
{
	float h = [self calculateHyperfocalDistance];
	float s = [subjectDistanceSlider value];
	
	return ((h * s) / (h - (s - focalLength / 1000.0f)));
}

// H = (f^2) / (Nc) + f
- (float)calculateHyperfocalDistance
{
//	return ((focalLength * focalLength) / 
//			([self aperture] * circleOfLeastConfusion) + focalLength) / 1000.0f;
	return ((focalLength * focalLength) / 
			([self aperture] * circleOfLeastConfusion)) / 1000.0f;
}

// Dn = ((Hs)/(H + (s - f)))
- (float)calculateNearLimit
{
	float h = [self calculateHyperfocalDistance];
	float s = [subjectDistanceSlider value];
	
	return ((h * s) / (h + (s - focalLength / 1000.0f)));
}

#pragma mark Updaters

// Update the aperture display
- (void)updateAperture
{
	NSString* formatted = [NSString stringWithFormat:@"f/%.1f", 
						   [[apertures objectAtIndex:apertureIndex] floatValue]];
	
	// Trim '.0' from the formatted string as convention is that this is not
	// included in an f-number
	if ([formatted hasSuffix:@".0"])
	{
		NSString* temp = [formatted substringToIndex:[formatted length] - 2];
		formatted = temp;
	}
	
	[apertureText setText:formatted];
	
	[self updateResult];
}

// Update the focallength display
- (void)updateFocalLength
{
	[focalLengthText setText:[NSString stringWithFormat:@"%.0f mm", [self focalLength]]];
	[self updateResult];
}

// Update the computed distance (hyperfocal, near or far limit as selected)
- (void)updateResult
{
	if ([distanceType selectedSegmentIndex] == NEAR_FAR_SEGMENT_INDEX)
	{
		[resultView setResultNear:[self calculateNearLimit]
							  far:[self calculateFarLimit]];
	}
	else
	{
		[resultView setResult:[self calculateResult]];
	}
}

- (void)updateDistanceSliderLimits
{
	[subjectDistanceMinimum setText:[distanceFormatter stringForObjectValue:[NSNumber numberWithFloat:minimumDistanceToSubject]]];
	[subjectDistanceMaximum setText:[distanceFormatter stringForObjectValue:[NSNumber numberWithFloat:maximumDistanceToSubject]]];
}

// Update the distance to subject display
- (void)updateSubjectDistance
{
	[subjectDistanceText setText:[distanceFormatter stringForObjectValue:[NSNumber numberWithFloat:[self subjectDistance]]]];
	[self updateResult];
}

#pragma mark Helpers

- (void)customizeSliderAppearance:(UISlider*)slider
{
	static UIImage* sliderTrack;
	static UIImage* sliderThumb;
	if (nil == sliderTrack)
	{
		sliderTrack = [[UIImage imageNamed:@"sliderTrack.png"]
					   stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
		sliderThumb = [UIImage imageNamed:@"sliderThumb.png"];
	}
	
	[slider setMinimumTrackImage:sliderTrack forState:UIControlStateNormal];
	[slider setMaximumTrackImage:sliderTrack forState:UIControlStateNormal];
	[slider setThumbImage:sliderThumb forState:UIControlStateNormal];
}

// Initialise a table of f-number values
- (void)initApertures
{
	apertures = [[NSMutableArray alloc] init];
	[apertures addObject:[NSNumber numberWithFloat:1.0]];		// index: 0
	[apertures addObject:[NSNumber numberWithFloat:1.1]];
	[apertures addObject:[NSNumber numberWithFloat:1.2]];
	[apertures addObject:[NSNumber numberWithFloat:1.4]];
	[apertures addObject:[NSNumber numberWithFloat:1.6]];
	[apertures addObject:[NSNumber numberWithFloat:1.8]];		// index: 5
	[apertures addObject:[NSNumber numberWithFloat:2.0]];
	[apertures addObject:[NSNumber numberWithFloat:2.2]];
	[apertures addObject:[NSNumber numberWithFloat:2.5]];
	[apertures addObject:[NSNumber numberWithFloat:2.8]];
	[apertures addObject:[NSNumber numberWithFloat:3.2]];		// index: 10
	[apertures addObject:[NSNumber numberWithFloat:3.5]];
	[apertures addObject:[NSNumber numberWithFloat:4.0]];
	[apertures addObject:[NSNumber numberWithFloat:4.5]];
	[apertures addObject:[NSNumber numberWithFloat:5.0]];
	[apertures addObject:[NSNumber numberWithFloat:5.6]];		// index: 15
	[apertures addObject:[NSNumber numberWithFloat:6.3]];
	[apertures addObject:[NSNumber numberWithFloat:7.1]];
	[apertures addObject:[NSNumber numberWithFloat:8.0]];
	[apertures addObject:[NSNumber numberWithFloat:9.0]];
	[apertures addObject:[NSNumber numberWithFloat:10.0]];		// index: 20
	[apertures addObject:[NSNumber numberWithFloat:11.0]];
	[apertures addObject:[NSNumber numberWithFloat:13.0]];
	[apertures addObject:[NSNumber numberWithFloat:14.0]];
	[apertures addObject:[NSNumber numberWithFloat:16.0]];
	[apertures addObject:[NSNumber numberWithFloat:18.0]];		// index: 25
	[apertures addObject:[NSNumber numberWithFloat:20.0]];
	[apertures addObject:[NSNumber numberWithFloat:22.0]];
	[apertures addObject:[NSNumber numberWithFloat:25.0]];
	[apertures addObject:[NSNumber numberWithFloat:29.0]];
	[apertures addObject:[NSNumber numberWithFloat:32.0]];		// index: 30
	[apertures addObject:[NSNumber numberWithFloat:45.0]];
	[apertures addObject:[NSNumber numberWithFloat:51.0]];
	[apertures addObject:[NSNumber numberWithFloat:57.0]];
	[apertures addObject:[NSNumber numberWithFloat:64.0]];
	[apertures addObject:[NSNumber numberWithFloat:72.0]];		// index: 35
	[apertures addObject:[NSNumber numberWithFloat:81.0]];
	[apertures addObject:[NSNumber numberWithFloat:91.0]];
	
	apertureIndex = 18;
}

- (void)readDefaultCircleOfLeastConfusion
{
	Camera* camera = [Camera initFromSelectedInDefaults];
	
	[self setCircleOfLeastConfusion:[[camera coc] value]];
	
	[camera release];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[distanceFormatter release];

    [super dealloc];
}

@end
