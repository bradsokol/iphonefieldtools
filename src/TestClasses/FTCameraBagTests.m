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
    }
    
    STAssertEquals([bag cameraCount], numCameras, @"Bag should have correct number of cameras");
}

- (void)testNewCamerasHaveCorrectIndex
{
    FTCameraBag* bag = [FTCameraBag sharedCameraBag];
    
    FTCamera* camera1 = [bag newCamera];
    [camera1 setName:@"Camera 1"];
    FTCamera* camera2 = [bag newCamera];
    [camera2 setName:@"Camera 2"];
    
    STAssertEquals([bag cameraCount], 2, @"Bag should have correct number of cameras");

    FTCamera* camera = [bag findCameraForIndex:0];
    STAssertEqualObjects([camera name], [camera1 name], @"Camera 1 should be at index 0");
    camera = [bag findCameraForIndex:1];
    STAssertEqualObjects([camera name], [camera2 name], @"Camera 2 should be at index 1");
}

- (void)testCanAddLensesToBag
{
    FTCameraBag* bag = [FTCameraBag sharedCameraBag];
    
    int numLenses = 3;
    for (int i = 0; i < numLenses; ++i)
    {
        FTLens* lens = [bag newLens];
        [lens setName:[NSString stringWithFormat:@"Lens %d", i + 1]];
    }
    
    STAssertEquals([bag lensCount], numLenses, @"Bag should have correct number of lenses");
}

- (void)testNewLensesHaveCorrectIndex
{
    FTCameraBag* bag = [FTCameraBag sharedCameraBag];
    
    FTLens* lens1 = [bag newLens];
    [lens1 setName:@"Lens 1"];
    FTLens* lens2 = [bag newLens];
    [lens2 setName:@"Lens 2"];
    
    STAssertEquals([bag lensCount], 2, @"Bag should have correct number of lenses");
    
    FTLens* lens = [bag findLensForIndex:0];
    STAssertEqualObjects([lens name], [lens1 name], @"Lens 1 should be at index 0");
    lens = [bag findLensForIndex:1];
    STAssertEqualObjects([lens name], [lens2 name], @"Lens 2 should be at index 1");
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
