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

@Suite("UserSettings Tests")
struct UserSettingsTests {

    private func makeSettings() -> UserSettings {
        let name = "UserSettingsTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defer { UserDefaults.standard.removePersistentDomain(forName: name) }
        return UserSettings(defaults: defaults)
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

    // MARK: - Round-trip persistence

    @Test("Aperture index round-trip")
    func apertureIndexRoundTrip() {
        let settings = makeSettings()
        settings.apertureIndex = 5
        #expect(settings.apertureIndex == 5)
    }

    @Test("Distance units round-trip")
    func distanceUnitsRoundTrip() {
        let settings = makeSettings()
        settings.distanceUnits = .meters
        #expect(settings.distanceUnits == .meters)
    }

    @Test("Subject distance range round-trip")
    func subjectDistanceRangeRoundTrip() {
        let settings = makeSettings()
        settings.subjectDistanceRange = .macro
        #expect(settings.subjectDistanceRange == .macro)
    }

    @Test("Focal length round-trip")
    func focalLengthRoundTrip() {
        let settings = makeSettings()
        settings.focalLength = 85.0
        #expect(settings.focalLength == 85.0)
    }
}
