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

import OSLog
import SwiftUI
import TipKit

/// Explains that dragging away from the focal length slider scrubs it more slowly.
struct FocalLengthScrubbingTip: Tip {
    var title: Text {
        Text(LocalizedStringResource("FOCAL_LENGTH_SCRUBBING_TIP_TITLE", comment: "Focal length scrubbing tip title"))
    }

    var message: Text? {
        Text(LocalizedStringResource("FOCAL_LENGTH_SCRUBBING_TIP", comment: "Focal length scrubbing tip message"))
    }
}

/// Explains that dragging away from the subject distance slider scrubs it more slowly.
struct DistanceScrubbingTip: Tip {
    var title: Text {
        Text(LocalizedStringResource("DISTANCE_SCRUBBING_TIP_TITLE", comment: "Distance scrubbing tip title"))
    }

    var message: Text? {
        Text(LocalizedStringResource("DISTANCE_SCRUBBING_TIP", comment: "Distance scrubbing tip message"))
    }
}

/// Explains that the camera and lens names open the camera bag.
struct CameraBagTip: Tip {
    var title: Text {
        Text(LocalizedStringResource("CAMERA_BAG_TIP_TITLE", comment: "Camera bag tip title"))
    }

    var message: Text? {
        Text(LocalizedStringResource("CAMERA_BAG_TIP", comment: "Camera bag tip message"))
    }
}

/// The tips that replace the MPCoachMarks onboarding.
enum OnboardingTips {
    /// A control on the calculator screen that a tip points to.
    enum Target: CaseIterable {
        /// Shown only for a zoom lens.
        case focalLengthSlider
        /// Shown for every distance type except the hyperfocal distance.
        case subjectDistanceSlider
        case settingsButton
    }

    /// Every onboarding tip, in the order they are shown.
    static let all = tips(for: Set(Target.allCases))

    /// The tips whose targets are in `targets`, in the order they are shown.
    static func tips(for targets: Set<Target>) -> [any Tip] {
        var tips: [any Tip] = []
        if targets.contains(.focalLengthSlider) {
            tips.append(FocalLengthScrubbingTip())
        }
        if targets.contains(.subjectDistanceSlider) {
            tips.append(DistanceScrubbingTip())
        }
        if targets.contains(.settingsButton) {
            tips.append(CameraBagTip())
        }
        return tips
    }

    /// A group that shows the tips for `targets` one at a time, each once the ones
    /// before it are closed or retired.
    ///
    /// The group is ordered rather than first-available because tips that become
    /// eligible together are not shown in a guaranteed order, so the camera bag tip
    /// could appear before the focal length tip. An ordered group waits for each tip in
    /// turn, so it holds only tips whose targets are on screen; a tip for a hidden
    /// target would never show and would hold back every tip after it.
    @MainActor
    static func makeGroup(for targets: Set<Target>) -> TipGroup {
        TipGroup(.ordered) { tips(for: targets) }
    }

    /// Starts TipKit, and retires every tip for a user who already saw the coach marks.
    ///
    /// - Parameters:
    ///   - datastoreURL: Where TipKit keeps its state, or `nil` for its default location.
    ///   - legacyCoachMarksShown: ``UserSettings/legacyCoachMarksShown``.
    static func configure(datastoreURL: URL?, legacyCoachMarksShown: Bool) {
        var options: [Tips.ConfigurationOption] = []
        if let datastoreURL {
            options.append(.datastoreLocation(.url(datastoreURL)))
        }
        do {
            try Tips.configure(options)
        } catch {
            tipsLogger.error("Tips could not be configured. \(error, privacy: .public)")
            return
        }
        if legacyCoachMarksShown {
            for tip in all {
                tip.invalidate(reason: .actionPerformed)
            }
        }
    }
}

private let tipsLogger = Logger(subsystem: "net.sourceforge.iphonefieldtools", category: "tips")
