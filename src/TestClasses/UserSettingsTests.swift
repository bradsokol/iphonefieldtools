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
import Synchronization
import Testing

@testable import Field_Tools

@Suite("UserSettings Tests")
struct UserSettingsTests {

    private func makeDefaults() -> UserDefaults {
        let name = "UserSettingsTests-\(UUID().uuidString)"
        UserDefaults.standard.removePersistentDomain(forName: name)
        return UserDefaults(suiteName: name)!
    }

    private func makeSettings() -> UserSettings {
        UserSettings(defaults: makeDefaults())
    }

    /// Whether setting a value through `mutate` notifies observers of the property read by `read`.
    private func notifiesObservers(
        _ read: @escaping (UserSettings) -> Void,
        when mutate: (UserSettings) -> Void
    ) -> Bool {
        let settings = makeSettings()
        let changed = Mutex(false)
        withObservationTracking {
            read(settings)
        } onChange: {
            changed.withLock { $0 = true }
        }
        mutate(settings)
        return changed.withLock { $0 }
    }

    // MARK: - Default values

    @Test("Default aperture index matches Aperture.defaultIndex")
    func defaultApertureIndex() {
        #expect(makeSettings().apertureIndex == Aperture.defaultIndex)
    }

    @Test("Default camera index is 0")
    func defaultCameraIndex() {
        #expect(makeSettings().cameraIndex == 0)
    }

    @Test("Default distance type is 0 (hyperfocal)")
    func defaultDistanceType() {
        #expect(makeSettings().distanceType == 0)
    }

    @Test("Default distance units is feet and inches")
    func defaultDistanceUnits() {
        #expect(makeSettings().distanceUnits == .feetAndInches)
    }

    @Test("Default focal length is 24mm")
    func defaultFocalLength() {
        #expect(makeSettings().focalLength == 24.0)
    }

    @Test("Default lens index is 0")
    func defaultLensIndex() {
        #expect(makeSettings().lensIndex == 0)
    }

    @Test("Default subject distance is 2.5m")
    func defaultSubjectDistance() {
        #expect(makeSettings().subjectDistance == 2.5)
    }

    @Test("Default subject distance range is mid")
    func defaultSubjectDistanceRange() {
        #expect(makeSettings().subjectDistanceRange == .mid)
    }

    // MARK: - Persistence

    @Test("Aperture index persists to defaults")
    func apertureIndexPersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).apertureIndex = 5
        #expect(UserSettings(defaults: defaults).apertureIndex == 5)
    }

    @Test("Camera index persists to defaults")
    func cameraIndexPersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).cameraIndex = 2
        #expect(UserSettings(defaults: defaults).cameraIndex == 2)
    }

    @Test("Distance type persists to defaults")
    func distanceTypePersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).distanceType = 3
        #expect(UserSettings(defaults: defaults).distanceType == 3)
    }

    @Test("Distance units persist to defaults")
    func distanceUnitsPersist() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).distanceUnits = .meters
        #expect(UserSettings(defaults: defaults).distanceUnits == .meters)
    }

    @Test("Focal length persists to defaults")
    func focalLengthPersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).focalLength = 85.0
        #expect(UserSettings(defaults: defaults).focalLength == 85.0)
    }

    @Test("Lens index persists to defaults")
    func lensIndexPersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).lensIndex = 4
        #expect(UserSettings(defaults: defaults).lensIndex == 4)
    }

    @Test("Subject distance persists to defaults")
    func subjectDistancePersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).subjectDistance = 7.5
        #expect(UserSettings(defaults: defaults).subjectDistance == 7.5)
    }

    @Test("Subject distance range persists to defaults")
    func subjectDistanceRangePersists() {
        let defaults = makeDefaults()
        UserSettings(defaults: defaults).subjectDistanceRange = .macro
        #expect(UserSettings(defaults: defaults).subjectDistanceRange == .macro)
    }

    // MARK: - Observation

    @Test("Changing the aperture index notifies observers")
    func apertureIndexIsObservable() {
        #expect(notifiesObservers({ _ = $0.apertureIndex }, when: { $0.apertureIndex = 5 }))
    }

    @Test("Changing the camera index notifies observers")
    func cameraIndexIsObservable() {
        #expect(notifiesObservers({ _ = $0.cameraIndex }, when: { $0.cameraIndex = 2 }))
    }

    @Test("Changing the distance type notifies observers")
    func distanceTypeIsObservable() {
        #expect(notifiesObservers({ _ = $0.distanceType }, when: { $0.distanceType = 3 }))
    }

    @Test("Changing the distance units notifies observers")
    func distanceUnitsIsObservable() {
        #expect(notifiesObservers({ _ = $0.distanceUnits }, when: { $0.distanceUnits = .meters }))
    }

    @Test("Changing the focal length notifies observers")
    func focalLengthIsObservable() {
        #expect(notifiesObservers({ _ = $0.focalLength }, when: { $0.focalLength = 85 }))
    }

    @Test("Changing the lens index notifies observers")
    func lensIndexIsObservable() {
        #expect(notifiesObservers({ _ = $0.lensIndex }, when: { $0.lensIndex = 4 }))
    }

    @Test("Changing the subject distance notifies observers")
    func subjectDistanceIsObservable() {
        #expect(notifiesObservers({ _ = $0.subjectDistance }, when: { $0.subjectDistance = 7.5 }))
    }

    @Test("Changing the subject distance range notifies observers")
    func subjectDistanceRangeIsObservable() {
        #expect(notifiesObservers({ _ = $0.subjectDistanceRange }, when: { $0.subjectDistanceRange = .macro }))
    }
}

/// Covers the one preference carried over purely as a signal to TipKit.
///
/// Getting this wrong fails silently: a wrong key or an accidental write shows the
/// replacement tips to every existing user, with no error to catch it.
@Suite("Legacy Coach Marks Flag")
struct LegacyCoachMarksFlagTests {

    /// The key the shipped Objective-C build actually wrote, spelled out so that renaming
    /// the constant cannot quietly change it.
    private static let storedKey = "CoachMarksShown"

    private func makeDefaults() -> UserDefaults {
        let name = "LegacyCoachMarksTests-\(UUID().uuidString)"
        UserDefaults.standard.removePersistentDomain(forName: name)
        return UserDefaults(suiteName: name)!
    }

    @Test("A fresh install, with the key absent, reports false")
    func absentKeyIsFalse() {
        let defaults = makeDefaults()
        #expect(defaults.object(forKey: Self.storedKey) == nil)
        #expect(UserSettings(defaults: defaults).legacyCoachMarksShown == false)
    }

    @Test("An install that saw the coach marks reports true")
    func upgradedUserIsTrue() {
        let defaults = makeDefaults()
        defaults.set(true, forKey: Self.storedKey)
        #expect(UserSettings(defaults: defaults).legacyCoachMarksShown)
    }

    @Test("The flag reads the key the Objective-C build wrote, not the constant's name")
    func readsTheShippedKey() {
        let defaults = makeDefaults()
        defaults.set(true, forKey: "FTCoachMarksShown")
        #expect(UserSettings(defaults: defaults).legacyCoachMarksShown == false)

        defaults.set(true, forKey: Self.storedKey)
        #expect(UserSettings(defaults: defaults).legacyCoachMarksShown)
    }

    @Test("Reading the flag never writes it, and initialising registers no default for it")
    func readingNeverWrites() {
        let defaults = makeDefaults()
        let settings = UserSettings(defaults: defaults)

        _ = settings.legacyCoachMarksShown
        _ = settings.legacyCoachMarksShown

        #expect(defaults.object(forKey: Self.storedKey) == nil)
    }
}
