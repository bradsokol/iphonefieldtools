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
//  LinearSubjectDistanceSliderPolicy.m
//  FieldTools
//
//  Created by Brad Sokol on 2011-12-04.
//  Copyright (c) 2011 by Brad Sokol
//

#import "LinearSubjectDistanceSliderPolicy.h"

#import "UserDefaults.h"

extern const float METRES_TO_FEET;

@implementation LinearSubjectDistanceSliderPolicy

- (float)distanceForSliderValue:(float)value usingUnits:(DistanceUnits)units
{
    switch (units)
    {
        case DistanceUnitsFeet:
        case DistanceUnitsFeetAndInches:
            return roundf(value * METRES_TO_FEET * 10.0f) * 0.1f / METRES_TO_FEET;
            break;
            
        case DistanceUnitsMeters:
            return roundf(value * 100.0f) * 0.01f;
            break;
            
        case DistanceUnitsCentimeters:
            return roundf(value * 1000.0f) * 0.001f;
            break;
    }
    
    // We should never get here
    NSAssert(FALSE, @"Internal error. It looks like a case condition is missing or not implemented.");
	return value;
}

- (float)sliderMaximum
{
    return [[self subjectDistanceRangePolicy] maximumDistance];
}

- (float)sliderMinimum
{
    return [[self subjectDistanceRangePolicy] minimumDistance];
}

- (float)sliderValueForDistance:(float)distance
{
	return distance;
}

@end
