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
//  FTCameraBag.h
//  FieldTools
//
//  Created by Brad on 2012-11-03.
//
//

#import <Foundation/Foundation.h>

@class Camera;
@class Lens;

@interface FTCameraBag : NSObject

+ (FTCameraBag*)sharedCameraBag;

- (int)cameraCount;
- (void)deleteCamera:(Camera*)camera;
- (Camera*)findCameraForIndex:(int)index;
- (Camera*)findSelectedCamera;
- (void)moveCameraFromIndex:(int)fromIndex toIndex:(int)toIndex;

- (void)deleteLens:(Lens*)lens;
- (Lens*)findSelectedLens;
- (Lens*)findLensForIndex:(int)index;
- (void)moveLensFromIndex:(int)fromIndex toIndex:(int)toIndex;
- (int)lensCount;

- (void)addCamera:(Camera*)camera;
- (void)addLens:(Lens*)lens;

- (void)save;

@end
