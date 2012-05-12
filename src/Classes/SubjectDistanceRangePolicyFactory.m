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

#import "CloseSubjectDistanceRangePolicy.h"
#import "FarSubjectDistanceRangePolicy.h"
#import "MacroSubjectDistanceRangePolicy.h"
#import "MidSubjectDistanceRangePolicy.h"

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
    @synchronized(self)
    {
        if (nil == theInstance)
        {
            theInstance = [[SubjectDistanceRangePolicyFactory alloc] init];
        }
    }
    
    return theInstance;
}

- (NSUInteger)policyCount
{
    return SubjectDistanceRangeFar + 1;
}

-(SubjectDistanceRangePolicy*) policyForSubjectDistanceRange:(SubjectDistanceRange)subjectDistanceRange
{
    SubjectDistanceRangePolicy* policy = nil;
    
    switch (subjectDistanceRange)
    {
        case SubjectDistanceRangeMacro:
            policy = [[[MacroSubjectDistanceRangePolicy alloc] init] autorelease];
            break;

        case SubjectDistanceRangeClose:
            policy = [[[CloseSubjectDistanceRangePolicy alloc] init] autorelease];
            break;
            
        case SubjectDistanceRangeMid:
            policy = [[[MidSubjectDistanceRangePolicy alloc] init] autorelease];
            break;
            
        case SubjectDistanceRangeFar:
        default:
            policy = [[[FarSubjectDistanceRangePolicy alloc] init] autorelease];
            break;
    }
    
    return policy;
}

@end
