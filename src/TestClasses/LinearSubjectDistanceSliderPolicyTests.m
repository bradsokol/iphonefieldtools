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
//  LinearSubjectDistanceSliderPolicyTests.m
//  FieldTools
//
//  Created by Brad Sokol on 2012-01-11.
//

#import <XCTest/XCTest.h>

#import "FarSubjectDistanceRangePolicy.h"
#import "LinearSubjectDistanceSliderPolicy.h"

@interface LinearSubjectDistanceSliderPolicyTests : XCTestCase
{
    FarSubjectDistanceRangePolicy* rangePolicy;
    LinearSubjectDistanceSliderPolicy* sliderPolicy;
}

@end

@implementation LinearSubjectDistanceSliderPolicyTests

- (void)setUp
{
    rangePolicy = [[FarSubjectDistanceRangePolicy alloc] init];
    sliderPolicy = [[LinearSubjectDistanceSliderPolicy alloc] initWithSubjectDistanceRangePolicy:rangePolicy];
}

// ----------- Metres 

- (void)testWholeMetres
{
    float expected = 2.0f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:2.0f usingUnits:DistanceUnitsMeters], expected, 0.09f, @"Slider policy test failure");
}

- (void)testMetresWithSingleDecimal
{
    float expected = 2.1f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:2.1f usingUnits:DistanceUnitsMeters], expected, 0.09f, @"Slider policy test failure");
}

- (void)testMetresWithTwoDecimals
{
    float expected = 2.1f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:2.12f usingUnits:DistanceUnitsMeters], expected, 0.09f, @"Slider policy test failure");
}

- (void)testMetresWithTwoDecimalsRounded
{
    float expected = 2.2f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:2.18f usingUnits:DistanceUnitsMeters], expected, 0.09f, @"Slider policy test failure");
}

// ----------- Centimetres 

- (void)testWholeCentimetres
{
    float expected = 1.23f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.23f usingUnits:DistanceUnitsCentimeters], expected, 0.0009f, @"Slider policy test failure");
}

- (void)testCentimetresWithSingleDecimal
{
    float expected = 1.234f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.234f usingUnits:DistanceUnitsCentimeters], expected, 0.0009f, @"Slider policy test failure");
}

- (void)testCentimetresWithTwoDecimals
{
    float expected = 1.234f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.234f usingUnits:DistanceUnitsCentimeters], expected, 0.0009f, @"Slider policy test failure");
}

- (void)testCentimetresWithTwoDecimalsRound
{
    float expected = 1.235f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.2345f usingUnits:DistanceUnitsCentimeters], expected, 0.0009f, @"Slider policy test failure");
}

// ----------- Feet 

- (void)testWholeFeet
{
    float expected = 2.01f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:2.0f usingUnits:DistanceUnitsFeet], expected, 0.009f, @"Slider policy test failure");
}

- (void)testFeetWithSingleDecimal
{
    float expected = 1.22f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.234f usingUnits:DistanceUnitsFeet], expected, 0.009f, @"Slider policy test failure");
}

- (void)testFeetWithTwoDecimals
{
    float expected = 1.22f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.234f usingUnits:DistanceUnitsFeet], expected, 0.009f, @"Slider policy test failure");
}

- (void)testFeetWithTwoDecimalsRound
{
    float expected = 1.25f;
    XCTAssertEqualWithAccuracy([sliderPolicy distanceForSliderValue:1.2345f usingUnits:DistanceUnitsFeet], expected, 0.009f, @"Slider policy test failure");
}

@end
