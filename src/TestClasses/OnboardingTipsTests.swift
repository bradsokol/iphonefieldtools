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

@testable import Field_Tools
import Testing

/// TipKit keys each tip's saved state by its id, which defaults to the type name, so
/// renaming a tip type shows that tip again to everyone who already dismissed it.
@Suite("Onboarding Tips")
struct OnboardingTipsTests {

    @Test("Tips are shown in the order of the original coach marks, with stable ids")
    func idsAndOrder() {
        #expect(OnboardingTips.all.map(\.id) == [
            "FocalLengthScrubbingTip",
            "DistanceScrubbingTip",
            "CameraBagTip",
        ])
    }

    /// Targets on screen, and the tip ids the group should hold for them.
    private static let targetCases: [(Set<OnboardingTips.Target>, [String])] = [
        ([], []),
        ([.settingsButton], ["CameraBagTip"]),
        ([.focalLengthSlider, .settingsButton], ["FocalLengthScrubbingTip", "CameraBagTip"]),
        ([.subjectDistanceSlider, .settingsButton], ["DistanceScrubbingTip", "CameraBagTip"]),
        (
            [.settingsButton, .subjectDistanceSlider, .focalLengthSlider],
            ["FocalLengthScrubbingTip", "DistanceScrubbingTip", "CameraBagTip"]
        ),
    ]

    @Test(
        "Only tips whose targets are on screen join the group, in the original order",
        arguments: targetCases
    )
    func tipsForTargets(targets: Set<OnboardingTips.Target>, expected: [String]) {
        #expect(OnboardingTips.tips(for: targets).map(\.id) == expected)
    }
}
