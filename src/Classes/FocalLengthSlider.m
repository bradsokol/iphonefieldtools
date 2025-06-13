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
//  FocalLengthSlider.m
//  FieldTools
//
//  Created by Brad Sokol on 2011/01/15.
//  Copyright 2009-2025 Brad Sokol
//

#import "FocalLengthSlider.h"

@interface FocalLengthSlider()

-(NSArray*)defaultScrubbingSpeeds;
-(NSArray*)defaultScrubbingSpeedChangePositions;

@end

@implementation FocalLengthSlider

-(NSArray*)defaultScrubbingSpeeds
{
    return [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:1.0f],
            [NSNumber numberWithFloat:0.75f],
            [NSNumber numberWithFloat:0.50f],
            [NSNumber numberWithFloat:0.25f],
            nil];
}

-(NSArray*)defaultScrubbingSpeedChangePositions
{
    return [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:0.0f],
            [NSNumber numberWithFloat:50.0f],
            [NSNumber numberWithFloat:100.0f],
            [NSNumber numberWithFloat:150.0f],
            nil];
}

@end
