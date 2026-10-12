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
import Testing

@testable import Field_Tools

/// Range bounds for each subject distance range, and the slider step rounding that
/// replaced `LinearSubjectDistanceSliderPolicy`.
@Suite("Subject distance range")
struct SubjectDistanceRangeTests {

    // MARK: - Titles

    @Test(
        "Menu titles match the shipping range names",
        arguments: [
            (SubjectDistanceRange.macro, "Macro range"),
            (SubjectDistanceRange.close, "Close range"),
            (SubjectDistanceRange.mid, "Mid-range"),
            (SubjectDistanceRange.far, "Full range"),
        ]
    )
    func title(range: SubjectDistanceRange, expected: String) {
        #expect(String(localized: range.title) == expected)
    }

    // MARK: - Range bounds

    @Test("Far range metric bounds")
    func farMetricBounds() {
        #expect(SubjectDistanceRange.far.minimumDistance(metric: true) == 3.0)
        #expect(SubjectDistanceRange.far.maximumDistance(metric: true) == 500.0)
    }

    @Test("Far range imperial bounds")
    func farImperialBounds() {
        let min = SubjectDistanceRange.far.minimumDistance(metric: false)
        let max = SubjectDistanceRange.far.maximumDistance(metric: false)
        #expect(abs(min - 10.0 / DistanceFormatter.metresToFeet) < 0.001)
        #expect(abs(max - 2000.0 / DistanceFormatter.metresToFeet) < 0.01)
    }

    @Test("Macro range metric bounds")
    func macroMetricBounds() {
        #expect(SubjectDistanceRange.macro.minimumDistance(metric: true) == 0.01)
        #expect(SubjectDistanceRange.macro.maximumDistance(metric: true) == 1.0)
    }

    @Test("Close range metric bounds")
    func closeMetricBounds() {
        #expect(SubjectDistanceRange.close.minimumDistance(metric: true) == 0.1)
        #expect(SubjectDistanceRange.close.maximumDistance(metric: true) == 10.0)
    }

    @Test("Mid range metric bounds")
    func midMetricBounds() {
        #expect(SubjectDistanceRange.mid.minimumDistance(metric: true) == 0.2)
        #expect(SubjectDistanceRange.mid.maximumDistance(metric: true) == 80.0)
    }

    // MARK: - Slider step rounding (ported from LinearSubjectDistanceSliderPolicyTests)

    @Test(
        "Subject distance rounds to the slider step for each unit",
        arguments: [
            (DistanceUnits.meters, Float(2.0), Float(2.0), Float(0.0009)),
            (.meters, 2.1, 2.1, 0.0009),
            (.meters, 2.123, 2.12, 0.0009),
            (.meters, 2.126, 2.13, 0.0009),
            (.centimeters, 1.23, 1.23, 0.0009),
            (.centimeters, 1.234, 1.234, 0.0009),
            (.centimeters, 1.2345, 1.235, 0.0009),
            (.feet, 2.0, 2.01, 0.009),
            (.feet, 1.234, 1.22, 0.009),
            (.feet, 1.2345, 1.25, 0.009),
            (.feetAndInches, 2.0, 2.01, 0.009),
        ]
    )
    func sliderStepRounding(units: DistanceUnits, metres: Float, expected: Float, accuracy: Float) {
        let result = units.roundedToSliderStep(metres)
        #expect(abs(result - expected) <= accuracy, "Expected \(expected) ± \(accuracy), got \(result)")
    }
}
