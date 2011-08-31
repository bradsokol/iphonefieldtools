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
//  SubjectDistanceRangePolicyFactory.m
//  FieldTools
//
//  Created by Brad Sokol on 11-08-31.
//  Copyright 2011 by Brad Sokol. All rights reserved.
//

#import "SubjectDistanceRangePolicyFactory.h"

#import "MetricMacroSubjectDistanceRangePolicy.h"
#import "UserDefaults.h"

SubjectDistanceRangePolicyFactory* theInstance;

@interface SubjectDistanceRangePolicyFactory ()

- (id)init;

@end

@implementation SubjectDistanceRangePolicyFactory

- (id)init
{
    if ((self = [super init]) == nil) 
	{
		return nil;
    }
    
	// Initialization code
    
	return self;
}

+ (SubjectDistanceRangePolicyFactory*) sharedPolicyFactory
{
    if (nil == theInstance)
    {
        theInstance = [[SubjectDistanceRangePolicyFactory alloc] init];
    }
    
    return theInstance;
}

-(id<SubjectDistanceRangePolicy>) policyForIndex:(int)index
{
    id<SubjectDistanceRangePolicy> policy = nil;
    
    int distanceUnitsType = [[NSUserDefaults standardUserDefaults] integerForKey:FTDistanceUnitsKey];
    bool metric = distanceUnitsType == DistanceUnitsCentimeters ||
        distanceUnitsType == DistanceUnitsMeters;
    
    policy = [[[MetricMacroSubjectDistanceRangePolicy alloc] init] autorelease];
    
    return policy;
}

@end
