// Copyright 2011 Brad Sokol
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
//  NonLinearSubjectDistanceSliderPolicy.m
//  FieldTools
//
//  Created by Brad Sokol on 2011-12-04.
//  Copyright (c) 2011 by Brad Sokol. All rights reserved.
//

#import "NonLinearSubjectDistanceSliderPolicy.h"

@implementation NonLinearSubjectDistanceSliderPolicy

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

- (float)sliderMaximum
{
    return [[self subjectDistanceRangePolicy] isMetric] ? 25.0f : 25.4775f;
}

- (float)sliderMinimum
{
    return [[self subjectDistanceRangePolicy] isMetric] ? 0.25f : 0.3048f;
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
