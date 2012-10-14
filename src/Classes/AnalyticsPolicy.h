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
//  AnalyticsPolicy.h
//  FieldTools
//
//  Created by Brad on 2012-10-14.
//
//

#ifndef FieldTools_AnalyticsPolicy_h
#define FieldTools_AnalyticsPolicy_h

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

@protocol AnalyticsPolicy <NSObject>

// Track display of a view. Returns YES on success or NO on error.
// set to the specific error, or nil).
- (BOOL)trackView:(NSString *)viewName;

// Track an event. The category and action are required. The label and
// value are optional (specify nil for no label and -1 or any negative integer
// for no value). Returns YES on success or NO on error.
- (BOOL)trackEvent:(NSString *)category
            action:(NSString *)action
             label:(NSString *)label
             value:(NSInteger)value;

@property BOOL debug;

@end

#endif
