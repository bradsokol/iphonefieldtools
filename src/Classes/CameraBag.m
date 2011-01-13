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
@property(nonatomic, retain, readonly) NSMutableArray* cameras;
@property(nonatomic, retain, readonly) NSMutableArray* lenses;

@end

@implementation CameraBag

@synthesize archivePath;
@synthesize cameras;
@synthesize lenses;

static CameraBag* sharedCameraBag = nil;

+ (id)initSharedCameraBagFromArchive:(NSString*)archiveFile
{
	@synchronized(self)
	{
		if (sharedCameraBag == nil)
		{
			sharedCameraBag = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveFile];
			[sharedCameraBag setArchivePath:archiveFile];
			
			int identifier = 0;
			for (Camera* camera in [sharedCameraBag cameras])
			{
				[camera setIdentifier:identifier++];
			}
			
			identifier = 0;
			for (Lens* lens in [sharedCameraBag lenses])
			{
				[lens setIdentifier:identifier++];
			}
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
	const int selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	int newSelectedIndex = selectedIndex;

	if (fromIndex == selectedIndex)
	{
		// Moving selected camera
		newSelectedIndex = toIndex;
	}
	
	if (fromIndex < toIndex)
	{
		// Moving camera down the list
		if (selectedIndex > fromIndex && selectedIndex <= toIndex)
		{
			// Selected moves one up
			newSelectedIndex = selectedIndex - 1;
		}
		
		for (int i = fromIndex; i < toIndex; ++i)
		{
			[cameras exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
		}
	}
	else
	{
		// Moving camera up the list
		if (selectedIndex >= toIndex && selectedIndex < fromIndex)
		{
			// Selected moves one down
			newSelectedIndex = selectedIndex + 1;
		}
		
		for (int i = fromIndex; i > toIndex; --i)
		{
			[cameras exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
		}
	}
	
	for (int i = 0; i < [self cameraCount]; ++i)
	{
		Camera* camera = [self findCameraForIndex:i];
		[camera setIdentifier:i];
	}

	[[NSUserDefaults standardUserDefaults] setInteger:newSelectedIndex
											   forKey:FTCameraIndex];
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
	const int selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	int newSelectedIndex = selectedIndex;
	
	if (fromIndex == selectedIndex)
	{
		// Moving selected lens
		newSelectedIndex = toIndex;
	}
	
	if (fromIndex < toIndex)
	{
		// Moving lens down the list
		if (selectedIndex > fromIndex && selectedIndex <= toIndex)
		{
			// Selected moves one up
			newSelectedIndex = selectedIndex - 1;
		}
		
		for (int i = fromIndex; i < toIndex; ++i)
		{
			[lenses exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
		}
	}
	else
	{
		// Moving lens up the list
		if (selectedIndex >= toIndex && selectedIndex < fromIndex)
		{
			// Selected moves one down
			newSelectedIndex = selectedIndex + 1;
		}
		
		for (int i = fromIndex; i > toIndex; --i)
		{
			[lenses exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
		}
	}
	
	for (int i = 0; i < [self lensCount]; ++i)
	{
		Lens* lens = [self findLensForIndex:i];
		[lens setIdentifier:i];
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger:newSelectedIndex
											   forKey:FTLensIndex];
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
