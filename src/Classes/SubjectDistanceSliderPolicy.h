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
//  SubjectDistanceSliderPolicy.h
//  FieldTools
//
//  Created by Brad on 2010/06/06.
//  Copyright 2009-2025 Brad Sokol
//

#import <UIKit/UIKit.h>

#import "SubjectDistanceRangePolicy.h"

#import "UserDefaults.h"

@interface SubjectDistanceSliderPolicy : NSObject
{
    SubjectDistanceRangePolicy* subjectDistanceRangePolicy;
}

- (id)initWithSubjectDistanceRangePolicy:(SubjectDistanceRangePolicy*)policy;
    
- (float)distanceForSliderValue:(float)value usingUnits:(DistanceUnits)units;
- (float)maximumDistanceToSubject;
- (float)minimumDistanceToSubject;
- (float)sliderMaximum;
- (float)sliderMinimum;
- (float)sliderValueForDistance:(float)distance;

@property(nonatomic, strong, readonly) SubjectDistanceRangePolicy* subjectDistanceRangePolicy;

@end
