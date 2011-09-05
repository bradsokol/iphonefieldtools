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

//
//  FarSubjectDistanceRangePolicy.m
//  FieldTools
//
//  Created by Brad Sokol on 2011-09-05.
//  Copyright 2011 Cubic Apps. All rights reserved.
//

#import "FarSubjectDistanceRangePolicy.h"

#import "DistanceFormatter.h"

static const float MAXIMUM_IMPERIAL = 2000.0f;
static const float MINIMUM_IMPERIAL = (1.0f / 12.0f);

static const float MAXIMUM_METRIC = 500.0f;
static const float MINIMUM_METRIC = 0.01f;

@implementation FarSubjectDistanceRangePolicy

- (CGFloat)minimumDistance
{
    return [self isMetric] ? MINIMUM_METRIC : MINIMUM_IMPERIAL / METRES_TO_FEET;
}

- (CGFloat)maximumDistance
{
    return [self isMetric] ? MAXIMUM_METRIC : MAXIMUM_IMPERIAL / METRES_TO_FEET;
}

@end
