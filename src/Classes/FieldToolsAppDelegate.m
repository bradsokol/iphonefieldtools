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
//  FieldToolsAppDelegate.m
//  FieldTools
//
//  Created by Brad on 2008/11/29.
//

#import "FieldToolsAppDelegate.h"

#import "Camera.h"
#import "Coc.h"
#import "RootViewController.h"

#import "UserDefaults.h"

// Keys for user defaults
NSString* const FTDefaultsVersion = @"DefaultsVersion";

NSString* const FTApertureIndex = @"ApertureIndex";
NSString* const FTCameraCount = @"CameraCount";
NSString* const FTCameraIndex = @"CameraIndex";
NSString* const FTDistanceTypeKey = @"DistanceType";
NSString* const FTFocalLengthKey = @"FocalLength";
NSString* const FTMetricKey = @"Metric";
NSString* const FTSubjectDistanceKey = @"SubjectDistance";

NSString* const FTMigratedFrom10Key = @"MigratedFrom10";

// Keys for user defaults (future functionality)
/*
 NSString* const FTCameraDescriptionRoot = @"CameraDescription";
 NSString* const FTCameraCoCRoot = @"CameraCoc";
NSString* const FTFStopKey = @"FStop";
NSString* const FTCoCKey = @"CoC";
NSString* const FTMinimumFStopKey = @"MinimumFStop";
NSString* const FTMaximumFStopKey = @"MaximumFStop";
NSString* const FTMinimumFocalLengthKey = @"MinimumFocalLength";
NSString* const FTMaximumFocalLengthKey = @"MaximumFocalLength";
*/

// Defaults for preferences
int DefaultApertureIndex = 18;
NSString* const DefaultCoC = @"Nikon DX";
int DefaultDistanceType = 0; // Hyperfocal
float DefaultFocalLength = 24.0f;
bool DefaultMetric = NO;
float DefaultSubjectDistance = 2.5f;

// Defaults for preferences (future functionality)
/*
float DefaultFStop = 8.0;
float DefaultMaximumFStop = 2.8;
float DefaultMinimumFStop = 32.0;
float DefaultMinimumFocalLength = 10.0;
float DefaultMaximumFocalLength = 100.0;
 */

@interface FieldToolsAppDelegate (Private)

+ (void)migrateDefaults:(NSMutableDictionary*)defaultValues;
+ (void)setupDefaultValues;

@end

@implementation FieldToolsAppDelegate

@synthesize window;
@synthesize rootViewController;

+ (void)initialize
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], FTMigratedFrom10Key, nil]];

	[FieldToolsAppDelegate setupDefaultValues];

	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FTMigratedFrom10Key];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}

+ (void)setupDefaultValues
{
	bool migratedFrom10 = [[NSUserDefaults standardUserDefaults] boolForKey:FTMigratedFrom10Key];
	NSLog(@"Previously migrated from 1.0: %s", migratedFrom10 ? "YES" : "NO");

	NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
	
	if (!migratedFrom10)
	{
		NSLog(@"Migrating defaults");
		[FieldToolsAppDelegate migrateDefaults:defaultValues];
	}
	else if ([Camera count] == 0)
	{
		CoC* coc = [CoC findFromPresets:DefaultCoC];
		Camera* camera = [[Camera alloc] initWithDescription:NSLocalizedString(@"DEFAULT_CAMERA_NAME", "Default camera")
														 coc:coc
												  identifier:0];
		[camera save];
	}
	
	[defaultValues setObject:[NSNumber numberWithInt:1]
					  forKey:FTCameraCount];
	[defaultValues setObject:[NSNumber numberWithInt:0]
					  forKey:FTCameraIndex];
	
	// Setup initial values for preferences
	
	[defaultValues setObject:[NSNumber numberWithFloat:DefaultFocalLength]
					  forKey:FTFocalLengthKey];
	[defaultValues setObject:[NSNumber numberWithFloat:DefaultSubjectDistance]
					  forKey:FTSubjectDistanceKey];
	
	[defaultValues setObject:[NSNumber numberWithInt:DefaultApertureIndex]
					  forKey:FTApertureIndex];
	
	[defaultValues setObject:[NSNumber numberWithInt:DefaultDistanceType] 
					  forKey:FTDistanceTypeKey];
	[defaultValues setObject:[NSNumber numberWithBool:DefaultMetric]
					  forKey:FTMetricKey];

	// Add default version to make migration easier for subsequent versions
	[defaultValues setObject:[NSNumber numberWithInt:DEFAULTS_VERSION]
					  forKey:FTDefaultsVersion];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

+ (void)migrateDefaults:(NSMutableDictionary*)defaultValues
{
	// Convert camera index to a COC value
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
	NSString* key = [NSString stringWithFormat:@"CAMERA_COC_%d", index];

	NSString* descriptionKey = [NSString stringWithFormat:@"CAMERA_DESCRIPTION_%d", index];
	NSString* description = NSLocalizedString(descriptionKey, "CoCDescription");
	CoC* coc = [[CoC alloc] initWithValue:[NSLocalizedString(key, "CoC") floatValue]
							  description:description];
	
	Camera* camera = [[Camera alloc] initWithDescription:NSLocalizedString(@"DEFAULT_CAMERA_NAME", "Default camera")
													 coc:coc
											  identifier:0];
	[camera save];
	
	// Remove obsolete keys
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:FTCameraIndex];
}

- (void)dealloc 
{
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
