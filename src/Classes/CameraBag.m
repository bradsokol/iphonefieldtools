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

#import "Lens.h"

#import "UserDefaults.h"

@interface CameraBag ()

@property(nonatomic, retain) NSString* archivePath;

@end

@implementation CameraBag

@synthesize archivePath;

static CameraBag* sharedCameraBag = nil;

+ (id)initSharedCameraBagFromArchive:(NSString*)archiveFile
{
	@synchronized(self)
	{
		if (sharedCameraBag == nil)
		{
			sharedCameraBag = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveFile];
			[sharedCameraBag setArchivePath:archiveFile];
		}
	}
	
	return sharedCameraBag;
}

+ (CameraBag*)sharedCameraBag
{
	@synchronized(self)
	{
		if (sharedCameraBag == nil)
		{ 
			sharedCameraBag = [[CameraBag alloc] init];
		} 
	} 
	
	return sharedCameraBag; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
	return self; 
} 

- (id)retain 
{ 
	return self; 
} 

- (NSUInteger)retainCount 
{ 
	return NSUIntegerMax; 
} 

- (void)release 
{ 
} 

- (id)autorelease 
{ 
	return self; 
}

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
	
	// TODO: Leak
	cameras = [[decoder decodeObjectForKey:@"Cameras"] retain];
	lenses = [[decoder decodeObjectForKey:@"Lenses"] retain];

	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:cameras forKey:@"Cameras"];
	[coder encodeObject:lenses forKey:@"Lenses"];
}

#pragma mark Cameras

- (void)addCamera:(Camera*)camera
{
	[cameras addObject:camera];
}

- (int)cameraCount
{
	return [cameras count];
}

- (void)deleteCamera:(Camera*)camera
{
	int id = [camera identifier];
	int cameraCount = [cameras count];
	
	// Safety check - never delete the last camera
	if (cameraCount == 1)
	{
		NSLog(@"Can't delete the last camera in Camera:delete");
		return;
	}

	[cameras removeObjectAtIndex:[camera identifier]];
	while (id < cameraCount - 1)
	{
		camera = [cameras objectAtIndex:id];
		[camera setIdentifier:id];
		
		++id;
	}
}

- (Camera*)findCameraForIndex:(int)index
{
	int cameraCount = [cameras count];
	if (index >= cameraCount)
	{
		return nil;
	}
	
	return [cameras objectAtIndex:index];
}

- (Camera*)findSelectedCamera
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	return [cameras objectAtIndex:index];
}

- (void)moveCameraFromIndex:(int)fromIndex toIndex:(int)toIndex
{
	Camera* theCamera = [cameras objectAtIndex:fromIndex];
	[theCamera setIdentifier:toIndex];
	int selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	
	if (fromIndex < toIndex)
	{
		// Moving camera down the list
		for (int i = fromIndex + 1; i <= toIndex; ++i)
		{
			Camera* camera = [cameras objectAtIndex:i];
			[camera setIdentifier:i - 1];
		}
		
		// Adjust the index of the selected camera if necessary
		if (selectedIndex >= fromIndex && selectedIndex <= toIndex)
		{
			if (--selectedIndex < 0)
			{
				selectedIndex = [cameras count] - 1;
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
			Camera* camera = [cameras objectAtIndex:i];
			[camera setIdentifier:i + 1];
		}
		
		// Adjust the index of the selected camera if necessary
		if (selectedIndex >= toIndex && selectedIndex <= fromIndex)
		{
			if (++selectedIndex == [cameras count])
			{
				selectedIndex = 0;
			}
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
													   forKey:FTCameraIndex];
		}
	}
}

#pragma mark Lenses

- (void)addLens:(Lens*)lens
{
	[lenses addObject:lens];
}

- (void)deleteLens:(Lens*)lens
{
	if (nil == lens)
	{
		NSLog(@"Attempt to delete nil lens");
		return;
	}
	
	int id = [lens identifier];
	int lensCount = [lenses count];
	
	// Safety check - never delete the last lens
	if (lensCount == 1)
	{
		NSLog(@"Can't delete the last lens in Lens:delete");
		return;
	}

	[lenses removeObjectAtIndex:id];
	while (id < lensCount - 1)
	{
		lens = [lenses objectAtIndex:id];
		[lens setIdentifier:id];
		
		++id;
	}
}

- (Lens*)findSelectedLens
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	return [lenses objectAtIndex:index];
}

- (Lens*)findLensForIndex:(int)index
{
	if (index >= [lenses count])
	{
		return nil;
	}
	
	return [lenses objectAtIndex:index];
}

- (void)moveLensFromIndex:(int)fromIndex toIndex:(int)toIndex
{
	Lens* theLens = [lenses objectAtIndex:fromIndex];
	[theLens setIdentifier:toIndex];
	int selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	
	if (fromIndex < toIndex)
	{
		// Moving lens down the list
		for (int i = fromIndex + 1; i <= toIndex; ++i)
		{
			Lens* lens = [lenses objectAtIndex:i];
			[lens setIdentifier:i - 1];
		}
		
		// Adjust the index of the selected lens if necessary
		if (selectedIndex >= fromIndex && selectedIndex <= toIndex)
		{
			if (--selectedIndex < 0)
			{
				selectedIndex = [lenses count] - 1;
			}
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
													   forKey:FTLensIndex];
		}
	}
	else
	{
		// Moving lens up the list
		for (int i = fromIndex - 1; i >= toIndex; --i)
		{
			Lens* lens = [lenses objectAtIndex:i];
			[lens setIdentifier:i + 1];
		}
		
		// Adjust the index of the selected lens if necessary
		if (selectedIndex >= toIndex && selectedIndex <= fromIndex)
		{
			if (++selectedIndex == [lenses count])
			{
				selectedIndex = 0;
			}
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
													   forKey:FTLensIndex];
		}
	}
}

- (int)lensCount
{
	return [lenses count];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"CameraBag with %d cameras and %d lenses",
			[cameras count], [lenses count]];
}

- (void)save
{
	NSAssert([self archivePath] != nil && [[self archivePath] length] > 0, @"No archive path set for camera bag");
	
	[NSKeyedArchiver archiveRootObject:self
								toFile:[self archivePath]];
}

- (void)dealloc
{
	[cameras release];
	cameras = nil;
	[lenses release];
	lenses = nil;
	[archivePath release];
	archivePath = nil;
	
	[super dealloc];
}

@end
