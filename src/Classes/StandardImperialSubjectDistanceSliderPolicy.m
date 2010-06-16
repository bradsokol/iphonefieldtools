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
//  StandardImperialSubjectDistanceSliderPolicy.m
//  FieldTools
//
//  Created by Brad on 2010/06/06.
//  Copyright 2010 Brad Sokol. All rights reserved.
//

#import "StandardImperialSubjectDistanceSliderPolicy.h"

static float minimumDistanceToSubject = 0.3048f; // one foot as metres
static float maximumDistanceToSubject = 83.82f;	// 275 feet as metres

static float sliderMaximum = 25.4775f;
static float sliderMinimum = 0.3048f;

@implementation StandardImperialSubjectDistanceSliderPolicy

- (id)init
{
	// Do not call init on super. It throws to ensure that the base class 
	// cannot be instantiated (behaving like an abstract base class).
	return self;
}

- (float)maximumDistanceToSubject
{
	return maximumDistanceToSubject;
}

- (float)minimumDistanceToSubject
{
	return minimumDistanceToSubject;
}

- (float)sliderMaximum
{
	return sliderMaximum;
}

- (float)sliderMinimum
{
	return sliderMinimum;
}

@end
