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
//  DepthOfFieldCalculator.h
//  FieldTools
//
//  Created by Brad on 2010/01/01.
//

#import <Foundation/Foundation.h>

@interface DepthOfFieldCalculator : NSObject 
{
}

// Calculate far limit of depth of field using the formula:
//
// Df = ((Hs)/(H - (s - f)))
//
// Result is in meters.
+ (float)calculateFarLimitForAperture:(float)aperture focalLength:(float)focalLength circleOfConfusion:(float)coc subjectDistance:(float)subjectDistance;

// Caculate hyperfocal distance using formula:
//
// H = (f^2) / (Nc) + f
//
// Result is in meters.
+ (float)calculateHyperfocalDistanceForAperture:(float)aperture focalLength:(float)focalLength circleOfConfusion:(float)coc;

// Calculate near limit of depth of field using the formula:
//
// Dn = ((Hs)/(H + (s - f)))
//
// Result is in meters.
+ (float)calculateNearLimitForAperture:(float)aperture focalLength:(float)focalLength circleOfConfusion:(float)coc subjectDistance:(float)subjectDistance;

@end
