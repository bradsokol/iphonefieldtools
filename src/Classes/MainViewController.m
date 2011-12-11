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
#import "CameraBag.h"
#import "CoC.h"
#import "DepthOfFieldCalculator.h"
#import "DistanceFormatter.h"
#import "FieldToolsAppDelegate.h"
#import "Lens.h"
#import "LinearSubjectDistanceSliderPolicy.h"
#import "MainView.h"
#import "NonLinearSubjectDistanceSliderPolicy.h"
#import "ResultView.h"
#import "SubjectDistanceRangePolicy.h"
#import "SubjectDistanceRangePolicyFactory.h"

#import "Notifications.h"
#import "UserDefaults.h"

// Index in segmented control for focus type selections
#define HYPERFOCAL_SEGMENT_INDEX	0
#define NEAR_SEGMENT_INDEX			1
#define FAR_SEGMENT_INDEX			2
#define NEAR_FAR_SEGMENT_INDEX		3

// Amount to move controls up and down when hiding focal length
// slider for prime lenses.
static float controlYDelta = 44.0f;

static BOOL previousLensWasZoom = YES;

// Private methods
@interface MainViewController ()

- (float)calculateFarLimit;
- (float)calculateHyperfocalDistance;
- (float)calculateNearLimit;
- (float)calculateResult;
- (void)cocDidChange;
- (void)customizeSliderAppearance:(UISlider*)slider;
- (int)indexNearestToAperture:(float)aperture;
- (void)initApertures;
- (void)lensDidChange:(NSNotification*)notification;
- (void)lensDidChangeWithLens:(Lens*)lens;
- (void)moveControl:(UIView*)view byYDelta:(CGFloat)delta;
- (void)readDefaultCircleOfLeastConfusion;
- (void)subjectDistanceRangeDidChange:(NSNotification*)notification;
- (void)unitsDidChange;
- (void)updateAperture;
- (void) updateDistanceFormatter;
- (void)updateFocalLength;
- (void)updateResult;
- (void)updateSubjectDistanceSliderLimits;
- (void)updateSubjectDistanceSliderPolicy;
- (void)updateSubjectDistance;
- (void)updateSubjectDistanceRangeText;

@property(nonatomic) int apertureIndex;
@property(nonatomic, retain) DistanceFormatter* distanceFormatter;
@property(nonatomic, retain) SubjectDistanceSliderPolicy* subjectDistanceSliderPolicy;

@end

@implementation MainViewController

#pragma mark Accessors

@synthesize apertureIndex;
@synthesize circleOfLeastConfusion;
@synthesize distanceFormatter;
@synthesize subjectDistance;
@synthesize subjectDistanceSliderPolicy;

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
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) 
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
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(lensDidChange:)
												 name:LENS_CHANGED_NOTIFICATION
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(subjectDistanceRangeDidChange:)
												 name:SUBJECT_DISTANCE_RANGE_CHANGED_NOTIFICATION
											   object:nil];
	
	[self initApertures];

	// Reading initial values from defaults
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[self setApertureIndex:[defaults integerForKey:FTApertureIndex]];
	[self setFocalLength:[defaults floatForKey:FTFocalLengthKey]];
	[self setSubjectDistance:[defaults floatForKey:FTSubjectDistanceKey]];
	[self readDefaultCircleOfLeastConfusion];
	
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self updateDistanceFormatter];
	
	[self updateSubjectDistanceSliderPolicy];
	
	// Set initial values in to controls
	[distanceType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:FTDistanceTypeKey]];
	[apertureSlider setValue:[self apertureIndex]];
	[focalLengthSlider setValue:[self focalLength]];
	[subjectDistanceSlider setValue:[[self subjectDistanceSliderPolicy] sliderValueForDistance:[self subjectDistance]]];
	
	// Set limits on sliders
	Lens* lens = [[CameraBag sharedCameraBag] findSelectedLens];
	[self lensDidChangeWithLens:lens];
	[self updateSubjectDistanceSliderLimits];

	[self customizeSliderAppearance:focalLengthSlider];
	[self customizeSliderAppearance:apertureSlider];
	[self customizeSliderAppearance:subjectDistanceSlider];
	
	[self updateAperture];
	[self updateFocalLength];
	[self updateSubjectDistance];
    [self updateSubjectDistanceRangeText];
	
	[self distanceTypeDidChange:self];
}

#pragma mark Action messages

// Aperture slider changed
- (void)apertureDidChange:(id)sender
{
	// Round slider value to nearest integer value to get index in to array
	[self setApertureIndex:[apertureSlider value] + 0.5f];
	
	[[NSUserDefaults standardUserDefaults] setInteger:[self apertureIndex]
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
	// Subject distance is a non-linear scale. This allows a wide range of settings
	// with finer grained control over near distances and coarser grained over
	// longer distances.
	[self setSubjectDistance:[[self subjectDistanceSliderPolicy] distanceForSliderValue:[subjectDistanceSlider value]]];
	
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
	[self updateSubjectDistanceSliderPolicy];
	[self updateSubjectDistanceSliderLimits];
	[self updateSubjectDistance];
	[self updateResult];
}

- (void)lensDidChange:(NSNotification*)notification
{
	Lens* lens = (Lens*)[notification object];
	[self lensDidChangeWithLens:lens];
}

- (void)lensDidChangeWithLens:(Lens*)lens
{
	[apertureMinimum setText:[NSString stringWithFormat:@"f/%@", [[lens minimumAperture] description]]];
	[apertureMaximum setText:[NSString stringWithFormat:@"f/%@", [[lens maximumAperture] description]]];
	int minimumIndex = [self indexNearestToAperture:[[lens minimumAperture] floatValue]];
	int maximumIndex = [self indexNearestToAperture:[[lens maximumAperture] floatValue]];
	[apertureSlider setMaximumValue:minimumIndex];
	[apertureSlider setMinimumValue:maximumIndex];
	
	[focalLengthMinimum setText:[NSString stringWithFormat:@"%@ mm", [[lens minimumFocalLength] description]]];
	[focalLengthMaximum setText:[NSString stringWithFormat:@"%@ mm", [[lens maximumFocalLength] description]]];
	[focalLengthSlider setMinimumValue:[[lens minimumFocalLength] floatValue]];
	[focalLengthSlider setMaximumValue:[[lens maximumFocalLength] floatValue]];
	
	// Reset the sliders with the current values. If outside the range, 
	// the slider will set to minimum or maximum. Setting the slider
	// value won't trigger the value changed action so we have to force it.
	[apertureSlider setValue:apertureIndex animated:YES];
	[self apertureDidChange:nil];
	[focalLengthSlider setValue:[self focalLength] animated:YES];
	[self focalLengthDidChange:nil];
	
	BOOL isPrime = ![lens isZoom];
	[focalLengthSlider setHidden:isPrime];
	[focalLengthMaximum setHidden:isPrime];
	[focalLengthMinimum setHidden:isPrime];

	if ((previousLensWasZoom && isPrime) || (!previousLensWasZoom && !isPrime))
	{
		CGFloat delta;
		delta = isPrime ? -controlYDelta : controlYDelta;

		[self moveControl:apertureLabel byYDelta:delta];
		[self moveControl:apertureText byYDelta:delta];
		[self moveControl:apertureSlider byYDelta:delta];
		[self moveControl:apertureMinimum byYDelta:delta];
		[self moveControl:apertureMaximum byYDelta:delta];
		
		[self moveControl:subjectDistanceLabel byYDelta:delta];
		[self moveControl:subjectDistanceText byYDelta:delta];
		[self moveControl:subjectDistanceSlider byYDelta:delta];
		[self moveControl:subjectDistanceMinimum byYDelta:delta];
		[self moveControl:subjectDistanceMaximum byYDelta:delta];
	}
	previousLensWasZoom = !isPrime;
}

- (void) updateDistanceFormatter 
{
	[self setDistanceFormatter:[[[DistanceFormatter alloc] init] autorelease]];

	[resultView setDistanceFormatter:[self distanceFormatter]];
}

- (void)subjectDistanceRangeDidChange:(NSNotification*)notification;
{
    [self updateSubjectDistanceRangeText];
    [self updateSubjectDistanceSliderPolicy];
    [self updateSubjectDistanceSliderLimits];
	[self updateSubjectDistance];
	[self updateResult];
}

#pragma mark Calculations

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

- (float)calculateFarLimit
{
	return [DepthOfFieldCalculator calculateFarLimitForAperture:[self aperture]
													focalLength:[self focalLength]
											  circleOfConfusion:[self circleOfLeastConfusion]
												subjectDistance:[[self subjectDistanceSliderPolicy] distanceForSliderValue:[subjectDistanceSlider value]]];
}

- (float)calculateHyperfocalDistance
{
	return [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:[self aperture]
															  focalLength:[self focalLength]
														circleOfConfusion:[self circleOfLeastConfusion]];
}

- (float)calculateNearLimit
{
	return [DepthOfFieldCalculator calculateNearLimitForAperture:[self aperture]
													 focalLength:[self focalLength]
											   circleOfConfusion:[self circleOfLeastConfusion]
												 subjectDistance:[[self subjectDistanceSliderPolicy] distanceForSliderValue:[subjectDistanceSlider value]]];
}

#pragma mark Updaters

// Update the aperture display
- (void)updateAperture
{
	NSString* formatted = [NSString stringWithFormat:@"f/%.1f", 
						   [[apertures objectAtIndex:[self apertureIndex]] floatValue]];
	
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

- (void)updateSubjectDistanceSliderLimits
{
	SubjectDistanceSliderPolicy* policy = [self subjectDistanceSliderPolicy];

	float minimum = [policy minimumDistanceToSubject];
	float maximum = [policy maximumDistanceToSubject];

	[subjectDistanceMinimum setText:[[self distanceFormatter] 
									 stringForObjectValue:[NSNumber numberWithFloat:minimum]]];
	[subjectDistanceMaximum setText:[[self distanceFormatter] 
									 stringForObjectValue:[NSNumber numberWithFloat:maximum]]];
	
	minimum = [policy sliderMinimum];
	maximum = [policy sliderMaximum];
	
	[subjectDistanceSlider setMinimumValue:minimum];
	[subjectDistanceSlider setMaximumValue:maximum];
}

// Update the distance to subject display
- (void)updateSubjectDistance
{
	[subjectDistanceText setText:[[self distanceFormatter] stringForObjectValue:[NSNumber numberWithFloat:[self subjectDistance]]]];
	[self updateResult];
}

- (void)updateSubjectDistanceRangeText
{
    int subjectDistanceRangeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTSubjectDistanceRangeKey];
    SubjectDistanceRangePolicy* subjectDistanceRangePolicy = 
        [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:subjectDistanceRangeIndex];
    
    [subjectDistanceRangeText setText:[subjectDistanceRangePolicy description]];
}

#pragma mark Helpers

- (void)customizeSliderAppearance:(UISlider*)slider
{
	static UIImage* sliderTrack;
	if (nil == sliderTrack)
	{
		sliderTrack = [[UIImage imageNamed:@"sliderTrack.png"]
					   stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	}
	
	[slider setMinimumTrackImage:sliderTrack forState:UIControlStateNormal];
	[slider setMaximumTrackImage:sliderTrack forState:UIControlStateNormal];
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
	[apertures addObject:[NSNumber numberWithFloat:100.0]];
	
	apertureIndex = 18;
}

- (int)indexNearestToAperture:(float)aperture
{
	// Assumes aperture value is between 1 and 100
	int index;
	for (index = 0; index < [apertures count] - 1; ++index)
	{
		if (aperture <= [[apertures objectAtIndex:index] floatValue])
		{
			break;
		}
	}
	
	return index;
}

- (void) moveControl:(UIView*)view byYDelta:(CGFloat)delta
{
	CGFloat x, y, width, height;
	x = [view frame].origin.x;
	y = [view frame].origin.y;
	width = [view frame].size.width;
	height = [view frame].size.height;
	[view setFrame:CGRectMake(x, y + delta, width, height)];
}

- (void)readDefaultCircleOfLeastConfusion
{
	Camera* camera = [[CameraBag sharedCameraBag] findSelectedCamera];
	
	[self setCircleOfLeastConfusion:[[camera coc] value]];
}

- (void)updateSubjectDistanceSliderPolicy
{
    SubjectDistanceRange subjectDistanceRange = 
        [[NSUserDefaults standardUserDefaults] integerForKey:FTSubjectDistanceRangeKey];
    SubjectDistanceRangePolicy* subjectDistanceRangePolicy = 
        [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:subjectDistanceRange];
	
    SubjectDistanceSliderPolicy* sliderPolicy = [[LinearSubjectDistanceSliderPolicy alloc] initWithSubjectDistanceRangePolicy:subjectDistanceRangePolicy];
    
    [self setSubjectDistanceSliderPolicy:sliderPolicy];
    [sliderPolicy release];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self setDistanceFormatter:nil];
	
	[self setSubjectDistanceSliderPolicy:nil];

    [subjectDistanceRangeText release];
    [super dealloc];
}

- (void)viewDidUnload 
{
    [subjectDistanceRangeText release];
    subjectDistanceRangeText = nil;

    [super viewDidUnload];
}
@end
