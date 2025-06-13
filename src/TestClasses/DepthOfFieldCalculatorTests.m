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
//  DepthOfFieldCalculatorTests.m
//  FieldTools
//
//  Created by Brad on 2010/01/01.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "DepthOfFieldCalculator.h"

@interface DepthOfFieldCalculatorTests : XCTestCase
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
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// ***********************
	focalLength = 50.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.094f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy,
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.197f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.294f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.427f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.688f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.086f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.99f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.631f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.443f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 7.353f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.058f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 13.646f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 48.098f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 12.887f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 18.116f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 27.533f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 100.574f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 22.59f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 46.376f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 347.222f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 57.412f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	XCTAssertTrue(result < 0, @"Far distance not infinity");
	
	// ***********************
	focalLength = 400.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.001f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.003f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.004f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.006f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.008f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.011f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.016f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.009f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.018f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.025f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.035f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.051f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.07f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.102f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.035f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.07f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.101f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.139f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.204f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.283f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 10.417f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.079f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.159f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.228f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.316f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.464f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.645f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.957f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.221f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.445f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.641f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 25.89f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 26.316f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 26.846f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 27.778f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 50.891f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 51.813f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 52.632f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 53.691f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 55.556f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 58.159f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateFarLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 62.375f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in far distance calculation - expected %f got %f", expected, result);
}

- (void)testHyperfocalCalculations
{
	float accuracy = 0.009f;
	float expected, result, focalLength;

	focalLength = 10.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 1.78f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);

	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.893f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.635f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.455f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.227f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.166f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 24.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 10.206f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 5.115f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 3.624f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 2.57f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 1.3f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 0.924f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 50.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 44.244f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 22.147f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 15.675f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 11.099f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 5.574f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 3.956f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 100.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 176.877f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 88.488f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 62.6f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 44.294f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 22.197f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 15.725f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 200.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 707.307f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 353.753f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 250.2f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 176.977f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 88.588f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 62.7f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	focalLength = 400.0f;
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:2.8f focalLength:focalLength circleOfConfusion:coc];
	expected = 2828.827f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:5.6f focalLength:focalLength circleOfConfusion:coc];
	expected = 1414.614f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:8.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 1000.4f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:11.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 707.507f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:22.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 353.953f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in hyperfocal distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateHyperfocalDistanceForAperture:32.0f focalLength:focalLength circleOfConfusion:coc];
	expected = 250.4f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
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
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);

	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.617f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.476f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.371f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.271f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.204f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.145f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.316f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.758f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.556f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.417f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.295f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.217f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.151f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.515f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.82f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.588f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.435f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.304f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.222f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.154f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.596f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.843f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.6f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.442f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.307f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.224f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.154f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.667f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.862f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.61f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.447f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.309f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.225f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.155f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.724f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.877f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.617f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.451f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.311f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.226f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 0.156f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// ***********************
	focalLength = 50.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.914f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.836f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.773f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.701f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.592f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.479f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.323f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.496f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.085f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.788f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.472f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.049f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.66f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.193f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 8.17f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.906f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.098f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.319f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.386f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.623f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 2.809f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 11.228f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 8.971f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 7.653f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.375f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.137f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.121f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.099f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 16.026f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 11.792f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.615f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 7.673f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 5.953f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.532f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.378f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 23.472f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 15.335f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 11.905f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.056f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 6.757f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.979f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 3.623f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// ***********************
	focalLength = 400.0f;
	
	// -----------------------
	subjectDistance = 2.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.999f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.997f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.996f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.995f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.992f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.989f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 1.984f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 5.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.991f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.983f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.975f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.966f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.95f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.932f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 4.902f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 10.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.965f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.93f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.901f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.864f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.804f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.732f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 9.615f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 15.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.922f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.844f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.778f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.697f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.563f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.406f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 14.151f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 25.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.783f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.57f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.39f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 24.169f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 23.81f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 23.392f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 22.727f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	// -----------------------
	subjectDistance = 50.0f;
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:2.8f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 49.14f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:5.6f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 48.309f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:8.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 47.619f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:11.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 46.784f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:16.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 45.455f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:22.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 43.848f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
	
	result = [DepthOfFieldCalculator calculateNearLimitForAperture:32.0f focalLength:focalLength circleOfConfusion:coc subjectDistance:subjectDistance];
	expected = 41.667f;
	XCTAssertEqualWithAccuracy(result, expected, accuracy, 
							   @"Error in near distance calculation - expected %f got %f", expected, result);
}

@end
