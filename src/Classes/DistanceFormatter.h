// Copyright 2009 Brad Sokol
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
//  DistanceFormatter.h
//  FieldTools
//
// Note that this provides only a partial implementation of NSFormatter.
// Only the stringForObjectValue method is overridden. Calling either
// getObjectValue:forString:errorDescription: or 
// attributedStringForObjectValue:withDefaultAttributes: will cause default
// behaviour (raise an exception and return nil, respectively).
//
//  Created by Brad on 2009/03/25.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserDefaults.h"

@interface DistanceFormatter : NSFormatter 
{
	BOOL testing;
	
	// For testing only
	DistanceUnits distanceUnits;
}

- (id)init;
- (id)initForTest:(BOOL)test;

@property(nonatomic) DistanceUnits distanceUnits;

@end
