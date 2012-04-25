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
//  ResultView.m
//  FieldTools
//
//  The result view displays either a single value in a UITextField, or
//  a range - minimum distance, maximum distance and distance between.
//
//  The range is displayed with three UILabels and a UIImageView (for the 
//  arrows) overtop of an empty UITextField which serves as a background.
//  Single values are displayed in a second UIImageView. The unneeded 
//  controls are hidden to swap between one type of display and another.
//
//  Previous versions used a single UIImageView and set the text to an
//  empty string when showing a range. With iOS 4.0, this stopped working.
//  When swapping between range view and single value view, the single value
//  would take as long as a minute to appear. Using two UIImageViews 
//  eliminates this delay.
//
//  Created by Brad on 2009/03/19.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "ResultView.h"

#import "DistanceFormatter.h"
#import "SubjectDistanceRangePolicyFactory.h"
#import "UserDefaults.h"

static const float DIFFERENCE_FONT_SIZE = 17.0;
static const float FONT_SIZE = 28.0;
static const float INFINITY_FONT_SIZE = 32.0;
static const float SMALL_FONT_SIZE = 24.0;

@interface ResultView ()

- (void)adjustFontsForNearFarDisplay;
- (void)adjustNumberDisplay:(UILabel*)label inRect:(CGRect)rect;
- (void)configureControls;
- (void)hideNumberLabels:(bool)hide;

@end

@implementation ResultView

@synthesize distanceFormatter;

// Initializer used when loading from a NIB. If the view is created
// in other ways, other initializers will need to be implemented.
- (id)initWithCoder:(NSCoder*)decoder
{
	self = [super initWithCoder:decoder];
	if (nil == self)
	{
		return nil;
	}
	
	[self setDistanceFormatter:[[[DistanceFormatter alloc] init] autorelease]];
	firstDraw = YES;
	
    return self;
}

- (void)setShowTenths:(bool)showTenths
{
    [[self distanceFormatter] setShowTenths:showTenths];
}

- (void)drawRect:(CGRect)rect 
{
	if (firstDraw)
	{
		// For some reason this does not work in viewDidLoad.
		[self configureControls];
		
		[self sendSubviewToBack:background];
		
		firstDraw = NO;
	}
	
	if (displayRange)
	{
		// Displaying two values and the difference. Show the UILabels
		// and put an empty string in the UITextView. This keeps it visible
		// with its rounded corners, and we just use it as a background. The
		// effect is a UITextView displaying three values and the image.
		[self hideNumberLabels:NO];
		
		[self adjustFontsForNearFarDisplay];

		leftNumber.text = [[self distanceFormatter] stringForObjectValue:[NSNumber numberWithFloat:nearDistance]];
		rightNumber.text = [[self distanceFormatter] stringForObjectValue:[NSNumber numberWithFloat:farDistance]];
		difference.text = [[self distanceFormatter] stringForObjectValue:[NSNumber numberWithFloat:distanceDifference]];
		
		NSLog(@"drawRect near: %@ far: %@ difference: %@", leftNumber.text, rightNumber.text, difference.text);
		
		// Hide the difference if infinity (i.e. less than zero)
		difference.hidden = distanceDifference <= 0;
	}
	else
	{
		// Displaying a single value in the UITextField. Hide everything else
		[self hideNumberLabels:YES];
		
		largeText.text = [[self distanceFormatter] stringForObjectValue:[NSNumber numberWithFloat:nearDistance]];
	}
}

// Call this method to display a single value.
- (void)setResult:(CGFloat)distance
{
#ifdef DEBUG
    NSLog(@"setResult: distance: %f", distance);
#endif
	displayRange = NO;
	nearDistance = distance;
	[self setNeedsDisplay];
}

// Call this method to display two values and the difference.
- (void)setResultNear:(CGFloat)near far:(CGFloat)far
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

#ifdef DEBUG
	float factor = [defaults integerForKey:FTDistanceUnitsKey] == DistanceUnitsMeters ? 1.0f : 3.280839895f;
	NSLog(@"setResult: near: %f far: %f", near * factor, far * factor);
#endif
	
	displayRange = YES;

	DistanceUnits distanceUnits = [defaults integerForKey:FTDistanceUnitsKey];
    switch (distanceUnits)
    {
        case DistanceUnitsFeetAndInches:
            // When formatting feet and inches, values will be rounded to the nearest quarter inch.
            // Must adjust near and far to nearest quarter inch so that distance difference 
            // calculation will be correct after rounding.
            nearDistance = rintf(near * METRES_TO_QUARTER_INCHES) / METRES_TO_QUARTER_INCHES;
            farDistance = rintf(far * METRES_TO_QUARTER_INCHES) / METRES_TO_QUARTER_INCHES;
            break;
            
        case DistanceUnitsMeters:
            NSLog(@"rintf: %f", (far * METRES_TO_DECIMETRES));
			nearDistance = rintf(near * METRES_TO_DECIMETRES) / METRES_TO_DECIMETRES;
			farDistance = rintf(far * METRES_TO_DECIMETRES) / METRES_TO_DECIMETRES;
            break;
            
        default:
            if ([defaults integerForKey:FTSubjectDistanceRangeKey] == SubjectDistanceRangeMacro)
            {
                nearDistance = rintf(near * METRES_TO_MILLIMETRES) / METRES_TO_MILLIMETRES;
                farDistance = rintf(far * METRES_TO_MILLIMETRES) / METRES_TO_MILLIMETRES;
            }
            else
            {
                nearDistance = rintf(near * METRES_TO_CENTIMETRES) / METRES_TO_CENTIMETRES;
                farDistance = rintf(far * METRES_TO_CENTIMETRES) / METRES_TO_CENTIMETRES;
            }
            break;
    }
	
	distanceDifference = farDistance - nearDistance;

#ifdef DEBUG
	NSLog(@"setResult nearDistance: %f farDistance: %f difference: %f", 
		  nearDistance * factor, farDistance * factor, distanceDifference * factor);
#endif
	
	[self setNeedsDisplay];
}

// One-time configuration of the various controls.
- (void)configureControls
{
	CGRect rect = [self bounds];
	
	// Adjust the height of the text display to show larger font.
	CGRect r = [largeText frame];
	r.size.height *= 1.75f;
	[largeText setFrame:r];
	[background setFrame:r];

	[self adjustNumberDisplay:leftNumber inRect:rect];
	[self adjustNumberDisplay:rightNumber inRect:rect];
}

// Adjust the size of the frame of UILabel.
- (void)adjustNumberDisplay:(UILabel*)label inRect:(CGRect)rect
{
	CGRect frame = label.frame;
	frame.origin.y = 0.5 * rect.size.height;
	frame.size.height *= 1.25;
	label.frame = frame;
}

// Adjust fonts as appropriate for the values being displayed.
- (void)adjustFontsForNearFarDisplay 
{
	float leftFontSize = FONT_SIZE;
	float rightFontSize = FONT_SIZE;
	float differenceFontSize = DIFFERENCE_FONT_SIZE;
	if (nearDistance >= 100.0 || farDistance >= 100.0)
	{
		// Slightly smaller font for larger values.
		leftFontSize = rightFontSize = SMALL_FONT_SIZE;
	}
	else if (farDistance <= 0.0)
	{
		// Slightly larger font for the infinity symbol
		rightFontSize = differenceFontSize = INFINITY_FONT_SIZE;
	}
	
	[leftNumber setFont:[[leftNumber font] fontWithSize:leftFontSize]];
	[rightNumber setFont:[[rightNumber font] fontWithSize:rightFontSize]];
	[difference setFont:[[difference font] fontWithSize:differenceFontSize]];
}

// Helper to show or hide the two value with difference elements.
- (void)hideNumberLabels:(bool)hide
{
	largeText.hidden = !hide;
	
	background.hidden = hide;
	leftNumber.hidden = hide;
	rightNumber.hidden = hide;
	difference.hidden = hide;
	distanceArrows.hidden = hide;
}

- (void)dealloc 
{
	[self setDistanceFormatter:nil];
	
    [super dealloc];
}

@end
