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
//  Camera.m
//  FieldTools
//
//  Created by Brad on 2009/01/21.
//

#import "Camera.h"

#import "CoC.h"
#import "UserDefaults.h"

static NSString* CameraKeyFormat = @"Camera%d";
static NSString* CameraCoCKey = @"CoC";
static NSString* CameraNameKey = @"Name";

static NSString* KeyDescription = @"CameraDescription";
static NSString* KeyCoc = @"CameraCoC";

@implementation Camera

@synthesize coc;
@synthesize description;
@synthesize identifier;

- (id)initWithCoder:(NSCoder*)decoder
{
	description = [decoder decodeObjectForKey:KeyDescription];
	coc = [decoder decodeObjectForKey:KeyCoc];
	
	return self;
}

// The designated initializer
- (id)initWithDescription:(NSString*)aDescription coc:(CoC*)aCoc identifier:(int)anIdentifier
{
	self = [super init];
	if (nil == self)
	{
		return nil;
	}

	[self setDescription:aDescription];
	[self setCoc:aCoc];
	[self setIdentifier:anIdentifier];
	
	DLog(@"Camera init: %@ coc:%f (%@)", self.description, self.coc.value, self.coc.description);
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:description forKey:KeyDescription];
	[coder encodeObject:coc forKey:KeyCoc];
}

- (id)copyWithZone:(NSZone *)zone
{
	id result = [[[self class] allocWithZone:zone] initWithDescription:[self description]
																   coc:[[self coc] copy]
															identifier:[self identifier]];
	
	return result;
}

+ (Camera*)findFromDefaultsForIndex_deprecated:(int)index
{
	NSInteger cameraCount = [Camera count_deprecated];
	if (index >= cameraCount)
	{
		return nil;
	}
	
	NSString* key = [NSString stringWithFormat:CameraKeyFormat, index];
	NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	
	NSString* customLabel = NSLocalizedString(@"CUSTOM_COC_DESCRIPTION", "CUSTOM");
	NSString* description = (NSString*) [dict objectForKey:CameraCoCKey];
	CoC* coc = nil;
	if ([description length] > [customLabel length] &&
		[description compare:customLabel
					 options:NSLiteralSearch
					   range:NSMakeRange(0, [customLabel length])] == NSOrderedSame)
	{
		NSString* valueAsString = [description substringFromIndex:[customLabel length]];
		float value = [valueAsString floatValue];
		coc = [[CoC alloc] initWithValue:value
							 description:customLabel];
	}
	else
	{
		coc = [[CoC alloc] initWithValue:[[CoC findFromPresets:description] value]
							 description:description];
	}
	Camera* camera = [[Camera alloc] initWithDescription:[dict objectForKey:CameraNameKey]																		
													 coc:coc
											  identifier:index];	
	
	return camera;
}

+ (NSArray*)findAll
{
	NSInteger cameraCount = [Camera count_deprecated];
	NSMutableArray* cameras = [[NSMutableArray alloc] initWithCapacity:cameraCount];
	for (int i = 0; i < cameraCount; ++i)
	{
		Camera* camera = [Camera findFromDefaultsForIndex_deprecated:i];
		[cameras addObject:camera];
	}
		
	return cameras;
}

- (void)save_deprecated
{
	NSUserDefaults* defaultValues = [NSUserDefaults standardUserDefaults];
	[defaultValues setObject:[self asDictionary_deprecated]
					  forKey:[NSString stringWithFormat:CameraKeyFormat, [self identifier]]];
	
	NSInteger cameraCount = [Camera count_deprecated];
	if ([self identifier] > cameraCount - 1)
	{
		// This is a new camera
		[[NSUserDefaults standardUserDefaults] setInteger:cameraCount + 1
												   forKey:FTCameraCount];
	}
	
	DLog(@"Camera save: %@ coc:%f (%@)", self.description, self.coc.value, self.coc.description);
}

+ (NSInteger)count_deprecated
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraCount];
}

- (NSDictionary*)asDictionary_deprecated
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:2];
	[dict setObject:[self description]
			forKey:CameraNameKey];
	
	if ([[coc description] compare:NSLocalizedString(@"CUSTOM_COC_DESCRIPTION", "CUSTOM")] == NSOrderedSame)
	{
		[dict setObject:[NSString stringWithFormat:@"%@%.3f", [coc description], [coc value]]
				 forKey:CameraCoCKey];
	}
	else
	{
		[dict setObject:[coc description]
				 forKey:CameraCoCKey];
	}
	
	return dict;
}


@end
