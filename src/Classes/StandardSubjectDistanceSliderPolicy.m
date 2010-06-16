// Copyright 2010 Brad Sokol
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
//  StandardSubjectDistanceSliderPolicy.m
//  FieldTools
//
//  Created by Brad on 2010/06/06.
//  Copyright 2010 Brad Sokol. All rights reserved.
//

#import "StandardSubjectDistanceSliderPolicy.h"

@implementation StandardSubjectDistanceSliderPolicy

// Prevent instantiation i.e. make this class behave like an abstract base class
- (id)init
{
	[self doesNotRecognizeSelector:_cmd];
	[self release];
	return nil;
}

- (float)maximumDistanceToSubject
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	
	// We should never get here. This is to satisfy a compiler warning.
	return 0.0f;
}

- (float)minimumDistanceToSubject
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	
	// We should never get here. This is to satisfy a compiler warning.
	return 0.0f;
}

- (float)sliderMaximum
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	
	// We should never get here. This is to satisfy a compiler warning.
	return 0.0f;
}

- (float)sliderMinimum
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	
	// We should never get here. This is to satisfy a compiler warning.
	return 0.0f;
}

- (float)distanceForSliderValue:(float)value
{
	if (value <= 12.5f)
	{
		return value;
	}
	else if (value <= 18.75f)
	{
		return value * 2.0f - 12.0f;
	}
	else
	{
		return value * 8.0f - 120.0f;
	}
}

- (float)sliderValueForDistance:(float)distance
{
	if (distance <= 12.5f)
	{
		return distance;
	}
	else if (distance <= 25.5)
	{
		return (distance + 12.0f) / 2.0f;
	}
	else
	{
		return (distance + 120.0f) / 8.0f;
	}
}

@end
