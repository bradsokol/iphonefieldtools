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
//  GoogleAnalytics.h
//  FieldTools
//
//  Created by Brad Sokol on 2012-04-23.
//

#ifndef FieldTools_GoogleAnalytics_h
#define FieldTools_GoogleAnalytics_h

#import "GANTracker.h"

// Use a fake account ID for debug builds. During initialization of
// the analytics library, dry run mode is turned on so nothing is
// actually sent to Google. To build a release or distribution build,
// a separate header (not kept in source control) is required.
#ifdef DEBUG
#define kGANAccountId           @"UA-00000000-0"
#else
#import "FieldToolsGAAccountId.h"
#endif

#define kGANDispatchPeriodSec   10

// Page names for page view tracking

#define kDistanceTypeHyper      @"/HyperfocalView"
#define kDistanceTypeNear       @"/NearView"
#define kDistanceTypeFar        @"/FarView"
#define kDistanceTypeNearAndFar @"/NearAndFarView"

#define kUnitsCentimetres       @"/Centimetres"
#define kUnitsFeet              @"/Feet"
#define kUnitsFeetAndInches     @"/FeetAndInches"
#define kUnitsMetres            @"/Metres"

#define kSettings               @"/Settings"
#define kSettingsAddCamera      @"/Settings/AddCamera"
#define kSettingsEditCamera     @"/Settings/EditCamera"
#define kSettingsAddLens        @"/Settings/AddLens"
#define kSettingsEditLens       @"/Settings/EditLens"
#define kSettingsCoC            @"/Settings/CoC"
#define kSettingsCustomCoC      @"/Settings/CustomCoC"
#define kSettingsSubjectDistanceRanges @"/Settings/SubjectDistanceRanges"

// Event categories
#define kCategorySubjectDistanceRange   @"SubjectDistanceRange"
#define kCategoryCoC            @"CoC"

// Event actions
#define kActionChanged          @"Changed"

// Event labels
#define kLabelMainView          @"MainView"
#define kLabelSettingsView      @"SettingsView"

#endif
