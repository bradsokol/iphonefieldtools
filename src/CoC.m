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
//  CoC.m
//  FieldTools
//
//  Created by Brad on 2009/08/25.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "CoC.h"

static NSDictionary* cocPresets;

@implementation CoC

@synthesize description;
@synthesize value;

// Designated initializer
- (id)initWithValue:(float)aValue description:(NSString*)aDescription
{
	if (nil == [super init])
	{
		return nil;
	}
	
	value = aValue;
	description = aDescription;
	[description retain];
	
	return self;
}

+ (NSDictionary*)cocPresets
{
	if (nil == cocPresets)
	{
		NSString* path = [[NSBundle mainBundle] pathForResource:@"CoC" ofType:@"plist"];
		cocPresets = [NSDictionary dictionaryWithContentsOfFile:path];
		[cocPresets retain];
		for (NSString* key in cocPresets)
		{
			NSLog(@"%@ %@", key, [cocPresets objectForKey:key]);
		}
	}
	
	return cocPresets;
}

+ (CoC*)findFromPresets:(NSString*)cocDescription
{
	if (nil == cocDescription || [cocDescription length] == 0 || [[CoC cocPresets] objectForKey:cocDescription] == nil)
	{
		return nil;
	}
	
	float value = [[cocPresets objectForKey:cocDescription] floatValue];
	return [[CoC alloc] initWithValue:value description:cocDescription];
}

- (void)dealloc
{
	[description release];
	
	[super dealloc];
}

@end
