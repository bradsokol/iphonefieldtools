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
///
/// Eligible only while the slider is on screen, which is only for a zoom lens.
struct FocalLengthScrubbingTip: Tip {
    /// Whether the focal length slider is on screen.
    @Parameter(.transient) static var isSliderShown: Bool = false

    var title: Text {
        Text(LocalizedStringResource("FOCAL_LENGTH_SCRUBBING_TIP_TITLE", comment: "Focal length scrubbing tip title"))
    }

    var message: Text? {
        Text(LocalizedStringResource("FOCAL_LENGTH_SCRUBBING_TIP", comment: "Focal length scrubbing tip message"))
    }

    var rules: [Rule] {
        #Rule(Self.$isSliderShown) { $0 }
    }
}

/// Explains that dragging away from the subject distance slider scrubs it more slowly.
///
/// Eligible only while the slider is on screen, which is not for the hyperfocal distance.
struct DistanceScrubbingTip: Tip {
    /// Whether the subject distance slider is on screen.
    @Parameter(.transient) static var isSliderShown: Bool = false

    var title: Text {
        Text(LocalizedStringResource("DISTANCE_SCRUBBING_TIP_TITLE", comment: "Distance scrubbing tip title"))
    }

    var message: Text? {
        Text(LocalizedStringResource("DISTANCE_SCRUBBING_TIP", comment: "Distance scrubbing tip message"))
    }

    var rules: [Rule] {
        #Rule(Self.$isSliderShown) { $0 }
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
    /// Every onboarding tip, in the order they are shown.
    static let all: [any Tip] = [
        FocalLengthScrubbingTip(),
        DistanceScrubbingTip(),
        CameraBagTip(),
    ]

    /// A group that shows the first eligible onboarding tip, one at a time.
    @MainActor
    static func makeGroup() -> TipGroup {
        TipGroup(.firstAvailable) { all }
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
