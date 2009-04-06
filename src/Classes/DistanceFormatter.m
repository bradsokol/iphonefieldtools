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
	if (distance < 0)
	{
		// Return infinity symbol
		return @"∞";
	}
	
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
	
	return [NSString stringWithFormat:@"%.1f %@", distance, units];
}

@end
