/*
 * Copyright 2009 Brad Sokol
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *  UserDefaults.h
 *  FieldTools
 *
 *  Created by Brad on 2008/11/14.
 *
 */

#define DEFAULTS_BASE_VERSION 2
//#define DEFAULTS_VERSION	  3

// Keys for user defaults
extern NSString* const FTDefaultsVersion;

extern NSString* const FTApertureIndex;
extern NSString* const FTCameraCount;
extern NSString* const FTCameraIndex;
extern NSString* const FTDistanceTypeKey;
extern NSString* const FTDistanceUnitsKey;
extern NSString* const FTFocalLengthKey;
extern NSString* const FTLensCount;
extern NSString* const FTLensIndex;
extern NSString* const FTSubjectDistanceKey;
extern NSString* const FTMacroModeKey;

extern NSString* const FTMigratedFrom10Key;
extern NSString* const FTMigratedFrom20Key;

// Deprecated
extern NSString* const FTMetricKey;				// Use FTUnitsKey

typedef enum _DistanceUnits
{
	DistanceUnitsFeet,
	DistanceUnitsFeetAndInches,
	DistanceUnitsMeters,
    DistanceUnitsCentimeters
} DistanceUnits;