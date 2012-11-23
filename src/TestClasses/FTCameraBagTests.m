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
#import "FTLens.h"

@interface FTCameraBagTests : SenTestCase
{
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
    
    FTCameraBag* bag;
}

@end

@implementation FTCameraBagTests

- (void)setUp
{
    NSArray* bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]];
    model = [NSManagedObjectModel mergedModelFromBundles:bundles];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
    
    [FTCameraBag initSharedCameraBag:ctx];
    
    bag = [FTCameraBag sharedCameraBag];
}

- (void)testSharedCameraBagIsInitiallyEmpty
{
    STAssertEquals([bag cameraCount], 0, @"Bag should initially have no cameras");
    STAssertEquals([bag lensCount], 0, @"Bag should initially have no lenses");
}

- (void)testCanAddCamerasToBag
{
    int numCameras = 3;
    for (int i = 0; i < numCameras; ++i)
    {
        FTCamera* camera = [bag newCamera];
        [camera setName:[NSString stringWithFormat:@"Camera %d", i + 1]];
    }
    
    STAssertEquals([bag cameraCount], numCameras, @"Bag should have correct number of cameras");
}

- (void)testCanDeleteCameraFromBag
{
    // Put some cameras in the bag
    [self testCanAddCamerasToBag];
    
    int countBefore = [bag cameraCount];
    
    // Delete the last camera
    FTCamera* camera = [bag findCameraForIndex:countBefore - 1];
    [bag deleteCamera:camera];
    
    STAssertEquals([bag cameraCount], countBefore - 1, @"Camera should be deleted");
}

- (void)testDeletingCameraAdjustsIndices
{
    FTCamera* camera1 = [bag newCamera];
    [camera1 setName:@"Camera 1"];
    FTCamera* camera2 = [bag newCamera];
    [camera2 setName:@"Camera 2"];
    FTCamera* camera3 = [bag newCamera];
    [camera3 setName:@"Camera 3"];
    
    [bag deleteCamera:camera2];
    
    STAssertEquals([bag cameraCount], 2, @"There should be one less camera");
    STAssertEquals([camera1 indexValue], 0, @"Cameras before the deleted should have the same index");
    STAssertEquals([camera3 indexValue], 1, @"Cameras after the deleted should have a new index");
}

- (void)testNewCamerasHaveCorrectIndex
{
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

- (void)testMovingCameraUpAdjustsIndices
{
    FTCamera* camera1 = [bag newCamera];
    [camera1 setName:@"Camera 1"];
    FTCamera* camera2 = [bag newCamera];
    [camera2 setName:@"Camera 2"];
    FTCamera* camera3 = [bag newCamera];
    [camera3 setName:@"Camera 3"];
    
    [bag moveCameraFromIndex:0 toIndex:2];
    
    STAssertEquals([camera1 indexValue], 2, @"Moved camera has correct index");
    STAssertEquals([camera2 indexValue], 0, @"Stationary camera has correct index");
    STAssertEquals([camera3 indexValue], 1, @"Stationary camera has correct index");
}

- (void)testMovingCameraDownAdjustsIndices
{
    FTCamera* camera1 = [bag newCamera];
    [camera1 setName:@"Camera 1"];
    FTCamera* camera2 = [bag newCamera];
    [camera2 setName:@"Camera 2"];
    FTCamera* camera3 = [bag newCamera];
    [camera3 setName:@"Camera 3"];
    
    [bag moveCameraFromIndex:2 toIndex:0];
    
    STAssertEquals([camera1 indexValue], 1, @"Stationary camera has correct index");
    STAssertEquals([camera2 indexValue], 2, @"Stationary camera has correct index");
    STAssertEquals([camera3 indexValue], 0, @"Moved camera has correct index");
}

- (void)testCanAddLensesToBag
{
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

- (void)testCanDeleteLensFromBag
{
    // Put some lenses in the bag
    [self testCanAddLensesToBag];
    
    int countBefore = [bag lensCount];
    
    // Delete the last lens
    FTLens* lens = [bag findLensForIndex:countBefore - 1];
    [bag deleteLens:lens];
    
    STAssertEquals([bag lensCount], countBefore - 1, @"Lens should be deleted");
}

- (void)testDeletingLensAdjustsIndices
{
    FTLens* lens1 = [bag newLens];
    [lens1 setName:@"Lens 1"];
    FTLens* lens2 = [bag newLens];
    [lens1 setName:@"Lens 2"];
    FTLens* lens3 = [bag newLens];
    [lens1 setName:@"Lens 3"];
    
    [bag deleteLens:lens2];
    
    STAssertEquals([bag lensCount], 2, @"There should be one less lens");
    STAssertEquals([lens1 indexValue], 0, @"Lenses before the deleted should have the same index");
    STAssertEquals([lens3 indexValue], 1, @"Lenses after the deleted should have a new index");
}

- (void)testMovingLensUpAdjustsIndices
{
    FTLens* lens1 = [bag newLens];
    [lens1 setName:@"Lens 1"];
    FTLens* lens2 = [bag newLens];
    [lens1 setName:@"Lens 2"];
    FTLens* lens3 = [bag newLens];
    [lens1 setName:@"Lens 3"];
    
    [bag moveLensFromIndex:0 toIndex:2];
    
    STAssertEquals([lens1 indexValue], 2, @"Moved lens has correct index");
    STAssertEquals([lens2 indexValue], 0, @"Stationary lens has correct index");
    STAssertEquals([lens3 indexValue], 1, @"Stationary lens has correct index");
}

- (void)testMovingLensDownAdjustsIndices
{
    FTLens* lens1 = [bag newLens];
    [lens1 setName:@"Lens 1"];
    FTLens* lens2 = [bag newLens];
    [lens1 setName:@"Lens 2"];
    FTLens* lens3 = [bag newLens];
    [lens1 setName:@"Lens 3"];
    
    [bag moveLensFromIndex:2 toIndex:0];
    
    STAssertEquals([lens1 indexValue], 1, @"Stationary lens has correct index");
    STAssertEquals([lens2 indexValue], 2, @"Stationary lens has correct index");
    STAssertEquals([lens3 indexValue], 0, @"Moved lens has correct index");
}

- (void)tearDown
{
    bag = nil;
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
}

@end
