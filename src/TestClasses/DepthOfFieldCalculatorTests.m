// Copyright 2010 Brad Sokol
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
//  DepthOfFieldCalculatorTests.m
//  FieldTools
//
//  Created by Brad on 2010/01/01.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

#import "DepthOfFieldCalculator.h"

@interface DepthOfFieldCalculatorTests : SenTestCase
{
	float coc;
}

@end

@implementation DepthOfFieldCalculatorTests

- (void)setUp
{
	coc = 0.02f;
}

- (void)testFarDistanceCalculations
{
	float accuracy = 0.09f;
	float expected, result, focalLength, subjectDistance;
	
	// ***********************
	focalLength = 10.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// ***********************
	focalLength = 50.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.094f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.197f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.294f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.427f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.688f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.086f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.099f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.631f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.443f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 7.353f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 8.928f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 13.887f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 41.657f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 12.887f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 18.116f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 27.778f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 83.314f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 22.59f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 45.734f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 375.0f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 56.818f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	STAssertTrue(result < 0, @"Far distance not infinity");
	
	// ***********************
	focalLength = 400.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.001f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.003f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.004f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.006f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.008f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.011f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.016f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.009f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.018f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.025f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.035f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.051f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.07f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.102f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.035f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.07f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.101f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.139f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.204f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.283f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.417f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.079f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.159f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.228f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.316f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.464f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.645f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.957f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.221f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.445f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.641f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.89f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 26.316f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 26.846f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 27.778f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 50.891f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 51.813f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 52.632f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 53.691f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 55.556f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 57.971f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 62.5f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
}

- (void)testHyperfocalCalculations
{
	float accuracy = 0.0009f;
	float expected, result, focalLength;

	focalLength = 10.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 1.786f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);

	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.893f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.625f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.455f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.227f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.156f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 24.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 10.286f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 5.143f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 3.6f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 2.618f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 1.309f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.9f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 50.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 44.643f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 22.321f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 15.625f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 11.364f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 5.682f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 3.906f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 100.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 178.571f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 89.286f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 62.5f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 45.455f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 22.727f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 15.625f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 200.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 714.286f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 357.143f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 250.0f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 181.818f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 90.909f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 62.5f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 400.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 2857.143f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 1428.571f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 1000.0f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 727.273f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 363.636f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 250.0f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
}

- (void)testNearDistanceCalculations
{
	float accuracy = 0.09f;
	float expected, result, focalLength, subjectDistance;
	
	// ***********************
	focalLength = 10.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.943f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);

	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.617f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.476f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.371f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.271f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.204f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.145f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.316f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.758f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.556f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.417f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.295f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.217f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.151f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.515f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.82f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.588f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.435f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.304f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.222f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.154f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.596f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.843f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.6f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.442f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.307f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.224f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.154f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.667f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.862f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.61f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.447f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.309f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.225f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.155f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.724f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.877f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.617f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.451f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.311f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.226f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.156f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// ***********************
	focalLength = 50.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.914f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.836f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.773f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.701f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.592f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.479f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.323f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.496f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.085f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.788f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.472f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.049f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.66f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.193f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 8.17f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.906f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.098f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.319f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.386f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.623f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.809f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 11.228f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 8.971f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 7.653f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.466f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.137f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.121f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.099f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 16.026f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 11.792f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.615f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 7.813f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.953f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.63f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.378f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 23.585f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.432f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 11.905f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.26f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.757f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.102f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.623f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// ***********************
	focalLength = 400.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.999f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.997f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.996f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.995f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.992f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.989f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.984f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.991f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.983f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.975f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.966f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.95f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.932f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.902f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.965f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.93f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.901f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.864f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.804f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.732f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.615f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.922f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.844f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.778f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.697f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.563f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.406f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.151f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.783f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.57f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.39f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.169f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 23.81f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 23.392f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 22.727f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 49.14f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 48.309f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 47.619f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 46.784f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 45.455f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 43.956f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 41.667f;
	STAssertEqualsWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
}

@end
