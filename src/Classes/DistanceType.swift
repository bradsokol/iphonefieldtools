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

import Foundation

/// The distance calculation type selected by the segmented control.
///
/// The raw values are the integers the Objective-C app stored under the `DistanceType`
/// preference, so they must not be reordered.
public enum DistanceType: Int, CaseIterable, Sendable {
    case hyperfocal
    case near
    case far
    case nearFar

    /// Short title for the distance type picker.
    var title: LocalizedStringResource {
        switch self {
        case .hyperfocal: LocalizedStringResource("DISTANCE_TYPE_HYPERFOCAL", comment: "Hyperfocal distance segment")
        case .near: LocalizedStringResource("DISTANCE_TYPE_NEAR", comment: "Near limit segment")
        case .far: LocalizedStringResource("DISTANCE_TYPE_FAR", comment: "Far limit segment")
        case .nearFar: LocalizedStringResource("DISTANCE_TYPE_NEAR_FAR", comment: "Near and far limits segment")
        }
    }

    /// VoiceOver label for the result shown for this distance type.
    var resultAccessibilityLabel: LocalizedStringResource {
        switch self {
        case .hyperfocal: LocalizedStringResource("RESULT_HYPERFOCAL", comment: "Hyperfocal result label")
        case .near: LocalizedStringResource("RESULT_NEAR", comment: "Near limit result label")
        case .far: LocalizedStringResource("RESULT_FAR", comment: "Far limit result label")
        case .nearFar: LocalizedStringResource("RESULT_NEAR_FAR", comment: "Near and far result label")
        }
    }
}
