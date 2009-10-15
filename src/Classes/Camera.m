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

@implementation Camera

@synthesize coc;
@synthesize description;
@synthesize identifier;

- (id)initWithDescription:(NSString*)aDescription coc:(CoC*)aCoc identifier:(int)anIdentifier
{
	if ([super init] == nil)
	{
		return nil;
	}

	description = aDescription;
	[description retain];
	
	coc = aCoc;
	[coc retain];
	identifier = anIdentifier;
	
	NSLog(@"Camera init: %@ coc:%f (%@)", self.description, self.coc.value, self.coc.description);
	
	return self;
}

+ (Camera*)findSelectedInDefaults
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	return [Camera findFromDefaultsForIndex:index];
}

+ (Camera*)findFromDefaultsForIndex:(int)index
{
	int cameraCount = [Camera count];
	if (index >= cameraCount)
	{
		return nil;
	}
	
	NSString* key = [NSString stringWithFormat:CameraKeyFormat, index];
	NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	
	NSString* description = (NSString*) [dict objectForKey:CameraCoCKey];
	CoC* coc = [[CoC alloc] initWithValue:[[CoC findFromPresets:description] value]
							  description:description];
	Camera* camera = [[[Camera alloc] initWithDescription:[dict objectForKey:CameraNameKey]																		
													 coc:coc
											  identifier:index] autorelease];	
	[coc release];
	
	return camera;
}

+ (NSArray*)findAll
{
	int cameraCount = [Camera count];
	NSMutableArray* cameras = [[[NSMutableArray alloc] initWithCapacity:cameraCount] autorelease];
	for (int i = 0; i < cameraCount; ++i)
	{
		Camera* camera = [Camera findFromDefaultsForIndex:i];
		[cameras addObject:camera];
	}
		
	return cameras;
}

+ (void)moveFromIndex:(int)fromIndex toIndex:(int)toIndex
{
	Camera* theCamera = [Camera findFromDefaultsForIndex:fromIndex];
	[theCamera setIdentifier:toIndex];
	int selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	
	if (fromIndex < toIndex)
	{
		// Moving camera down the list
		for (int i = fromIndex + 1; i <= toIndex; ++i)
		{
			Camera* camera = [Camera findFromDefaultsForIndex:i];
			[camera setIdentifier:i - 1];
			[camera save];
		}

		// Adjust the index of the selected camera if necessary
		if (selectedIndex >= fromIndex && selectedIndex <= toIndex)
		{
			if (--selectedIndex < 0)
			{
				selectedIndex = [Camera count] - 1;
			}
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
													   forKey:FTCameraIndex];
		}
	}
	else
	{
		// Moving camera up the list
		for (int i = fromIndex - 1; i >= toIndex; --i)
		{
			Camera* camera = [Camera findFromDefaultsForIndex:i];
			[camera setIdentifier:i + 1];
			[camera save];
		}
		
		// Adjust the index of the selected camera if necessary
		if (selectedIndex >= toIndex && selectedIndex <= fromIndex)
		{
			if (++selectedIndex == [Camera count])
			{
				selectedIndex = 0;
			}
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
													   forKey:FTCameraIndex];
		}
	}
	[theCamera save];
}

- (void)save
{
	NSUserDefaults* defaultValues = [NSUserDefaults standardUserDefaults];
	[defaultValues setObject:[self asDictionary]
					  forKey:[NSString stringWithFormat:CameraKeyFormat, [self identifier]]];
	
	int cameraCount = [Camera count];
	if ([self identifier] > cameraCount - 1)
	{
		// This is a new camera
		[[NSUserDefaults standardUserDefaults] setInteger:cameraCount + 1
												   forKey:FTCameraCount];
	}
}

+ (int)count
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraCount];
}

+ (void)delete:(Camera*)camera
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	int id = [camera identifier];
	int cameraCount = [Camera count];
	
	// Safety check - never delete the last camera
	if (cameraCount == 1)
	{
		NSLog(@"Can't delete the last camera in Camera:delete");
		return;
	}
	
	// Delete cameras in prefs higher than this one. 
	while (id < cameraCount - 1)
	{
		camera = [Camera findFromDefaultsForIndex:id + 1];
		[defaults setObject:[camera asDictionary] forKey:[NSString stringWithFormat:CameraKeyFormat, [camera identifier] - 1]];
		
		++id;
	}
	
	// Delete the last camera
	--cameraCount;
	[defaults removeObjectForKey:[NSString stringWithFormat:CameraKeyFormat, id]];
	[defaults setInteger:cameraCount forKey:FTCameraCount];
}

- (NSDictionary*)asDictionary
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:2];
	[dict setObject:[self description]
			forKey:CameraNameKey];
	[dict setObject:[coc description]
			 forKey:CameraCoCKey];
	
	return dict;
}

- (void)dealloc
{
	[coc release];
	[description release];
	
	[super dealloc];
}

@end
