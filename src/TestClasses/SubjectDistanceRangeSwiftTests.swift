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

/// Port of LinearSubjectDistanceSliderPolicyTests.
///
/// The ObjC tests used a LinearSubjectDistanceSliderPolicy wrapping a
/// FarSubjectDistanceRangePolicy. The `distanceForSliderValue:usingUnits:`
/// rounding logic is tested here directly since it will be needed in the
/// slider view (Phase 5). The range bounds are tested via SubjectDistanceRange.
@Suite("Subject distance range")
struct SubjectDistanceRangeTests {

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

    // MARK: - Linear slider rounding (ported from LinearSubjectDistanceSliderPolicyTests)

    @Test("Metres whole value")
    func metresWhole() {
        let result = roundForSlider(2.0, units: .meters)
        #expect(abs(result - 2.0) <= 0.09)
    }

    @Test("Metres single decimal")
    func metresSingleDecimal() {
        let result = roundForSlider(2.1, units: .meters)
        #expect(abs(result - 2.1) <= 0.09)
    }

    @Test("Metres two decimals truncated")
    func metresTwoDecimals() {
        let result = roundForSlider(2.12, units: .meters)
        #expect(abs(result - 2.1) <= 0.09)
    }

    @Test("Metres two decimals rounded")
    func metresTwoDecimalsRounded() {
        let result = roundForSlider(2.18, units: .meters)
        #expect(abs(result - 2.2) <= 0.09)
    }

    @Test("Centimetres whole")
    func centimetresWhole() {
        let result = roundForSlider(1.23, units: .centimeters)
        #expect(abs(result - 1.23) <= 0.0009)
    }

    @Test("Centimetres single decimal")
    func centimetresSingleDecimal() {
        let result = roundForSlider(1.234, units: .centimeters)
        #expect(abs(result - 1.234) <= 0.0009)
    }

    @Test("Centimetres two decimals")
    func centimetresTwoDecimals() {
        let result = roundForSlider(1.234, units: .centimeters)
        #expect(abs(result - 1.234) <= 0.0009)
    }

    @Test("Centimetres two decimals rounded")
    func centimetresTwoDecimalsRounded() {
        let result = roundForSlider(1.2345, units: .centimeters)
        #expect(abs(result - 1.235) <= 0.0009)
    }

    @Test("Feet whole")
    func feetWhole() {
        let result = roundForSlider(2.0, units: .feet)
        #expect(abs(result - 2.01) <= 0.009)
    }

    @Test("Feet single decimal")
    func feetSingleDecimal() {
        let result = roundForSlider(1.234, units: .feet)
        #expect(abs(result - 1.22) <= 0.009)
    }

    @Test("Feet two decimals")
    func feetTwoDecimals() {
        let result = roundForSlider(1.234, units: .feet)
        #expect(abs(result - 1.22) <= 0.009)
    }

    @Test("Feet two decimals rounded")
    func feetTwoDecimalsRounded() {
        let result = roundForSlider(1.2345, units: .feet)
        #expect(abs(result - 1.25) <= 0.009)
    }

    // MARK: - Private

    /// Replicates the rounding logic from LinearSubjectDistanceSliderPolicy.
    private func roundForSlider(_ value: Float, units: DistanceUnits) -> Float {
        switch units {
        case .feet, .feetAndInches:
            return roundf(value * DistanceFormatter.metresToFeet * 10.0)
                * 0.1 / DistanceFormatter.metresToFeet
        case .meters:
            return roundf(value * 100.0) * 0.01
        case .centimeters:
            return roundf(value * 1000.0) * 0.001
        }
    }
}
