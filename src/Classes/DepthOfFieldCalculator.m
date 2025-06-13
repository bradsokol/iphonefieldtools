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
//  DepthOfFieldCalculator.m
//  FieldTools
//
//  Created by Brad on 2010/01/01.
//
// Calculations are from Wikipedia: http://en.wikipedia.org/wiki/Hyperfocal_distance
// and http://en.wikipedia.org/wiki/Depth_of_field#Depth_of_field_formulas
//
// The following variables are used in the calculations:
//
// H - Hyperfocal distance in metres
// f - Focal length in millimetres
// c - circle of confusion
// N - f-number
// s - distance to subject in metres

#import "DepthOfFieldCalculator.h"

static NSMutableDictionary* trueApertures;

@implementation DepthOfFieldCalculator

+ (void)populateTrueApertures
{
    if (nil == trueApertures)
    {
        trueApertures = [[NSMutableDictionary alloc] initWithCapacity:39];
        [trueApertures setObject:[NSNumber numberWithFloat:1.0] 
                          forKey:[NSNumber numberWithFloat:1.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:1.122462] 
                          forKey:[NSNumber numberWithFloat:1.1]];
        [trueApertures setObject:[NSNumber numberWithFloat:1.189207] 
                          forKey:[NSNumber numberWithFloat:1.2]];
        [trueApertures setObject:[NSNumber numberWithFloat:1.414214] 
                          forKey:[NSNumber numberWithFloat:1.4]];
        [trueApertures setObject:[NSNumber numberWithFloat:1.587401] 
                          forKey:[NSNumber numberWithFloat:1.6]];
        [trueApertures setObject:[NSNumber numberWithFloat:1.781797] 
                          forKey:[NSNumber numberWithFloat:1.8]];
        [trueApertures setObject:[NSNumber numberWithFloat:2.0] 
                          forKey:[NSNumber numberWithFloat:2.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:2.244924] 
                          forKey:[NSNumber numberWithFloat:2.2]];
        [trueApertures setObject:[NSNumber numberWithFloat:2.519842] 
                          forKey:[NSNumber numberWithFloat:2.5]];
        [trueApertures setObject:[NSNumber numberWithFloat:2.828427] 
                          forKey:[NSNumber numberWithFloat:2.8]];
        [trueApertures setObject:[NSNumber numberWithFloat:3.174802] 
                          forKey:[NSNumber numberWithFloat:3.2]];
        [trueApertures setObject:[NSNumber numberWithFloat:3.563595] 
                          forKey:[NSNumber numberWithFloat:3.5]];
        [trueApertures setObject:[NSNumber numberWithFloat:4.0] 
                          forKey:[NSNumber numberWithFloat:4.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:4.489848] 
                          forKey:[NSNumber numberWithFloat:4.5]];
        [trueApertures setObject:[NSNumber numberWithFloat:5.039684] 
                          forKey:[NSNumber numberWithFloat:5.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:5.656854] 
                          forKey:[NSNumber numberWithFloat:5.6]];
        [trueApertures setObject:[NSNumber numberWithFloat:6.349604] 
                          forKey:[NSNumber numberWithFloat:6.3]];
        [trueApertures setObject:[NSNumber numberWithFloat:7.127190] 
                          forKey:[NSNumber numberWithFloat:7.1]];
        [trueApertures setObject:[NSNumber numberWithFloat:8.0] 
                          forKey:[NSNumber numberWithFloat:8.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:8.979696] 
                          forKey:[NSNumber numberWithFloat:9.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:10.07937] 
                          forKey:[NSNumber numberWithFloat:10.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:11.313708] 
                          forKey:[NSNumber numberWithFloat:11.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:12.699208] 
                          forKey:[NSNumber numberWithFloat:13.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:14.254382] 
                          forKey:[NSNumber numberWithFloat:14.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:16.0] 
                          forKey:[NSNumber numberWithFloat:16.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:17.959393] 
                          forKey:[NSNumber numberWithFloat:18.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:20.158737] 
                          forKey:[NSNumber numberWithFloat:20.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:22.627417] 
                          forKey:[NSNumber numberWithFloat:22.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:25.398417] 
                          forKey:[NSNumber numberWithFloat:25.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:28.508759] 
                          forKey:[NSNumber numberWithFloat:28.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:32.0] 
                          forKey:[NSNumber numberWithFloat:32.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:45.254834] 
                          forKey:[NSNumber numberWithFloat:45.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:50.796831] 
                          forKey:[NSNumber numberWithFloat:51.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:53.817365] 
                          forKey:[NSNumber numberWithFloat:57.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:64.0] 
                          forKey:[NSNumber numberWithFloat:64.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:71.837568] 
                          forKey:[NSNumber numberWithFloat:72.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:80.634927] 
                          forKey:[NSNumber numberWithFloat:81.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:90.509668] 
                          forKey:[NSNumber numberWithFloat:91.0]];
        [trueApertures setObject:[NSNumber numberWithFloat:101.593663] 
                          forKey:[NSNumber numberWithFloat:100.0]];
    }    
}

+ (float)trueAperture:(float)aperture
{
    if (nil == trueApertures)
    {
        [DepthOfFieldCalculator populateTrueApertures];
    }
    
    NSNumber* result = [trueApertures objectForKey:[NSNumber numberWithFloat:aperture]];
    
    NSAssert(nil != result, @"Failed to find true aperture for %f", aperture);
    
    return nil == result ? 0.0 : [result floatValue];
}

// Calculate far limit of depth of field using the formula:
//
// Df = (s(H - f)/(H - s))
//
// Result is in meters.
+ (float)calculateFarLimitForAperture:(float)aperture focalLength:(float)focalLength circleOfConfusion:(float)coc subjectDistance:(float)subjectDistance
{
	float h = [self calculateHyperfocalDistanceForAperture:aperture
                                               focalLength:(float)focalLength 
                                         circleOfConfusion:(float)coc];
	
	float result = (((h - focalLength / 1000.0) * subjectDistance) / (h - subjectDistance));
	
	return result;
}

// Caculate hyperfocal distance using formula:
//
// H = (f^2) / (Nc) + f
//
// Result is in meters.
+ (float)calculateHyperfocalDistanceForAperture:(float)aperture focalLength:(float)focalLength circleOfConfusion:(float)coc
{
	return ((focalLength * focalLength) / ([DepthOfFieldCalculator trueAperture:aperture] * coc) + focalLength) / 1000.0f;
}

// Calculate near limit of depth of field using the formula:
//
// Dn = (s(H - f)/(H + s - 2f))
//
// Result is in meters.
+ (float)calculateNearLimitForAperture:(float)aperture focalLength:(float)focalLength circleOfConfusion:(float)coc subjectDistance:(float)subjectDistance
{
	float h = [self calculateHyperfocalDistanceForAperture:aperture
                                               focalLength:(float)focalLength 
                                         circleOfConfusion:(float)coc];
	
    float focalLengthInMetres = focalLength / 1000.0;
	return (((h - focalLengthInMetres) * subjectDistance) / 
            (h + subjectDistance - 2 * focalLengthInMetres));
}

@end
