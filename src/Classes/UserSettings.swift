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
    }

    // MARK: - Storage

    private let defaults: UserDefaults

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
    }

    // MARK: - Properties

    /// Index into ``Aperture/values`` for the currently selected f-stop.
    public var apertureIndex: Int {
        get { defaults.integer(forKey: Key.apertureIndex) }
        set { defaults.set(newValue, forKey: Key.apertureIndex) }
    }

    /// Index of the currently selected camera in the sorted camera list.
    public var cameraIndex: Int {
        get { defaults.integer(forKey: Key.cameraIndex) }
        set { defaults.set(newValue, forKey: Key.cameraIndex) }
    }

    /// Distance calculation type (0 = hyperfocal, 1 = near/far).
    public var distanceType: Int {
        get { defaults.integer(forKey: Key.distanceType) }
        set { defaults.set(newValue, forKey: Key.distanceType) }
    }

    /// Distance display unit preference.
    public var distanceUnits: DistanceUnits {
        get { DistanceUnits(rawValue: defaults.integer(forKey: Key.distanceUnits)) ?? .feetAndInches }
        set { defaults.set(newValue.rawValue, forKey: Key.distanceUnits) }
    }

    /// Current focal length in millimetres.
    public var focalLength: Float {
        get { defaults.float(forKey: Key.focalLength) }
        set { defaults.set(newValue, forKey: Key.focalLength) }
    }

    /// Index of the currently selected lens in the sorted lens list.
    public var lensIndex: Int {
        get { defaults.integer(forKey: Key.lensIndex) }
        set { defaults.set(newValue, forKey: Key.lensIndex) }
    }

    /// Current subject distance in metres.
    public var subjectDistance: Float {
        get { defaults.float(forKey: Key.subjectDistance) }
        set { defaults.set(newValue, forKey: Key.subjectDistance) }
    }

    /// Subject distance range controlling slider bounds.
    public var subjectDistanceRange: SubjectDistanceRange {
        get { SubjectDistanceRange(rawValue: defaults.integer(forKey: Key.subjectDistanceRange)) ?? .mid }
        set { defaults.set(newValue.rawValue, forKey: Key.subjectDistanceRange) }
    }
}
