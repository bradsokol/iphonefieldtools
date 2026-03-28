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
//  FieldToolsAppDelegate.m
//  FieldTools
//
//  Created by Brad on 2008/11/29.
//

#import "FieldToolsAppDelegate.h"

#import "FTCamera.h"
#import "FTCameraBag.h"
#import "FTCoC.h"
#import "FTLens.h"
#import "FTPersistenceController.h"
#import "SubjectDistanceRangePolicyFactory.h"

#import "UserDefaults.h"

// Defaults for preferences
int DefaultApertureIndex = 18;
NSString* const DefaultCoC = @"Nikon DX";
int DefaultDistanceType = 0; // Hyperfocal
float DefaultFocalLength = 24.0f;
bool DefaultMetric = NO;
float DefaultSubjectDistance = 2.5f;

@interface FieldToolsAppDelegate ()

+ (void)setupDefaultValues;

@end

@implementation FieldToolsAppDelegate

# pragma mark "UIApplicationDelegate methods"

- (void)initializeCameraBag {
    [FTCameraBag initSharedCameraBag:[[FTPersistenceController sharedController] managedObjectContext]];
    FTCameraBag* cameraBag = [FTCameraBag sharedCameraBag];

    if ([cameraBag cameraCount] == 0) {
        [cameraBag createDefaultCamera];
    }
    if ([cameraBag lensCount] == 0) {
        [cameraBag createDefaultLens];
    }

    [cameraBag save];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeCameraBag];

	[FieldToolsAppDelegate setupDefaultValues];

    return YES;
}

#pragma mark "Helper methods"

+ (void)setupDefaultValues
{
	NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];

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
	[defaultValues setObject:[NSNumber numberWithInt:DistanceUnitsFeetAndInches]
					  forKey:FTDistanceUnitsKey];
    
    [defaultValues setObject:[NSNumber numberWithInt:SubjectDistanceRangeMid]
                                              forKey:FTSubjectDistanceRangeKey];

	// Add default version to make migration easier for subsequent versions
	[defaultValues setObject:[NSNumber numberWithInt:DEFAULTS_BASE_VERSION]
					  forKey:FTDefaultsVersion];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

@end
