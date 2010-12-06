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
//  CameraBag.m
//  FieldTools
//
//  Created by Brad on 2010/12/04.
//  Copyright 2010 Brad Sokol. All rights reserved.
//

#import "CameraBag.h"

static CameraBag* defaultCameraBag = nil;

@implementation CameraBag

- (id)init
{
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	cameras = [[NSMutableArray alloc] init];
	lenses = [[NSMutableArray alloc] init];
	
	return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	[self init];
	
	cameras = [decoder decodeObjectForKey:@"Cameras"];
	lenses = [decoder decodeObjectForKey:@"Lenses"];

	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:cameras forKey:@"Cameras"];
	[coder encodeObject:lenses forKey:@"Lenses"];
}

+ (CameraBag*)default
{
	if (nil == defaultCameraBag)
	{
		defaultCameraBag = [[CameraBag alloc] init];
	}
	
	return defaultCameraBag;
}

- (void)addCamera:(Camera*)camera
{
	[cameras addObject:camera];
}

- (void)addLens:(Lens*)lens
{
	[lenses addObject:lens];
}

- (void)dealloc
{
	[cameras release];
	cameras = nil;
	[lenses release];
	lenses = nil;
	
	[super dealloc];
}

@end
