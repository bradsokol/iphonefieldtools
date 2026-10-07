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

import Testing

@testable import Field_Tools

@Suite("Distance formatting")
struct DistanceFormatterTests {

    @Test("Whole metres")
    func wholeMetres() {
        let formatter = DistanceFormatter(units: .meters)
        #expect(formatter.format(2.0) == "2 m")
    }

    @Test("Fractional metres")
    func fractionalMetres() {
        let formatter = DistanceFormatter(units: .meters)
        #expect(formatter.format(2.1) == "2.1 m")
    }

    @Test("Feet and inches rounding")
    func feetAndInchesRounding() {
        let formatter = DistanceFormatter(units: .feetAndInches)
        #expect(formatter.format(2.13333344) == "7'")
    }

    @Test("Fractional inches")
    func fractionalInches() {
        let formatter = DistanceFormatter(units: .feetAndInches)
        #expect(formatter.format(0.3048) == "1'")
        #expect(formatter.format(0.381) == "1' 3\"")
        #expect(formatter.format(0.38735) == "1' 3¼\"")
        #expect(formatter.format(0.3937) == "1' 3½\"")
        #expect(formatter.format(0.40005) == "1' 3¾\"")
    }

    @Test("Range with feet and inches")
    func rangesWithFeetAndInches() {
        let formatter = DistanceFormatter(units: .feetAndInches)
        let result = formatter.formatRange(near: 1.647651, far: 2.558037)
        #expect(result == "5' 4¾\"\t3'\t8' 4¾\"")
    }

    @Test("Zero inches with fraction")
    func zeroInchesWithFraction() {
        let formatter = DistanceFormatter(units: .feetAndInches)
        #expect(formatter.format(0.92) == "3' ¼\"")
    }

    @Test("Infinity for negative distance")
    func infinity() {
        let formatter = DistanceFormatter(units: .meters)
        #expect(formatter.format(-1.0) == "∞")
    }

    @Test("VoiceOver range names the near limit, far limit and depth of field")
    func accessibilityRange() {
        let formatter = DistanceFormatter(units: .meters)
        #expect(formatter.accessibilityRange(near: 1.5, far: 8)
            == "Near limit 1.5 m, far limit 8 m, depth of field 6.5 m")
    }

    @Test("VoiceOver range to infinity omits the depth of field")
    func accessibilityRangeToInfinity() {
        let formatter = DistanceFormatter(units: .meters)
        #expect(formatter.accessibilityRange(near: 1.5, far: -1) == "Near limit 1.5 m, far limit ∞")
    }
}
