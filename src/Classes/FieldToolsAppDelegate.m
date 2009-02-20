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
#import "RootViewController.h"

#import "UserDefaults.h"

// Keys for user defaults
NSString* const FTApertureIndex = @"ApertureIndex";
NSString* const FTCameraCount = @"CameraCount";
NSString* const FTCameraIndex = @"CameraIndex";
NSString* const FTDistanceTypeKey = @"DistanceType";
NSString* const FTFocalLengthKey = @"FocalLength";
NSString* const FTMetricKey = @"Metric";
NSString* const FTSubjectDistanceKey = @"SubjectDistance";

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
int DefaultCameraIndex = 4;
int DefaultDistanceType = 0; // Hyperfocal
float DefaultFocalLength = 24.0f;
bool DefaultMetric = NO;
float DefaultSubjectDistance = 2.5f;

// Defaults for preferences (future functionality)
/*
float DefaultFStop = 8.0;
float DefaultCoC = 0.02;
float DefaultMaximumFStop = 2.8;
float DefaultMinimumFStop = 32.0;
float DefaultMinimumFocalLength = 10.0;
float DefaultMaximumFocalLength = 100.0;
 */

@implementation FieldToolsAppDelegate

@synthesize window;
@synthesize rootViewController;

+ (void)initialize
{
	// Setup initial values for preferences
	NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
	
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
	
	[defaultValues setObject:[NSNumber numberWithInt:DefaultCameraIndex]
					  forKey:FTCameraIndex];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}

- (void)dealloc 
{
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
