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
import Observation

/// Centralised access to all user preferences stored in `UserDefaults`.
///
/// Key strings match the existing Objective-C constants so that preferences
/// survive the migration. Inject this as an environment object in SwiftUI.
@Observable
public final class UserSettings {

    // MARK: - UserDefaults key strings

    private enum Key {
        static let apertureIndex = "ApertureIndex"
        static let cameraIndex = "CameraIndex"
        static let distanceType = "DistanceType"
        static let distanceUnits = "DistanceUnits"
        static let focalLength = "FocalLength"
        static let lensIndex = "LensIndex"
        static let subjectDistance = "SubjectDistance"
        static let subjectDistanceRange = "SubjectDistanceRange"

        /// Written only by the removed MPCoachMarks code. The Objective-C constant was
        /// named `FTCoachMarksShown`; the stored key it held is this string, and the two
        /// must not be confused.
        static let legacyCoachMarksShown = "CoachMarksShown"
    }

    // MARK: - Storage

    @ObservationIgnored private let defaults: UserDefaults

    // MARK: - Init

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Key.apertureIndex: Aperture.defaultIndex,
            Key.cameraIndex: 0,
            Key.distanceType: 0,
            Key.distanceUnits: DistanceUnits.feetAndInches.rawValue,
            Key.focalLength: Float(24.0),
            Key.lensIndex: 0,
            Key.subjectDistance: Float(2.5),
            Key.subjectDistanceRange: SubjectDistanceRange.mid.rawValue,
        ])

        apertureIndex = defaults.integer(forKey: Key.apertureIndex)
        cameraIndex = defaults.integer(forKey: Key.cameraIndex)
        distanceType = defaults.integer(forKey: Key.distanceType)
        distanceUnits = DistanceUnits(rawValue: defaults.integer(forKey: Key.distanceUnits)) ?? .feetAndInches
        focalLength = defaults.float(forKey: Key.focalLength)
        lensIndex = defaults.integer(forKey: Key.lensIndex)
        subjectDistance = defaults.float(forKey: Key.subjectDistance)
        subjectDistanceRange = SubjectDistanceRange(
            rawValue: defaults.integer(forKey: Key.subjectDistanceRange)
        ) ?? .mid
    }

    // MARK: - Properties

    /// Index into ``Aperture/values`` for the currently selected f-stop.
    public var apertureIndex: Int {
        didSet { defaults.set(apertureIndex, forKey: Key.apertureIndex) }
    }

    /// Index of the currently selected camera in the sorted camera list.
    public var cameraIndex: Int {
        didSet { defaults.set(cameraIndex, forKey: Key.cameraIndex) }
    }

    /// Distance calculation type (0 = hyperfocal, 1 = near/far).
    public var distanceType: Int {
        didSet { defaults.set(distanceType, forKey: Key.distanceType) }
    }

    /// Distance display unit preference.
    public var distanceUnits: DistanceUnits {
        didSet { defaults.set(distanceUnits.rawValue, forKey: Key.distanceUnits) }
    }

    /// Current focal length in millimetres.
    public var focalLength: Float {
        didSet { defaults.set(focalLength, forKey: Key.focalLength) }
    }

    /// Index of the currently selected lens in the sorted lens list.
    public var lensIndex: Int {
        didSet { defaults.set(lensIndex, forKey: Key.lensIndex) }
    }

    /// Current subject distance in metres.
    public var subjectDistance: Float {
        didSet { defaults.set(subjectDistance, forKey: Key.subjectDistance) }
    }

    /// Subject distance range controlling slider bounds.
    public var subjectDistanceRange: SubjectDistanceRange {
        didSet { defaults.set(subjectDistanceRange.rawValue, forKey: Key.subjectDistanceRange) }
    }

    /// Whether this install saw the MPCoachMarks onboarding that TipKit replaces.
    ///
    /// Deliberately read-only. TipKit owns tip display state — display counts, rule
    /// evaluation, invalidation — and a writable flag here would be a second source of
    /// truth that drifts from TipKit's. The one thing TipKit cannot know for itself is
    /// that a user already saw the *old* onboarding, because its datastore is empty on
    /// upgrade. This answers only that question.
    ///
    /// Every writer was removed with MPCoachMarks, which is what makes the value
    /// trustworthy: `true` means an existing user saw the coach marks, and a missing key
    /// means a fresh install. Writing to it again would destroy that property.
    ///
    /// Expires once the install base has moved past the TipKit release. At that point
    /// this property, its key, and its read site in the tip configuration should all be
    /// deleted together.
    public var legacyCoachMarksShown: Bool {
        defaults.bool(forKey: Key.legacyCoachMarksShown)
    }
}
