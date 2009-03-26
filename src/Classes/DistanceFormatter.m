//
//  DistanceFormatter.m
//  FieldTools
//
//  Created by Brad on 2009/03/25.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "DistanceFormatter.h"

#import "UserDefaults.h"

// Constant for converting  from metres to feet
const static float METRES_TO_FEET = 3.280839895f;

@interface DistanceFormatter (Private)

- (NSString*)formatDistance:(CGFloat)distance;

@end

@implementation DistanceFormatter

- (NSString*)stringForObjectValue:(id)anObject
{
	if (![anObject isKindOfClass:[NSNumber class]])
	{
		return nil;
	}
	
	return [self formatDistance:[anObject floatValue]];
}

// Convert distance if necessary than format decimals and units
- (NSString*)formatDistance:(CGFloat)distance
{
	BOOL metric = [[NSUserDefaults standardUserDefaults] boolForKey:FTMetricKey];
	NSString* units;
	if (metric)
	{
		units = NSLocalizedString(@"METRES_ABBREVIATION", "Abbreviation for metres");
	}
	else
	{
		distance *= METRES_TO_FEET;
		units = NSLocalizedString(@"FEET_ABBREVIATION", "Abbreviation for feet");
	}
	
	if (distance < 0)
	{
		return NSLocalizedString(@"INFINITY", "Infinity");
	}
	
	return [NSString stringWithFormat:@"%.1f %@", distance, units];
}

@end
