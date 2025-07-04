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
//  FTCameraBag.h
//  FieldTools
//
//  Created by Brad on 2012-11-03.
//
//

#import <Foundation/Foundation.h>

@class FTCamera;
@class FTCoC;
@class FTLens;

@interface FTCameraBag : NSObject

+ (id)initSharedCameraBag:(NSManagedObjectContext*)managedObjectContext;
+ (FTCameraBag*)sharedCameraBag;

- (NSInteger)cameraCount;
- (void)deleteCamera:(FTCamera*)camera;
- (FTCamera*)findCameraForIndex:(NSInteger)index;
- (FTCamera*)findSelectedCamera;
- (void)moveCameraFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (void)deleteLens:(FTLens*)lens;
- (FTLens*)findSelectedLens;
- (FTLens*)findLensForIndex:(NSInteger)index;
- (void)moveLensFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (NSInteger)lensCount;

- (void)deleteCoC:(FTCoC*)coc;
- (FTCamera*)newCamera;
- (void)createDefaultCamera;
- (FTCoC*)newCoC;
- (FTLens*)newLens;
- (void)createDefaultLens;

- (BOOL)save;
- (void)rollback;

@end
