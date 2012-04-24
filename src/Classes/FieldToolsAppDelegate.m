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

#import "Appirater.h"
#import "Camera.h"
#import "CameraBag.h"
#import "Coc.h"
#import "Lens.h"
#import "RootViewController.h"
#import "SubjectDistanceRangePolicyFactory.h"

#import "UserDefaults.h"

static NSString* oldSharedCameraBagArchivePath;
static NSString* sharedCameraBagArchivePath;

// Defaults for preferences
int DefaultApertureIndex = 18;
NSString* const DefaultCoC = @"Nikon DX";
int DefaultDistanceType = 0; // Hyperfocal
float DefaultFocalLength = 24.0f;
bool DefaultMetric = NO;
float DefaultSubjectDistance = 2.5f;

@interface FieldToolsAppDelegate ()

- (void)relocateCameraBag;
- (void)saveDefaults;

+ (void)migrateDefaultsFrom10:(NSMutableDictionary*)defaultValues;
+ (void)migrateDefaultsFrom20:(NSMutableDictionary*)defaultValues;
+ (void)migrateDefaultsFrom21:(NSMutableDictionary*)defaultValues;
+ (void)migrateDefaultsFrom22:(NSMutableDictionary*)defaultValues;
+ (void)setupDefaultValues;

@end

@implementation FieldToolsAppDelegate

@synthesize window;
@synthesize rootViewController;

- (void)awakeFromNib
{
#ifdef DEBUG
    // Don't send events to Google from debug builds
    [[GANTracker sharedTracker] setDryRun:YES];
#endif
    
    [[GANTracker sharedTracker] setAnonymizeIp:YES];
    [[GANTracker sharedTracker] startTrackerWithAccountID:kGANAccountId
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];	
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];    
    
	oldSharedCameraBagArchivePath = [[NSString stringWithFormat:@"%@/Default.camerabag",
								   libraryPath] retain];
	sharedCameraBagArchivePath = [[NSString stringWithFormat:@"%@/Default.camerabag",
                                      documentsPath] retain];
    
    [self relocateCameraBag];

	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], FTMigratedFrom10Key, nil]];
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], FTMigratedFrom20Key, nil]];
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], FTMigratedFrom22Key, nil]];
	
	[FieldToolsAppDelegate setupDefaultValues];
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FTMigratedFrom10Key];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FTMigratedFrom20Key];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FTMigratedFrom22Key];

	[CameraBag initSharedCameraBagFromArchive:sharedCameraBagArchivePath];
}

# pragma mark "UIApplicationDelegate methods"

// Called only on iOS 4.0 and later
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self saveDefaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
    
    [Appirater appLaunched:YES];
    
    return YES;
}

// Called only on iOS 4.0 and later
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self saveDefaults];
}

#pragma mark "Helper methods"

+ (void)setupDefaultValues
{
	bool migratedFrom10 = [[NSUserDefaults standardUserDefaults] boolForKey:FTMigratedFrom10Key];
	NSLog(@"Previously migrated from 1.0: %s", migratedFrom10 ? "YES" : "NO");
	bool migratedFrom20 = [[NSUserDefaults standardUserDefaults] boolForKey:FTMigratedFrom20Key];
	NSLog(@"Previously migrated from 2.0: %s", migratedFrom20 ? "YES" : "NO");
	
	bool migratedFrom21 = [[NSFileManager defaultManager] fileExistsAtPath:sharedCameraBagArchivePath];
	NSLog(@"Previously migrated from 2.1: %s", migratedFrom21 ? "YES" : "NO");
	
	bool migratedFrom22 = [[NSUserDefaults standardUserDefaults] boolForKey:FTMigratedFrom22Key];
	NSLog(@"Previously migrated from 2.2: %s", migratedFrom22 ? "YES" : "NO");

	NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
	
    if (!migratedFrom22)
    {
        if (!migratedFrom21)
        {
            if (!migratedFrom20)
            {
                if (!migratedFrom10)
                {
                    NSLog(@"Migrating defaults from 1.0 to 2.0");
                    [FieldToolsAppDelegate migrateDefaultsFrom10:defaultValues];
                }
                else if ([Camera count_deprecated] == 0)
                {
                    CoC* coc = [CoC findFromPresets:DefaultCoC];
                    Camera* camera = [[Camera alloc] initWithDescription:NSLocalizedString(@"DEFAULT_CAMERA_NAME", "Default camera")
                                                                     coc:coc
                                                              identifier:0];
                    [camera save_deprecated];
                    [camera release];
                }
                
                NSLog(@"Migrating defaults from 2.0 to 2.1");
                [FieldToolsAppDelegate migrateDefaultsFrom20:defaultValues];
            }
            
            NSLog(@"Migrating defaults from 2.1");
            [FieldToolsAppDelegate migrateDefaultsFrom21:defaultValues];
        }
        
        NSLog(@"Migrating defaults from 2.2");
        [FieldToolsAppDelegate migrateDefaultsFrom22:defaultValues];
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
	[defaultValues setObject:[NSNumber numberWithInt:DistanceUnitsFeetAndInches]
					  forKey:FTDistanceUnitsKey];
    
    [defaultValues setObject:[NSNumber numberWithInt:SubjectDistanceRangeMid]
                                              forKey:FTSubjectDistanceRangeKey];

	// Add default version to make migration easier for subsequent versions
	[defaultValues setObject:[NSNumber numberWithInt:DEFAULTS_BASE_VERSION]
					  forKey:FTDefaultsVersion];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

+ (void)migrateDefaultsFrom10:(NSMutableDictionary*)defaultValues
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
	[camera save_deprecated];
	[camera release];
	[coc release];
	
	// Create an initial lens using the limits of the sliders from V1.0
	Lens* lens = [[Lens alloc] initWithDescription:NSLocalizedString(@"DEFAULT_LENS_NAME", "Default lens")
								   minimumAperture:[NSNumber numberWithFloat:32.0]
								   maximumAperture:[NSNumber numberWithFloat:1.4]
								minimumFocalLength:[NSNumber numberWithInt:10]
								maximumFocalLength:[NSNumber numberWithInt:200]
										identifier:0];
	[lens save_deprecated];
	[lens release];
	
	// Remove obsolete keys
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:FTCameraIndex];
}

+ (void)migrateDefaultsFrom20:(NSMutableDictionary*)defaultValues
{
	bool metric = [[NSUserDefaults standardUserDefaults] boolForKey:FTMetricKey];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:metric ? DistanceUnitsMeters : DistanceUnitsFeet]
											  forKey:FTDistanceUnitsKey];
	
	// Remove obsolete keys
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:FTMetricKey];
}

+ (void)migrateDefaultsFrom21:(NSMutableDictionary*)defaultValues
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	CameraBag* cameraBag = [[CameraBag alloc] init];
	
	int cameraCount = [defaults integerForKey:FTCameraCount];
	for (int i = 0; i < cameraCount; ++i)
	{
		Camera* camera = [Camera findFromDefaultsForIndex_deprecated:i];
		
		[cameraBag addCamera:camera];
	}
	
	int lensCount = [defaults integerForKey:FTLensCount];
	for (int i = 0; i < lensCount; ++i)
	{
		Lens* lens = [Lens findFromDefaultsForIndex_deprecated:i];
		
		[cameraBag addLens:lens];
	}
	
	if ([NSKeyedArchiver archiveRootObject:cameraBag toFile:sharedCameraBagArchivePath])
	{
		[CameraBag initSharedCameraBagFromArchive:sharedCameraBagArchivePath];
		
		// Remove obsolete defaults
		for (int i = 0; i < cameraCount; ++i)
		{
			[defaults removeObjectForKey:[NSString stringWithFormat:@"Camera%d", i]];
		}
		[defaults removeObjectForKey:FTCameraCount];
		for (int i = 0; i < lensCount; ++i)
		{
			[defaults removeObjectForKey:[NSString stringWithFormat:@"Lens%d", i]];
		}
		[defaults removeObjectForKey:FTLensCount];
	}
	else
	{
		NSLog(@"Failed to create archive while migrating from 2.0 defaults");
	}
	
	[cameraBag release];
}

+ (void)migrateDefaultsFrom22:(NSMutableDictionary*)defaultValues
{
    bool macro = [[NSUserDefaults standardUserDefaults] boolForKey:FTMacroModeKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:macro ? SubjectDistanceRangeMacro : SubjectDistanceRangeMid]
                                              forKey:FTSubjectDistanceRangeKey];
    
    // Remove obsolete keys
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FTMacroModeKey];
}

- (void)saveDefaults
{
	[[NSUserDefaults standardUserDefaults] synchronize];
}

// This method is necessary because for some reason I originally put the camera bag
// in the Library directory. It should be in Documents.
- (void)relocateCameraBag
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:sharedCameraBagArchivePath])
    {
        NSLog(@"Camera bag already exists at new location.");
        
        // File exists at the new location. There is nothing to do. For safety, check
        // that there is not a file at the old location.
        NSAssert(![[NSFileManager defaultManager] fileExistsAtPath:oldSharedCameraBagArchivePath],
                 @"Camera bags found at both old and new location.");
        return;
    }
    
    NSLog(@"Moving camera bag to new location.");
    
    NSError* error;
    if (![[NSFileManager defaultManager] moveItemAtPath:oldSharedCameraBagArchivePath
                                            toPath:sharedCameraBagArchivePath
                                             error:&error])
    {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)dealloc 
{
    [self setRootViewController:nil];
    [self setWindow:nil];
	
    [super dealloc];
}

@end
