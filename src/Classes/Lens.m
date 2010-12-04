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
//  Lens.m
//  FieldTools
//
//  Created by Brad on 2009/08/27.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "Lens.h"

#import "UserDefaults.h"

static NSString* LensKeyFormat = @"Lens%d";
static NSString* LensNameKey = @"Name";
static NSString* MaximumApertureKey = @"MaximumAperture";
static NSString* MinimumApertureKey = @"MinimumAperture";
static NSString* MaximumFocalLengthKey = @"MaximumFocalLength";
static NSString* MinimumFocalLengthKey = @"MinimumFocalLength";

static NSString* KeyDescription = @"LensDescription";
static NSString* KeyMinimumAperture = @"LensMinimumAperture";
static NSString* KeyMaximumAperture = @"LensMaximumAperture";
static NSString* KeyMinimumFocalLength = @"LensMinimumFocalLength";
static NSString* KeyMaximumFocalLength = @"LensMaximumFocalLength";

@implementation Lens

@synthesize description;
@synthesize identifier;
@synthesize maximumAperture;
@synthesize minimumAperture;
@synthesize maximumFocalLength;
@synthesize minimumFocalLength;

- (id)initWithCoder:(NSCoder*)decoder
{
	description = [[decoder decodeObjectForKey:KeyDescription] retain];
	minimumAperture = [NSNumber numberWithFloat:[decoder decodeFloatForKey:KeyMinimumAperture]];
	maximumAperture = [NSNumber numberWithFloat:[decoder decodeFloatForKey:KeyMaximumAperture]];
	minimumFocalLength = [NSNumber numberWithFloat:[decoder decodeFloatForKey:KeyMinimumFocalLength]];
	maximumFocalLength = [NSNumber numberWithFloat:[decoder decodeFloatForKey:KeyMaximumFocalLength]];

	return self;
}

// The designated initializer
- (id)initWithDescription:(NSString*)aDescription 
		  minimumAperture:(NSNumber*)aMinimumAperture
		  maximumAperture:(NSNumber*)aMaximumAperture
	   minimumFocalLength:(NSNumber*)aMinimumFocalLength
	   maximumFocalLength:(NSNumber*)aMaximumFocalLength
			   identifier:(int)anIdentifier
{
	self = [super init];
	if (nil == self)
	{
		return nil;
	}
	
	[self setIdentifier:anIdentifier];
	[self setDescription:aDescription];
	
	// Minimum aperture is larger values, maximum is smaller
	if ([aMinimumAperture compare:aMaximumAperture] == NSOrderedAscending)
	{
		// Inverse from what the caller gave us
		[self setMinimumAperture:aMaximumAperture];
		[self setMaximumAperture:aMinimumAperture];
	}
	else
	{
		[self setMinimumAperture:aMinimumAperture];
		[self setMaximumAperture:aMaximumAperture];
	}
	if ([aMinimumFocalLength compare:aMaximumFocalLength] == NSOrderedDescending)
	{
		// Revers what the user gave us
		[self setMinimumFocalLength:aMaximumFocalLength];
		[self setMaximumFocalLength:aMinimumFocalLength];
	}
	else
	{
		[self setMinimumFocalLength:aMinimumFocalLength];
		[self setMaximumFocalLength:aMaximumFocalLength];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	id result = [[[self class] allocWithZone:zone] initWithDescription:[self description]
													   minimumAperture:[self minimumAperture]
													   maximumAperture:[self maximumAperture]
													minimumFocalLength:[self minimumFocalLength]
													maximumFocalLength:[self maximumFocalLength]
															identifier:[self identifier]];
	return result;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:description forKey:KeyDescription];
	[coder encodeFloat:[minimumAperture floatValue] forKey:KeyMinimumAperture];
	[coder encodeFloat:[maximumAperture floatValue] forKey:KeyMaximumAperture];
	[coder encodeFloat:[minimumFocalLength floatValue] forKey:KeyMinimumFocalLength];
	[coder encodeFloat:[maximumFocalLength floatValue] forKey:KeyMaximumFocalLength];
}

- (void)save
{
	NSUserDefaults* defaultValues = [NSUserDefaults standardUserDefaults];
	[defaultValues setObject:[self asDictionary]
					  forKey:[NSString stringWithFormat:LensKeyFormat, [self identifier]]];
	
	int lensCount = [Lens count];
	if ([self identifier] > lensCount - 1)
	{
		// This is a new lens
		[[NSUserDefaults standardUserDefaults] setInteger:lensCount + 1
												   forKey:FTLensCount];
	}
}

+ (void)delete:(Lens*)lens
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	int id = [lens identifier];
	int lensCount = [Lens count];
	
	// Safety check - never delete the last lens
	if (lensCount == 1)
	{
		NSLog(@"Can't delete the last lens in Lens:delete");
		return;
	}
	
	// Delete lens in prefs higher than this one. 
	while (id < lensCount - 1)
	{
		lens = [Lens findFromDefaultsForIndex:id + 1];
		[defaults setObject:[lens asDictionary] 
					 forKey:[NSString stringWithFormat:LensKeyFormat, [lens identifier] - 1]];
		
		++id;
	}
	
	// Delete the last lens
	--lensCount;
	[defaults removeObjectForKey:[NSString stringWithFormat:LensKeyFormat, id]];
	[defaults setInteger:lensCount forKey:FTLensCount];
}

+ (Lens*)findSelectedInDefaults
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	return [Lens findFromDefaultsForIndex:index];
}

+ (Lens*)findFromDefaultsForIndex:(int)index
{
	int lensCount = [Lens count];
	if (index >= lensCount)
	{
		return nil;
	}
	
	NSString* key = [NSString stringWithFormat:LensKeyFormat, index];
	NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	
	Lens* lens = [[[Lens alloc] initWithDescription:[dict objectForKey:LensNameKey]
									minimumAperture:(NSNumber*)[dict objectForKey:MinimumApertureKey]
									maximumAperture:(NSNumber*)[dict objectForKey:MaximumApertureKey]
								 minimumFocalLength:(NSNumber*)[dict objectForKey:MinimumFocalLengthKey]
								 maximumFocalLength:(NSNumber*)[dict objectForKey:MaximumFocalLengthKey]
										 identifier:index] autorelease];
	
	return lens;
}

+ (void)moveFromIndex:(int)fromIndex toIndex:(int)toIndex
{
	Lens* theLens = [Lens findFromDefaultsForIndex:fromIndex];
	[theLens setIdentifier:toIndex];
	int selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
	
	if (fromIndex < toIndex)
	{
		// Moving lens down the list
		for (int i = fromIndex + 1; i <= toIndex; ++i)
		{
			Lens* lens = [Lens findFromDefaultsForIndex:i];
			[lens setIdentifier:i - 1];
			[lens save];
		}
		
		// Adjust the index of the selected lens if necessary
		if (selectedIndex >= fromIndex && selectedIndex <= toIndex)
		{
			if (--selectedIndex < 0)
			{
				selectedIndex = [Lens count] - 1;
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
			Lens* lens = [Lens findFromDefaultsForIndex:i];
			[lens setIdentifier:i + 1];
			[lens save];
		}
		
		// Adjust the index of the selected lens if necessary
		if (selectedIndex >= toIndex && selectedIndex <= fromIndex)
		{
			if (++selectedIndex == [Lens count])
			{
				selectedIndex = 0;
			}
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
													   forKey:FTLensIndex];
		}
	}
	[theLens save];
}

+ (int)count
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:FTLensCount];
}

- (bool)isZoom
{
	return [[self minimumFocalLength] compare:[self maximumFocalLength]] == NSOrderedAscending;
}

- (NSDictionary*)asDictionary
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
	[dict setObject:[self description]
			 forKey:LensNameKey];
	[dict setObject:[self maximumAperture]
			 forKey:MaximumApertureKey];
	[dict setObject:[self minimumAperture]
			 forKey:MinimumApertureKey];
	[dict setObject:[self maximumFocalLength]
			 forKey:MaximumFocalLengthKey];
	[dict setObject:[self minimumFocalLength]
			 forKey:MinimumFocalLengthKey];
	
	return dict;
}

- (void)dealloc
{
	[self setDescription:nil];
	
	[super dealloc];
}

@end
