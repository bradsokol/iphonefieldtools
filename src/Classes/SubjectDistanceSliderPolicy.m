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
//  SubjectDistanceSliderPolicy.m
//  FieldTools
//
//  Created by Brad on 2011/12/04.
//  Copyright 2011 Brad Sokol. All rights reserved.
//

#import "SubjectDistanceSliderPolicy.h"

#import "SubjectDistanceRangePolicy.h"

@interface SubjectDistanceSliderPolicy ()

@property(nonatomic, retain) SubjectDistanceRangePolicy* subjectDistanceRangePolicy;

@end

@implementation SubjectDistanceSliderPolicy

@synthesize subjectDistanceRangePolicy;

- (id)initWithSubjectDistanceRangePolicy:(SubjectDistanceRangePolicy*)policy
{
    if (nil == (self = [super init]))
    {
        return nil;
    }
    
    [self setSubjectDistanceRangePolicy:policy];
    
    return self;
}

- (float)maximumDistanceToSubject
{
    return [[self subjectDistanceRangePolicy] maximumDistance];
}

- (float)minimumDistanceToSubject
{
    return [[self subjectDistanceRangePolicy] minimumDistance];
}

// Empty methods to satisfy compiler warning about incomplete class implementation

- (float)distanceForSliderValue:(float)value
{
    NSAssert(NO, @"Method %@ should only be called on derived classes.", NSStringFromSelector(_cmd));
    return 0.0f;
}

- (float)sliderMaximum
{
    NSAssert(NO, @"Method %@ should only be called on derived classes.", NSStringFromSelector(_cmd));
    return 0.0f;
}

- (float)sliderMinimum
{
    NSAssert(NO, @"Method %@ should only be called on derived classes.", NSStringFromSelector(_cmd));
    return 0.0f;
}

- (float)sliderValueForDistance:(float)distance
{
    NSAssert(NO, @"Method %@ should only be called on derived classes.", NSStringFromSelector(_cmd));
    return 0.0f;
}

@end