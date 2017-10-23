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

#import "Camera.h"
#import "Lens.h"

#import "UserDefaults.h"

@interface CameraBag ()

@property(nonatomic, strong) NSString* archivePath;
@property(nonatomic, strong) NSMutableArray* cameras;
@property(nonatomic, strong) NSMutableArray* lenses;

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
	if ((self = [self init]) == nil)
    {
        return nil;
    }
	
	[self setCameras:[decoder decodeObjectForKey:@"Cameras"]];
	[self setLenses:[decoder decodeObjectForKey:@"Lenses"] ];

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

- (NSInteger)cameraCount
{
	return [cameras count];
}

- (void)deleteCamera:(Camera*)camera
{
	int id = [camera identifier];
	NSInteger cameraCount = [cameras count];
	
	// Safety check - never delete the last camera
	if (cameraCount == 1)
	{
		DLog(@"Can't delete the last camera in Camera:delete");
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

- (Camera*)findCameraForIndex:(NSInteger)index
{
	NSInteger cameraCount = [cameras count];
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

- (void)moveCameraFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
	const NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	NSInteger newSelectedIndex = selectedIndex;

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

		for (NSInteger i = fromIndex; i < toIndex; ++i)
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
		
		for (NSInteger i = fromIndex; i > toIndex; --i)
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
		DLog(@"Attempt to delete nil lens");
		return;
	}
	
	int id = [lens identifier];
	NSInteger lensCount = [lenses count];
	
	// Safety check - never delete the last lens
	if (lensCount == 1)
	{
		DLog(@"Can't delete the last lens in Lens:delete");
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

- (Lens*)findLensForIndex:(NSInteger)index
{
	if (index >= [lenses count])
	{
		return nil;
	}
	
	return [lenses objectAtIndex:index];
}

- (void)moveLensFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
	const NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	NSInteger newSelectedIndex = selectedIndex;
	
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
		
		for (NSInteger i = fromIndex; i < toIndex; ++i)
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
		
		for (NSInteger i = fromIndex; i > toIndex; --i)
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

- (NSInteger)lensCount
{
	return [lenses count];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"CameraBag with %lu cameras and %lu lenses",
            (unsigned long)[cameras count], (unsigned long)[lenses count]];
}

- (void)save
{
	NSAssert([self archivePath] != nil && [[self archivePath] length] > 0, @"No archive path set for camera bag");
	
	[NSKeyedArchiver archiveRootObject:self
								toFile:[self archivePath]];
}

@end
