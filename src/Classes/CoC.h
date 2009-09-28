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
//  CoC.h
//  FieldTools
//
//  Created by Brad on 2009/08/25.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoC : NSObject 
{
	float value;
	NSString* description;
}

- (id)initWithValue:(float)value description:(NSString*)description;

+ (NSDictionary*)cocPresets;
+ (CoC*)findFromPresets:(NSString*)cocDescription;

@property (readonly, retain, nonatomic) NSString* description;
@property (readonly, assign) float value;

@end
