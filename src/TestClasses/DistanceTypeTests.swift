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

@Suite("DistanceType Tests")
struct DistanceTypeTests {

    @Test(
        "Picker titles match the shipping segment titles",
        arguments: [
            (DistanceType.hyperfocal, "Hyper"),
            (DistanceType.near, "Near"),
            (DistanceType.far, "Far"),
            (DistanceType.nearFar, "Near+Far")
        ]
    )
    func title(type: DistanceType, expected: String) {
        #expect(String(localized: type.title) == expected)
    }

    @Test(
        "Result VoiceOver labels name each distance type",
        arguments: [
            (DistanceType.hyperfocal, "Hyperfocal distance"),
            (DistanceType.near, "Near limit"),
            (DistanceType.far, "Far limit"),
            (DistanceType.nearFar, "Depth of field")
        ]
    )
    func resultAccessibilityLabel(type: DistanceType, expected: String) {
        #expect(String(localized: type.resultAccessibilityLabel) == expected)
    }
}
