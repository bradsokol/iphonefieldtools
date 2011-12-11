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
//  SubjectDistanceRangePolicy.m
//  FieldTools
//
//  Created by Brad Sokol on 11-08-31.
//  Copyright 2011 by Brad Sokol. All rights reserved.
//

#import "SubjectDistanceRangePolicy.h"

#import "DistanceFormatter.h"
#import "UserDefaults.h"

@implementation SubjectDistanceRangePolicy

- (NSString*)rangeDescription
{
    DistanceFormatter* formatter = [[DistanceFormatter alloc] init];
    
    NSString* description = [NSString stringWithFormat:@"%@ to %@",
                             [formatter stringForObjectValue:[NSNumber numberWithFloat:[self minimumDistance]]],
                             [formatter stringForObjectValue:[NSNumber numberWithFloat:[self maximumDistance]]]];
    
    [formatter release];
    
    return description;
}

- (bool)isMetric
{    
    int distanceUnitsType = [[NSUserDefaults standardUserDefaults] integerForKey:FTDistanceUnitsKey];
    bool metric = distanceUnitsType == DistanceUnitsCentimeters ||
    distanceUnitsType == DistanceUnitsMeters;
    
    return metric;
}

-(CGFloat) minimumDistance
{
    return 0.0f;
}

-(CGFloat) maximumDistance
{
    return 0.0f;
}

@end