// Copyright 2009-2017 Brad Sokol
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
//  DistanceFormatter.m
//  FieldTools
//
//  Created by Brad on 2009/03/25.
//  Copyright 2009-2017 Brad Sokol. 
//

#import "DistanceFormatter.h"

#import "DistanceRange.h"
#import "UserDefaults.h"

const float METRES_TO_FEET = 3.280839895f;
const float METRES_TO_QUARTER_INCHES = METRES_TO_FEET * 48.0f;

const float METRES_TO_DECIMETRES = 10.0f;
const float METRES_TO_CENTIMETRES = 100.0f;
const float METRES_TO_MILLIMETRES = 1000.0f;

@interface DistanceFormatter ()

- (NSString*)formatDistance:(CGFloat)distance;
- (NSString*)formatDistancesForRange:(DistanceRange*)distanceRange;
- (NSString*)formatInches:(CGFloat)inches;
- (void)setNumberFormat;

@property(nonatomic,getter=isTesting) BOOL testing;

@end

@implementation DistanceFormatter

@synthesize decimalPlaces;
@synthesize distanceUnits;
@synthesize testing;

- (id)init
{
	return [self initForTest:NO];
}

- (id)initForTest:(BOOL)test
{
	if (nil == (self = [super init]))
	{
		return nil;
	}
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:1];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	[self setTesting:test];
	[self setDistanceUnits:DistanceUnitsMeters];

    decimalPlaces = 0;
	
	return self;
}

- (NSString*)stringForObjectValue:(id)anObject
{
	if ([anObject isKindOfClass:[DistanceRange class]])
	{
		return [self formatDistancesForRange:anObject];
	}
	else if ([anObject isKindOfClass:[NSNumber class]])
	{
		return [self formatDistance:[anObject floatValue]];
	}
	
	return nil;
}

// Convert distance if necessary than format decimals and units
- (NSString*)formatDistance:(CGFloat)distance
{
	if (distance < 0)
	{
		// Return infinity symbol
		return @"∞";
	}
	
	DistanceUnits units = [self isTesting] ? [self distanceUnits] :
		(DistanceUnits)[[NSUserDefaults standardUserDefaults] integerForKey:FTDistanceUnitsKey];
	
	distance = [self convertDistance:distance toUnits:units];

	float feet = 0.0f;
	float inches = 0.0f;
	
    [self setNumberFormat];
    NSString* localizedDistance = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:distance]];
    NSLog(@"Localized distance: %@", localizedDistance);
	switch (units)
	{
		case DistanceUnitsFeet:
			return [NSString stringWithFormat:[self formatStringForFeet], localizedDistance];
			break;
			
		case DistanceUnitsFeetAndInches:
			feet = floorf(distance);
			inches = floorf((12.0f * (distance - feet) + 0.125f) * 100.0f) / 100.0f;
			
			if (inches >= 12.0f)
			{
				feet += 1.0f;
				inches -= 12.0f;
			}
			
			if (feet == 0.0f)
			{
				return [self formatInches:inches];
			} 
			else if (inches <= 0.125f)
			{
				return [NSString stringWithFormat:@"%.0f'", feet];
			}
			else if (inches > 11.875f)
			{
				feet += 1.0f;
				return [NSString stringWithFormat:@"%.0f'", feet];
			}
			else
			{
				return [NSString stringWithFormat:@"%.0f' %@", feet, [self formatInches:inches]];
			}
			break;
			
		case DistanceUnitsMeters:
			return [NSString stringWithFormat:[self formatStringForMetres], localizedDistance];
			break;
            
        case DistanceUnitsCentimeters:
            return [NSString stringWithFormat:[self formatStringForCentimetres], localizedDistance];
            break;
	}
	
	// We should never get here. This is here to satisfy a compiler warning.
    NSAssert(FALSE, @"Unsupported distance units");
	return @"FORMATTING ERROR";
}

- (NSString*)formatDistancesForRange:(DistanceRange*)distanceRange
{
	return [NSString stringWithFormat:@"%@\t%@\t%@", 
			[self formatDistance:[distanceRange nearDistance]],
			[self formatDistance:[distanceRange farDistance] - [distanceRange nearDistance]],
			[self formatDistance:[distanceRange farDistance]]];
}

- (NSString*)formatInches:(CGFloat)inches
{
	int quarters = inches / 0.25f;
	NSString* fraction = @"";
	switch (quarters % 4)
	{
		case 1:
			fraction = @"¼";
			break;
		case 2:
			fraction = @"½";
			break;
		case 3:
			fraction = @"¾";
			break;
	}
	if (floorf(inches) < 0.5)
	{
		return [NSString stringWithFormat:@"%@\"", fraction];
	}
	else
	{
		return [NSString stringWithFormat:@"%.0f%@\"", floorf(inches), fraction];
	}
}

- (CGFloat)convertDistance:(CGFloat)distance toUnits:(DistanceUnits)units
{
	if (units == DistanceUnitsMeters)
	{
		return distance;
	}
    else if (units == DistanceUnitsCentimeters)
    {
        return distance * METRES_TO_CENTIMETRES;
    }
	else
	{
		return distance * METRES_TO_FEET;
	}
}

- (NSString*)formatStringForFeet
{
	return [NSString stringWithFormat:@"%%@ %@", 
			NSLocalizedString(@"FEET_ABBREVIATION", "Abbreviation for feet")];
}

- (NSString*)formatStringForMetres
{
	return [NSString stringWithFormat:@"%%@ %@",
			NSLocalizedString(@"METRES_ABBREVIATION", "Abbreviation for metres")];
}

- (NSString*)formatStringForCentimetres
{
	return [NSString stringWithFormat:@"%%@ %@",
			NSLocalizedString(@"CENTIMETRES_ABBREVIATION", "Abbreviation for centimetres")];
}

- (void)setDecimalPlaces:(NSUInteger)newDecimalPlaces
{
    if (decimalPlaces > 2)
    {
        NSAssert(FALSE, @"Decimal places must be 0, 1, or 2");
        return;
    }
    
    decimalPlaces = newDecimalPlaces;
}

- (void)setNumberFormat
{
    switch ([self decimalPlaces]) 
    {
        case 0:
            [numberFormatter setPositiveFormat:@"#,##0.#"];
            break;
            
        case 1:
            [numberFormatter setPositiveFormat:@"#,##0.0"];
            break;
            
        case 2:
            [numberFormatter setPositiveFormat:@"#,##0.00"];
            break;
    }
}

- (void)dealloc
{
    numberFormatter = nil;
    
}

@end
