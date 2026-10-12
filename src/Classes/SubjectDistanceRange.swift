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

/// Subject distance ranges that control the slider bounds in the calculator.
///
/// Each case defines metric and imperial minimum/maximum distances.
/// All distances are in **metres** (imperial values are converted internally).
public enum SubjectDistanceRange: Int, CaseIterable, Codable, Sendable {
    case macro
    case close
    case mid
    case far

    /// Name shown on the range menu and in its list of choices.
    public var title: LocalizedStringResource {
        switch self {
        case .macro: LocalizedStringResource("SUBJECT_DISTANCE_RANGE_0", comment: "Macro range")
        case .close: LocalizedStringResource("SUBJECT_DISTANCE_RANGE_1", comment: "Close range")
        case .mid: LocalizedStringResource("SUBJECT_DISTANCE_RANGE_2", comment: "Mid-range")
        case .far: LocalizedStringResource("SUBJECT_DISTANCE_RANGE_3", comment: "Full range")
        }
    }

    // MARK: - Distance bounds

    /// Minimum subject distance in metres.
    public func minimumDistance(metric: Bool) -> Float {
        metric ? metricMin : imperialMin / DistanceFormatter.metresToFeet
    }

    /// Maximum subject distance in metres.
    public func maximumDistance(metric: Bool) -> Float {
        metric ? metricMax : imperialMax / DistanceFormatter.metresToFeet
    }

    // MARK: - Private constants

    private var metricMin: Float {
        switch self {
        case .macro: 0.01
        case .close: 0.1
        case .mid:   0.2
        case .far:   3.0
        }
    }

    private var metricMax: Float {
        switch self {
        case .macro: 1.0
        case .close: 10.0
        case .mid:   80.0
        case .far:   500.0
        }
    }

    private var imperialMin: Float {
        switch self {
        case .macro: 1.0 / 12.0
        case .close: 4.0 / 12.0
        case .mid:   1.0
        case .far:   10.0
        }
    }

    private var imperialMax: Float {
        switch self {
        case .macro: 3.0
        case .close: 30.0
        case .mid:   275.0
        case .far:   2000.0
        }
    }
}
