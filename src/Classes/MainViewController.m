// Copyright 2009-2025 Brad Sokol
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

#import "DepthOfFieldCalculator.h"
#import "DistanceFormatter.h"
#import "FieldToolsAppDelegate.h"
#import "FlipsideViewController.h"
#import "FTCamera.h"
#import "FTCameraBag.h"
#import "FTCoC.h"
#import "FTLens.h"
#import "LinearSubjectDistanceSliderPolicy.h"
#import "MPCoachMarks.h"
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
- (void)configureCoachMarks;
- (void)configureObservers;
- (void)configureSliderColours;
- (void)cocDidChange;
- (int)indexNearestToAperture:(float)aperture;
- (void)initApertures;
- (void)lensDidChange:(NSNotification*)notification;
- (void)lensDidChangeWithLens:(FTLens*)lens;
- (void)moveControl:(UIView*)view byYDelta:(CGFloat)delta;
- (void)readDefaultCircleOfLeastConfusion;
- (bool)shouldShowTenths;
- (void)subjectDistanceRangeDidChange:(NSNotification*)notification;
- (void)unitsDidChange;
- (void)updateAperture;
- (void)updateCameraAndLensDescription;
- (void)updateDistanceFormatter;
- (void)updateFocalLength;
- (void)updateResult;
- (void)updateResultView;
- (void)updateSubjectDistanceSliderLimits;
- (void)updateSubjectDistanceSliderPolicy;
- (void)updateSubjectDistance;
- (void)updateSubjectDistanceRangeText;

@property(nonatomic) NSInteger apertureIndex;
@property(nonatomic, strong) DistanceFormatter* distanceFormatter;
@property(nonatomic, strong) SubjectDistanceSliderPolicy* subjectDistanceSliderPolicy;

@end

@implementation MainViewController

#pragma mark Accessors

@synthesize analyticsPolicy;
@synthesize apertureIndex;
@synthesize cameraAndLensDescription;
@synthesize circleOfLeastConfusion;
@synthesize distanceFormatter;
@synthesize infoButton;
@synthesize subjectDistance;
@synthesize subjectDistanceSliderPolicy;

// Convert aperture index to an aperture which is set of values
// with a non-deterministic pattern.
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

- (void)viewDidLoad 
{
    [super viewDidLoad];

    [self configureObservers];
    
    [self initApertures];
    
    // Reading initial values from defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [self setApertureIndex:[defaults integerForKey:FTApertureIndex]];
    [self setFocalLength:[defaults floatForKey:FTFocalLengthKey]];
    [self setSubjectDistance:[defaults floatForKey:FTSubjectDistanceKey]];
    [self readDefaultCircleOfLeastConfusion];


    NSInteger distanceTypeSetting = [[NSUserDefaults standardUserDefaults]
                        integerForKey:FTDistanceTypeKey];

    [self updateCameraAndLensDescription];
    
	[self updateDistanceFormatter];
	
	[self updateSubjectDistanceSliderPolicy];
	
	// Set initial values in to controls
	[distanceType setSelectedSegmentIndex:distanceTypeSetting];
	[apertureSlider setValue:[self apertureIndex]];
	[focalLengthSlider setValue:[self focalLength]];
	[subjectDistanceSlider setValue:[[self subjectDistanceSliderPolicy] sliderValueForDistance:[self subjectDistance]]
                           animated:YES];
	
	// Set limits on sliders
	FTLens* lens = [[FTCameraBag sharedCameraBag] findSelectedLens];
	[self lensDidChangeWithLens:lens];
	[self updateSubjectDistanceSliderLimits];

    [self updateResultView];
	[self updateAperture];
	[self updateFocalLength];
	[self updateSubjectDistance];
    [self updateSubjectDistanceRangeText];
	
	[self distanceTypeDidChange:self];

    [self configureSliderColours];
}

- (void)viewDidLayoutSubviews
{
    static BOOL coachMarksShown = NO;
    [super viewDidLayoutSubviews];
    if (coachMarksShown == NO) {
        [self configureCoachMarks];
        coachMarksShown = YES;
    }
}

#pragma mark Action messages

- (IBAction)subjectDistanceRangeTextWasTouched:(id)sender
{
    SubjectDistanceRangePolicy* macro = [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:SubjectDistanceRangeMacro];
    SubjectDistanceRangePolicy* close = [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:SubjectDistanceRangeClose];
    SubjectDistanceRangePolicy* mid = [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:SubjectDistanceRangeMid];
    SubjectDistanceRangePolicy* far = [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:SubjectDistanceRangeFar];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SUBJECT_DISTANCE_RANGES_VIEW_TITLE", "SUBJECT_DISTANCE_RANGES_VIEW_TITLE")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* macroButton = [UIAlertAction actionWithTitle:[macro description]
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction* action){
        [self handleSubjectDistanceRangeSelection:0];
    }];
    [alert addAction:macroButton];

    UIAlertAction* closeButton = [UIAlertAction actionWithTitle:[close description]
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction* action){
        [self handleSubjectDistanceRangeSelection:1];
    }];
    [alert addAction:closeButton];

    UIAlertAction* midButton = [UIAlertAction actionWithTitle:[mid description]
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction* action){
        [self handleSubjectDistanceRangeSelection:2];
    }];
    [alert addAction:midButton];

    UIAlertAction* farButton = [UIAlertAction actionWithTitle:[far description]
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction* action){
        [self handleSubjectDistanceRangeSelection:3];
    }];
    [alert addAction:farButton];

    [self presentViewController:alert animated:YES completion:nil];
}

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
    NSInteger distanceTypeSetting = [distanceType selectedSegmentIndex];
	[[NSUserDefaults standardUserDefaults] setInteger:distanceTypeSetting
											   forKey:FTDistanceTypeKey];

	// Show or hide the distance slider depending on the distance
	// type selected in the segment control.
	BOOL hide = [distanceType selectedSegmentIndex] == HYPERFOCAL_SEGMENT_INDEX;
	[subjectDistanceLabel setHidden:hide];
	[subjectDistanceText setHidden:hide];
	[subjectDistanceSlider setHidden:hide];
	[subjectDistanceMinimum setHidden:hide];
	[subjectDistanceMaximum setHidden:hide];
    [subjectDistanceRangeText setHidden:hide];

	[self updateResult];
}

// Focal length slider changed
- (void)focalLengthDidChange:(id)sender
{
	FTLens* lens = [[FTCameraBag sharedCameraBag] findSelectedLens];
    
    if ([lens isZoom])
    {
        // Round slider value to nearest integer value
        [self setFocalLength:floorf([focalLengthSlider value] + 0.5f)];
    }
	
	[[NSUserDefaults standardUserDefaults] setFloat:[self focalLength]
											 forKey:FTFocalLengthKey];
	
	[self updateFocalLength];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// Distance to subject slider was changed
- (void)subjectDistanceDidChange:(id)sender
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    DistanceUnits distanceUnits = (DistanceUnits)[defaults integerForKey:FTDistanceUnitsKey];

	[self setSubjectDistance:[[self subjectDistanceSliderPolicy] distanceForSliderValue:[subjectDistanceSlider value] usingUnits:distanceUnits]];
	
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

- (void)updateResultView
{
    [resultView setShowTenths:[self shouldShowTenths]];
    
    [self updateResult];
}

// Notification that units changed. Need to re-display results.
- (void)unitsDidChange
{
	[self updateResultView];
    
	[self updateSubjectDistanceSliderPolicy];
	[self updateSubjectDistanceSliderLimits];
	[self updateSubjectDistance];
	[self updateResult];
}

- (void)lensDidChange:(NSNotification*)notification
{
	FTLens* lens = (FTLens*)[notification object];
	[self lensDidChangeWithLens:lens];
}

- (void)lensDidChangeWithLens:(FTLens*)lens
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
    
	BOOL isPrime = ![lens isZoom];
    if (isPrime)
    {
        [self setFocalLength:[[lens minimumFocalLength] floatValue]];
    }
    else 
    {
        [focalLengthSlider setValue:[self focalLength] animated:YES];
    }
	[self focalLengthDidChange:nil];
	
	[focalLengthSlider setHidden:isPrime];
	[focalLengthMaximum setHidden:isPrime];
	[focalLengthMinimum setHidden:isPrime];

	if ((previousLensWasZoom && isPrime) || (!previousLensWasZoom && !isPrime))
	{
        apertureToFocalLengthConstraint.constant += isPrime ? -controlYDelta : controlYDelta;
	}
	previousLensWasZoom = !isPrime;
}

- (void) updateDistanceFormatter 
{
	[self setDistanceFormatter:[[DistanceFormatter alloc] init]];

	[resultView setDistanceFormatter:[self distanceFormatter]];
}

- (void)subjectDistanceRangeDidChange:(NSNotification*)notification;
{
	[self updateResultView];
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
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    DistanceUnits distanceUnits = (DistanceUnits)[defaults integerForKey:FTDistanceUnitsKey];

	return [DepthOfFieldCalculator calculateFarLimitForAperture:[self aperture]
													focalLength:[self focalLength]
											  circleOfConfusion:[self circleOfLeastConfusion]
												subjectDistance:[[self subjectDistanceSliderPolicy] distanceForSliderValue:[subjectDistanceSlider value]
                                                                 usingUnits:distanceUnits]];
}

- (float)calculateHyperfocalDistance
{
	return [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:[self aperture]
															  focalLength:[self focalLength]
														circleOfConfusion:[self circleOfLeastConfusion]];
}

- (float)calculateNearLimit
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    DistanceUnits distanceUnits = (DistanceUnits)[defaults integerForKey:FTDistanceUnitsKey];

	return [DepthOfFieldCalculator calculateNearLimitForAperture:[self aperture]
													 focalLength:[self focalLength]
											   circleOfConfusion:[self circleOfLeastConfusion]
												 subjectDistance:[[self subjectDistanceSliderPolicy] distanceForSliderValue:[subjectDistanceSlider value]
                                                                  usingUnits:distanceUnits]];
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

- (void)updateCameraAndLensDescription
{
	FTCameraBag* cameraBag = [FTCameraBag sharedCameraBag];
	
    NSString* title = [NSString stringWithFormat:@"%@ - %@",
                       [cameraBag findSelectedCamera], [cameraBag findSelectedLens]];
    
	[cameraAndLensDescription setTitle:title forState:UIControlStateNormal];
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
    
    if ([self subjectDistance] > [policy maximumDistanceToSubject])
    {
        [self setSubjectDistance:[policy maximumDistanceToSubject]];
    }
    else if ([self subjectDistance] < [policy minimumDistanceToSubject])
    {
        [self setSubjectDistance:[policy minimumDistanceToSubject]];
    }

	float minimum = [policy minimumDistanceToSubject];
	float maximum = [policy maximumDistanceToSubject];

    [distanceFormatter setDecimalPlaces:0];
	[subjectDistanceMinimum setText:[[self distanceFormatter] 
									 stringForObjectValue:[NSNumber numberWithFloat:minimum]]];
	[subjectDistanceMaximum setText:[[self distanceFormatter] 
									 stringForObjectValue:[NSNumber numberWithFloat:maximum]]];
    [distanceFormatter setDecimalPlaces:[self shouldShowTenths] ? 1 : 0];
	
	minimum = [policy sliderMinimum];
	maximum = [policy sliderMaximum];
	
	[subjectDistanceSlider setMinimumValue:minimum];
	[subjectDistanceSlider setMaximumValue:maximum];

    [subjectDistanceSlider setValue:[policy sliderValueForDistance:[self subjectDistance]]
                           animated:YES];
    [subjectDistanceSlider setNeedsDisplay];
}

// Update the distance to subject display
- (void)updateSubjectDistance
{
    SubjectDistanceRange subjectDistanceRange = 
        (SubjectDistanceRange)[[NSUserDefaults standardUserDefaults] integerForKey:FTSubjectDistanceRangeKey];
    DistanceUnits units = 
        (DistanceUnits)[[NSUserDefaults standardUserDefaults] integerForKey:FTDistanceUnitsKey];

    if (DistanceUnitsMeters == units && (subjectDistanceRange == SubjectDistanceRangeClose ||
                                         subjectDistanceRange == SubjectDistanceRangeMacro))
    {
        [distanceFormatter setDecimalPlaces:2];
    }
    else 
    {
        [distanceFormatter setDecimalPlaces:0];
    }
    
	[subjectDistanceText setText:[[self distanceFormatter] stringForObjectValue:[NSNumber numberWithFloat:[self subjectDistance]]]];
	[self updateResult];
}

- (void)updateSubjectDistanceRangeText
{
    NSInteger subjectDistanceRangeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTSubjectDistanceRangeKey];
    SubjectDistanceRangePolicy* subjectDistanceRangePolicy = 
        [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:(SubjectDistanceRange)subjectDistanceRangeIndex];
    
    [subjectDistanceRangeText setTitle:[subjectDistanceRangePolicy description]
                              forState:UIControlStateNormal];
}

#pragma mark Helpers

- (void)configureCoachMarks
{
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:FTCoachMarksShown];
    bool force = [[[NSProcessInfo processInfo] environment] objectForKey:@"SHOW_COACH_MARKS"];
    if (coachMarksShown == NO || force) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FTCoachMarksShown];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSMutableArray* coachMarks = [[NSMutableArray alloc] init];
        if (focalLengthSlider.hidden == NO)
        {
            CGRect coachMark = CGRectInset(focalLengthSlider.frame, -2.0, -2.0);
            [coachMarks addObject:@{
                  @"rect": [NSValue valueWithCGRect:coachMark],
                  @"caption": NSLocalizedString(@"FOCAL_LENGTH_SCRUBBING_COACH", "FOCAL_LENGTH_SCRUBBING_COACH"),
                  }
            ];
        }

        if (subjectDistanceSlider.hidden == NO)
        {
            CGRect frame = CGRectOffset(subjectDistanceSlider.frame, 0, focalLengthSlider.hidden ? -controlYDelta : 0);
            CGRect coachMark = CGRectInset(frame, -2.0, -2.0);
            NSString* stringKey = focalLengthSlider.hidden ? @"DISTANCE_SCRUBBING_COACH" : @"DISTANCE_SCRUBBING_COACH_SECOND";
            NSString* caption = NSLocalizedString(stringKey, stringKey);
            [coachMarks addObject:@{
                                    @"rect": [NSValue valueWithCGRect:coachMark],
                                    @"caption": caption,
                                    @"position": [NSNumber numberWithInteger:LABEL_POSITION_TOP]
                                    }
             ];
        }

        CGRect frame = CGRectInset(cameraAndLensDescription.frame, -2.0, -2.0);
        [coachMarks addObject:@{
            @"rect": [NSValue valueWithCGRect:frame],
            @"caption": NSLocalizedString(@"CAMERA_LENS_DESCRIPTION_COACH", "CAMERA_LENS_DESCRIPTION_COACH"),
        }
        ];

        MPCoachMarks* coachMarksView = [[MPCoachMarks alloc]
                                        initWithFrame:UIScreen.mainScreen.bounds
                                        coachMarks:coachMarks];
        coachMarksView.enableSkipButton = NO;
        coachMarksView.continueLabelText = NSLocalizedString(@"GOT_IT", "GOT_IT");
        [self.view addSubview:coachMarksView];
        [coachMarksView start];
    }
}

- (void)configureObservers
{
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
}

- (void)configureSliderColours
{
    UIColor *trackColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];
    apertureSlider.minimumTrackTintColor = trackColor;
    focalLengthSlider.minimumTrackTintColor = trackColor;
    subjectDistanceSlider.minimumTrackTintColor = trackColor;
    apertureSlider.maximumTrackTintColor = trackColor;
    focalLengthSlider.maximumTrackTintColor = trackColor;
    subjectDistanceSlider.maximumTrackTintColor = trackColor;
}

// Initialise a table of f-number values using standard one-third stop increments
- (void)initApertures
{
	apertures = [[NSMutableArray alloc] initWithCapacity:39];
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
	[apertures addObject:[NSNumber numberWithFloat:28.0]];
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
	FTCamera* camera = [[FTCameraBag sharedCameraBag] findSelectedCamera];
	
	[self setCircleOfLeastConfusion:[[camera coc] valueValue]];
}

- (void)updateSubjectDistanceSliderPolicy
{
    SubjectDistanceRange subjectDistanceRange = 
        (SubjectDistanceRange)[[NSUserDefaults standardUserDefaults] integerForKey:FTSubjectDistanceRangeKey];
    SubjectDistanceRangePolicy* subjectDistanceRangePolicy = 
        [[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyForSubjectDistanceRange:subjectDistanceRange];
	
    SubjectDistanceSliderPolicy* sliderPolicy = [[LinearSubjectDistanceSliderPolicy alloc] initWithSubjectDistanceRangePolicy:subjectDistanceRangePolicy];
    
    [self setSubjectDistanceSliderPolicy:sliderPolicy];
}

- (bool)shouldShowTenths
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    DistanceUnits distanceUnits = (DistanceUnits)[defaults integerForKey:FTDistanceUnitsKey];
    SubjectDistanceRange subjectDistanceRange = (SubjectDistanceRange)[defaults integerForKey:FTSubjectDistanceRangeKey];
    
    return distanceUnits == DistanceUnitsCentimeters &&
        subjectDistanceRange == SubjectDistanceRangeMacro;
}

#pragma mark FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateCameraAndLensDescription];
}

- (void)handleSubjectDistanceRangeSelection:(NSInteger)buttonIndex
{
    // The cancel button counts as one of the buttons.
    if ([[SubjectDistanceRangePolicyFactory sharedPolicyFactory] policyCount] == buttonIndex)
    {
        return;
    }
    
    NSInteger oldSubjectDistanceRangeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTSubjectDistanceRangeKey];
    if (buttonIndex != oldSubjectDistanceRangeIndex)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex
                                                   forKey:FTSubjectDistanceRangeKey];
        
        [[NSNotificationCenter defaultCenter] 
         postNotification:[NSNotification notificationWithName:SUBJECT_DISTANCE_RANGE_CHANGED_NOTIFICATION object:nil]];
    }
}

- (IBAction)toggleView
{
    FlipsideViewController* controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];

    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller setNavigationController:navController];
    
	UINavigationItem* navigationItem = [[[navController navigationBar] items] objectAtIndex:0];
	[navigationItem setTitle:NSLocalizedString(@"SETTINGS_TITLE", "Settings title")];
    [navController navigationBar].barStyle = UIBarStyleDefault;
    
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
