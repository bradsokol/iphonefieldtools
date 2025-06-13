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

//
//  SubjectDistanceRangePolicyFactory.h
//  FieldTools
//
//  Created by Brad Sokol on 11-08-31.
//  Copyright 2011 by Brad Sokol
//

#import <Foundation/Foundation.h>

#import "SubjectDistanceRangePolicy.h"

typedef enum
{
    SubjectDistanceRangeMacro,
    SubjectDistanceRangeClose,
    SubjectDistanceRangeMid,
    SubjectDistanceRangeFar
} SubjectDistanceRange;

@interface SubjectDistanceRangePolicyFactory : NSObject 
{
    
}

+ (SubjectDistanceRangePolicyFactory*) sharedPolicyFactory;

- (NSUInteger)policyCount;
-(SubjectDistanceRangePolicy*) policyForSubjectDistanceRange:(SubjectDistanceRange)subjectDistanceRange;

@end
