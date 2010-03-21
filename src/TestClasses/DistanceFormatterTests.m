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

#import <SenTestingKit/SenTestingKit.h>

#import "DistanceFormatter.h"

@interface DistanceFormatterTests : SenTestCase
{
	DistanceFormatter* formatter;
}

@end

@implementation DistanceFormatterTests

- (void)setUp
{
	formatter = [[DistanceFormatter alloc] initForTest:YES];
	printf("*************** %s\n", getwd(NULL));
}

- (void)testWholeMetres
{
	[formatter setDistanceUnits:DistanceUnitsMeters];
	NSString* expected = @"2.0 m";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:2.0f]];
	STAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

- (void)testFractionalMetres
{
	[formatter setDistanceUnits:DistanceUnitsMeters];
	NSString* expected = @"2.1 m";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:2.1f]];
	STAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

- (void)testFeetAndInchesRounding
{
	[formatter setDistanceUnits:DistanceUnitsFeetAndInches];
	NSString* expected = @"7'";
	NSString* result = [formatter stringForObjectValue:[NSNumber numberWithFloat:2.13333344f]];
	STAssertEqualObjects(result, expected, @"Formatted value mismatch. Expected \"%@\" got \"%@\"", expected, result);
}

@end
