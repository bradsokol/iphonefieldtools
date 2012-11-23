// Copyright 2012 Brad Sokol
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
//  FTCameraBag.m
//  FieldTools
//
//  Created by Brad on 2012-11-03.
//
//

#import "FTCameraBag.h"

#import "FieldToolsAppDelegate.h"
#import "FTCamera.h"
#import "FTCoC.h"
#import "FTLens.h"

#import "UserDefaults.h"

@interface FTCameraBag ()

- (NSUInteger)countEntityInstances:(NSString *)entityName;
- (NSManagedObject*)findEntityInstanceWithName:(NSString*)name atIndex:(NSUInteger)index;

@property(nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end

@implementation FTCameraBag

static FTCameraBag* sharedCameraBag = nil;

@synthesize managedObjectContext = _managedObjectContext;

+ (id)initSharedCameraBag:(NSManagedObjectContext*)managedObjectContext
{
    NSParameterAssert(managedObjectContext);
    
    [sharedCameraBag release];
    
    sharedCameraBag = [[FTCameraBag alloc] init];
    [sharedCameraBag setManagedObjectContext:managedObjectContext];
    
    return sharedCameraBag;
}

+ (FTCameraBag*)sharedCameraBag
{
	return sharedCameraBag;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Camera bag with %d cameras and %d lenses",
            [self cameraCount], [self lensCount]];
}

- (int)cameraCount
{
    return [self countEntityInstances:@"Camera"];
}

- (void)deleteCamera:(FTCamera*)camera
{
    int deletedIndex = [camera indexValue];
    [[self managedObjectContext] deleteObject:camera];
    
    int cameraCount = [self cameraCount];
    for (int i = deletedIndex + 1; i <= cameraCount; ++i)
    {
        FTCamera* camera = [self findCameraForIndex:i];
        [camera setIndexValue:i - 1];
    }
}

- (FTCamera*)findCameraForIndex:(int)index
{
    return (FTCamera*)[self findEntityInstanceWithName:@"Camera" atIndex:index];
}

- (FTCamera*)findSelectedCamera
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTCameraIndex];
    return [self findCameraForIndex:index];
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
            FTCamera* camera = [self findCameraForIndex:i];
            FTCamera* nextCamera = [self findCameraForIndex:i + 1];
            [camera setIndexValue:i + 1];
            [nextCamera setIndexValue:i];
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
            FTCamera* camera = [self findCameraForIndex:i];
            FTCamera* previousCamera = [self findCameraForIndex:i - 1];
            [camera setIndexValue:i - 1];
            [previousCamera setIndexValue:i];
		}
	}
	
	for (int i = 0; i < [self cameraCount]; ++i)
	{
		FTCamera* camera = [self findCameraForIndex:i];
		[camera setIndexValue:i];
	}
    
	[[NSUserDefaults standardUserDefaults] setInteger:newSelectedIndex
											   forKey:FTCameraIndex];
}

- (void)deleteLens:(FTLens*)lens
{
    int deletedIndex = [lens indexValue];
    [[self managedObjectContext] deleteObject:lens];
    
    int lensCount = [self lensCount];
    for (int i = deletedIndex + 1; i <= lensCount; ++i)
    {
        FTLens* lens = [self findLensForIndex:i];
        [lens setIndexValue:i - 1];
    }
}

- (FTLens*)findSelectedLens
{
	NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:FTLensIndex];
    return [self findLensForIndex:index];
}

- (FTLens*)findLensForIndex:(int)index
{
    return (FTLens*)[self findEntityInstanceWithName:@"Lens" atIndex:index];
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
            FTLens* lens = [self findLensForIndex:i];
            FTLens* nextLens = [self findLensForIndex:i + 1];
            [lens setIndexValue:i + 1];
            [nextLens setIndexValue:i];
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
            FTLens* lens = [self findLensForIndex:i];
            FTLens* previousLens = [self findLensForIndex:i - 1];
            [lens setIndexValue:i - 1];
            [previousLens setIndexValue:i];
		}
	}
	
	for (int i = 0; i < [self lensCount]; ++i)
	{
        FTLens* lens = [self findLensForIndex:i];
		[lens setIndexValue:i];
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger:newSelectedIndex
											   forKey:FTLensIndex];
}

- (int)lensCount
{
    return [self countEntityInstances:@"Lens"];
}

- (FTCamera*)newCamera
{
    NSUInteger count = [self cameraCount];
    
    NSManagedObjectContext* context = [self managedObjectContext];
    FTCamera* camera = [[FTCamera alloc] initWithEntity:[NSEntityDescription
                                                         entityForName:@"Camera"
                                                         inManagedObjectContext:context]
                         insertIntoManagedObjectContext:context];
    
    [camera setIndexValue:count];
    
    return camera;
}

- (FTCoC*)newCoC
{
    NSManagedObjectContext* context = [self managedObjectContext];
    FTCoC* coc = [[FTCoC alloc] initWithEntity:[NSEntityDescription
                                                entityForName:@"CoC"
                                                inManagedObjectContext:context]
                insertIntoManagedObjectContext:context];
    
    NSLog(@"New CoC: %p", coc);
    return coc;
}

- (FTLens*)newLens
{
    NSUInteger count = [self lensCount];
    
    NSManagedObjectContext* context = [self managedObjectContext];
    FTLens* lens = [[FTLens alloc] initWithEntity:[NSEntityDescription
                                                   entityForName:@"Lens"
                                                   inManagedObjectContext:context]
                   insertIntoManagedObjectContext:context];
    
    [lens setIndexValue:count];
    
    return lens;
}

- (void)deleteCoC:(FTCoC*)coc
{
    NSAssert([coc camera] == nil, @"Attempting to delete coc that is attached to a camera");

    NSLog(@"Deleting CoC: %p", coc);
    [[self managedObjectContext] deleteObject:coc];
}

- (BOOL)save
{
    NSError *error = nil;
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
#if DEBUG
    NSSet* inserts = [managedObjectContext insertedObjects];
    if ([inserts count] > 0)
    {
        NSLog(@"Persisting %d objects", [inserts count]);
    }
    for (id object in inserts)
    {
        FTCoC* coc = (FTCoC*) object;
        NSLog(@"%p %@ (camera: %@)", object, [object description], [[coc camera] description]);
        
    }
#endif
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0)
            {
                for(NSError* detailedError in detailedErrors)
                {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else
            {
                NSLog(@"  %@", [error userInfo]);
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void)rollback
{
    [[self managedObjectContext] rollback];
}

- (NSManagedObjectContext*)managedObjectContext
{
    if (nil == _managedObjectContext)
    {
        _managedObjectContext =
            [(FieldToolsAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _managedObjectContext;
}

- (NSUInteger)countEntityInstances:(NSString *)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    [request setIncludesSubentities:NO];
    
    NSError *error;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
    if (count == NSNotFound)
    {
        NSLog(@"Error counting entity instances: %@", error);
        count = 0;
    }
    
    [request release];
    
    return count;
}

- (NSManagedObject*)findEntityInstanceWithName:(NSString*)name atIndex:(NSUInteger)index
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:name];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(index = %d)", index];
    [request setPredicate:predicate];
    
    NSError* error;
    NSArray* results = [[self managedObjectContext] executeFetchRequest:request
                                                                  error:&error];
    
    [request release];
    
    return [results count] == 0 ? nil : [results objectAtIndex:0];
}

- (void)dealloc
{
    [self setManagedObjectContext:nil];
    
    [super dealloc];
}

@end
