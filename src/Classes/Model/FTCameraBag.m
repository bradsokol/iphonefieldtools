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
#import "FTLens.h"

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

- (int)cameraCount
{
    return [self countEntityInstances:@"Camera"];
}

- (void)deleteCamera:(FTCamera*)camera
{
}

- (FTCamera*)findCameraForIndex:(int)index
{
    return (FTCamera*)[self findEntityInstanceWithName:@"Camera" atIndex:index];
}

- (FTCamera*)findSelectedCamera
{
    return nil;
}

- (void)moveCameraFromIndex:(int)fromIndex toIndex:(int)toIndex
{
}

- (void)deleteLens:(FTLens*)lens
{
}

- (FTLens*)findSelectedLens
{
    return nil;
}

- (FTLens*)findLensForIndex:(int)index
{
    return (FTLens*)[self findEntityInstanceWithName:@"Lens" atIndex:index];
}

- (void)moveLensFromIndex:(int)fromIndex toIndex:(int)toIndex
{
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

- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // TODO: Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
    if(count == NSNotFound)
    {
        //Handle error
        
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
