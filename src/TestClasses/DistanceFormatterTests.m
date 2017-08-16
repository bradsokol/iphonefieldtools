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
//  DistanceFormatterTests.m
//  FieldTools
//
//  Created by Brad on 2010/01/07.
//

#import <XCTest/XCTest.h>

#import "DistanceFormatter.h"
#import "DistanceRange.h"

@interface DistanceFormatterTests : XCTestCase
{
	DistanceFormatter* formatter;
}

@end

@implementation DistanceFormatterTests

- (void)setUp
{
	formatter = [[DistanceFormatter alloc] initForTest:YES];
}

- (void)testWholeMetres
{
	[formatter setDistanceUnits:DistanceUnitsMeters];
	NSString* expected = @"2 m";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:2.0f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

- (void)testFractionalMetres
{
	[formatter setDistanceUnits:DistanceUnitsMeters];
	NSString* expected = @"2.1 m";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:2.1f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

- (void)testFeetAndInchesRounding
{
	[formatter setDistanceUnits:DistanceUnitsFeetAndInches];
	NSString* expected = @"7'";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:2.13333344f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

// Test that 15", 15.25", 15.5" and 15.75" are displays as 15", 15 1/4", 15 1/2" and 15 3/4" respectively. 
- (void)testFractionalInches
{
	[formatter setDistanceUnits:DistanceUnitsFeetAndInches];
	NSString* expected = @"1'";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:0.3048f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);

	expected = @"1' 3\"";
	result = [formatter stringForObjectValue:[NSNumber numberWithFloat:0.381f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
	
	expected = @"1' 3¼\"";
	result = [formatter stringForObjectValue:[NSNumber numberWithFloat:0.38735f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
	
	expected = @"1' 3½\"";
	result = [formatter stringForObjectValue:[NSNumber numberWithFloat:0.3937f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
	
	expected = @"1' 3¾\"";
	result = [formatter stringForObjectValue:[NSNumber numberWithFloat:0.40005f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

- (void)testRangesWithFeetAndInches
{
	[formatter setDistanceUnits:DistanceUnitsFeetAndInches];

	DistanceRange* distanceRange = [[DistanceRange alloc] init];
	[distanceRange setNearDistance:1.647651f];
	[distanceRange setFarDistance:2.558037f];

	NSString* expected = @"5' 4¾\"\t3'\t8' 4¾\"";
	NSString* result = [formatter stringForObjectValue:distanceRange];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
	
}

- (void)testRangesSmallDistance
{
	[formatter setDistanceUnits:DistanceUnitsFeetAndInches];
	
	DistanceRange* distanceRange = [[DistanceRange alloc] init];
	[distanceRange setNearDistance:1.647651f];
	[distanceRange setFarDistance:2.558037f];
	
	NSString* expected = @"5' 4¾\"\t3'\t8' 4¾\"";
	NSString* result = [formatter stringForObjectValue:distanceRange];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
	
}

- (void)testZeroInchesWithFraction
{
	[formatter setDistanceUnits:DistanceUnitsFeetAndInches];
	NSString* expected = @"3' ¼\"";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:0.92f]];
	XCTAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

@end
