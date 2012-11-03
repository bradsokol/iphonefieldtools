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
//  FTCameraBagTests.m
//  FieldTools
//
//  Created by Brad on 2012/11/03.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

#import "FTCamera.h"
#import "FTCameraBag.h"

@interface FTCameraBagTests : SenTestCase
{
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
}

@end

@implementation FTCameraBagTests

- (void)setUp
{
    NSArray* bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]];
    model = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
    
    [FTCameraBag initSharedCameraBag:ctx];
}

- (void)testSharedCameraBagIsInitiallyEmpty
{
    FTCameraBag* bag = [FTCameraBag sharedCameraBag];
    
    STAssertEquals([bag cameraCount], 0, @"Bag should initially have no cameras");
    STAssertEquals([bag lensCount], 0, @"Bag should initially have no lenses");
}

- (void)testCanAddCamerasToBag
{
    FTCameraBag* bag = [FTCameraBag sharedCameraBag];
    
    int numCameras = 3;
    for (int i = 0; i < numCameras; ++i)
    {
        FTCamera* camera = [bag newCamera];
        [camera setName:[NSString stringWithFormat:@"Camera %d", i + 1]];
        [bag addCamera:camera];
    }
    
    STAssertEquals([bag cameraCount], numCameras, @"Bag should have correct number of cameras");
}

- (void)tearDown
{
    [ctx release];
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    [coord release];
    coord = nil;
    [model release];
    model = nil;
}

@end
