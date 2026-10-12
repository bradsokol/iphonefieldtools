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

@MainActor
@Suite("CalculatorViewModel focal length")
final class CalculatorViewModelFocalLengthTests {
    private let suiteName = "CalculatorViewModelTests-\(UUID().uuidString)"

    deinit {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    private func makeViewModel(lens: Lens?, focalLength: Float = 24) throws -> CalculatorViewModel {
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        let settings = UserSettings(defaults: defaults)
        settings.focalLength = focalLength
        let viewModel = CalculatorViewModel(settings: settings)
        viewModel.lens = lens
        return viewModel
    }

    private func makeLens(minimum: Int, maximum: Int) -> Lens {
        let lens = Lens(name: "Test")
        lens.minimumFocalLength = minimum
        lens.maximumFocalLength = maximum
        return lens
    }

    // MARK: - Slider visibility

    @Test("Zoom lens shows the focal length slider")
    func zoomShowsSlider() throws {
        let viewModel = try makeViewModel(lens: makeLens(minimum: 24, maximum: 120))
        #expect(viewModel.showsFocalLengthSlider)
    }

    @Test("Prime lens hides the focal length slider")
    func primeHidesSlider() throws {
        let viewModel = try makeViewModel(lens: makeLens(minimum: 50, maximum: 50))
        #expect(!viewModel.showsFocalLengthSlider)
    }

    @Test("No selected lens hides the focal length slider")
    func noLensHidesSlider() throws {
        let viewModel = try makeViewModel(lens: nil)
        #expect(!viewModel.showsFocalLengthSlider)
    }

    // MARK: - Range labels

    @Test("Range labels show the lens focal length limits")
    func rangeLabels() throws {
        let viewModel = try makeViewModel(lens: makeLens(minimum: 24, maximum: 120))
        #expect(viewModel.focalLengthMinLabel == "24 mm")
        #expect(viewModel.focalLengthMaxLabel == "120 mm")
    }

    // MARK: - Lens change

    @Test(
        "Changing lens clamps focal length into the lens range",
        arguments: [
            (minimum: 70, maximum: 200, current: Float(24), expected: Float(70)),
            (minimum: 24, maximum: 70, current: Float(200), expected: Float(70)),
            (minimum: 24, maximum: 120, current: Float(50), expected: Float(50)),
            (minimum: 85, maximum: 85, current: Float(24), expected: Float(85))
        ]
    )
    func lensChangeClampsFocalLength(
        minimum: Int, maximum: Int, current: Float, expected: Float
    ) throws {
        let viewModel = try makeViewModel(lens: makeLens(minimum: minimum, maximum: maximum),
                                          focalLength: current)
        viewModel.onLensChanged()
        #expect(viewModel.settings.focalLength == expected)
    }
}

/// Pins the Near+Far result to the Objective-C app's output for the sample camera and
/// lens (24 mm, f/8, CoC 0.02 mm).
///
/// Each case is one where the displayed result changes unless the subject distance is
/// snapped to the slider's step and the limits are rounded before the difference is taken.
@MainActor
@Suite("CalculatorViewModel Near+Far result")
final class CalculatorViewModelRangeTests {
    private let suiteName = "CalculatorViewModelRangeTests-\(UUID().uuidString)"

    deinit {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    private func makeViewModel(
        units: DistanceUnits,
        range: SubjectDistanceRange,
        subjectDistance: Float
    ) throws -> CalculatorViewModel {
        try makeSampleViewModel(suiteName: suiteName, units: units, range: range, subjectDistance: subjectDistance)
    }

    private func displayedResult(of viewModel: CalculatorViewModel) -> [String] {
        let formatter = viewModel.resultFormatter
        let near = viewModel.rangeNearLimit
        let far = viewModel.rangeFarLimit
        return [formatter.format(near), formatter.format(far - near), formatter.format(far)]
    }

    @Test(
        "Near, depth of field and far match the Objective-C app",
        arguments: [
            (DistanceUnits.feet, SubjectDistanceRange.mid, Float(2.5), ["4.9 ft", "21.4 ft", "26.2 ft"]),
            (.feet, .mid, 1.1, ["2.8 ft", "2.3 ft", "5.1 ft"]),
            (.feetAndInches, .mid, 1.0, ["2' 7\"", "1' 11½\"", "4' 6½\""]),
            (.meters, .mid, 1.1, ["0.8 m", "0.8 m", "1.6 m"]),
            (.meters, .close, 0.5, ["0.44 m", "0.14 m", "0.58 m"]),
            (.centimeters, .macro, 0.103, ["10.1 cm", "0.4 cm", "10.5 cm"]),
            (.centimeters, .mid, 1.0, ["79 cm", "58 cm", "137 cm"]),
        ]
    )
    func matchesObjectiveC(
        units: DistanceUnits,
        range: SubjectDistanceRange,
        subjectDistance: Float,
        expected: [String]
    ) throws {
        let viewModel = try makeViewModel(units: units, range: range, subjectDistance: subjectDistance)
        #expect(displayedResult(of: viewModel) == expected)
    }

    @Test("A far limit at infinity is not rounded")
    func infiniteFarLimit() throws {
        let viewModel = try makeViewModel(units: .meters, range: .mid, subjectDistance: 5)
        #expect(viewModel.rangeFarLimit < 0)
        #expect(viewModel.resultFormatter.format(viewModel.rangeFarLimit) == "∞")
    }
}

/// Pins the single Hyper, Near and Far results to the Objective-C app's output for the
/// sample camera and lens (24 mm, f/8, CoC 0.02 mm).
///
/// One difference is deliberate. In centimetres with the macro range the Swift app always
/// shows tenths, which is what the Objective-C `shouldShowTenths` intended; the Objective-C
/// app overwrote that setting for single results, so a whole number showed as "10 cm"
/// rather than "10.0 cm".
@MainActor
@Suite("CalculatorViewModel single results")
final class CalculatorViewModelSingleResultTests {
    private let suiteName = "CalculatorViewModelSingleResultTests-\(UUID().uuidString)"

    deinit {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    private func displayedResults(
        units: DistanceUnits,
        range: SubjectDistanceRange,
        subjectDistance: Float
    ) throws -> [String] {
        let viewModel = try makeSampleViewModel(
            suiteName: suiteName, units: units, range: range, subjectDistance: subjectDistance
        )
        let formatter = viewModel.resultFormatter
        return [
            formatter.format(viewModel.hyperfocalDistance),
            formatter.format(viewModel.nearLimit),
            formatter.format(viewModel.farLimit),
        ]
    }

    @Test(
        "Hyperfocal, near and far match the Objective-C app",
        arguments: [
            (DistanceUnits.feet, SubjectDistanceRange.mid, Float(2.5), ["11.9 ft", "4.9 ft", "26.2 ft"]),
            (.feetAndInches, .mid, 1.0, ["11' 10¾\"", "2' 7\"", "4' 6½\""]),
            (.meters, .mid, 1.1, ["3.6 m", "0.8 m", "1.6 m"]),
            (.meters, .close, 0.5, ["3.62 m", "0.44 m", "0.58 m"]),
            (.meters, .mid, 5.0, ["3.6 m", "2.1 m", "∞"]),
            (.centimeters, .mid, 1.0, ["362.4 cm", "78.7 cm", "137.2 cm"]),
            (.centimeters, .macro, 0.103, ["362.4 cm", "10.1 cm", "10.5 cm"]),
        ]
    )
    func matchesObjectiveC(
        units: DistanceUnits,
        range: SubjectDistanceRange,
        subjectDistance: Float,
        expected: [String]
    ) throws {
        #expect(try displayedResults(units: units, range: range, subjectDistance: subjectDistance) == expected)
    }

    @Test("Centimetres in the macro range always show tenths, unlike the Objective-C app")
    func macroCentimetresShowTenths() throws {
        let results = try displayedResults(units: .centimeters, range: .macro, subjectDistance: 0.102)
        #expect(results[1] == "10.0 cm")
    }
}

@Suite("CalculatorViewModel locale formatting")
struct CalculatorViewModelLocaleTests {

    @Test(
        "Apertures use the locale's decimal separator and drop a whole number's decimal",
        arguments: [
            (Float(8), "en_US", "f/8"),
            (5.6, "en_US", "f/5.6"),
            (5.6, "de_DE", "f/5,6"),
            (1.4, "fr_FR", "f/1,4"),
            (22, "de_DE", "f/22"),
        ]
    )
    func formatsAperture(value: Float, localeIdentifier: String, expected: String) {
        let locale = Locale(identifier: localeIdentifier)
        #expect(CalculatorViewModel.formatAperture(value, locale: locale) == expected)
    }

    @Test(
        "Focal lengths use the locale's number format with the millimetre symbol",
        arguments: [
            (24, "en_US", "24 mm"),
            (24, "de_DE", "24 mm"),
            (1000, "en_US", "1,000 mm"),
            (1000, "de_DE", "1.000 mm"),
        ]
    )
    func formatsFocalLength(millimetres: Int, localeIdentifier: String, expected: String) {
        let locale = Locale(identifier: localeIdentifier)
        #expect(CalculatorViewModel.formatFocalLength(millimetres, locale: locale) == expected)
    }

    @MainActor
    @Test("With nothing selected, the footer shows the catalog placeholders, not their keys")
    func noSelectionUsesLocalisedPlaceholders() throws {
        let suiteName = "CalculatorViewModelLocaleTests-\(UUID().uuidString)"
        defer { UserDefaults.standard.removePersistentDomain(forName: suiteName) }
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        let viewModel = CalculatorViewModel(settings: UserSettings(defaults: defaults))

        #expect(viewModel.cameraAndLensDescription == "No camera \u{2013} No lens")
    }
}

/// The sample camera and lens at f/8, with the given units, range and subject distance.
@MainActor
private func makeSampleViewModel(
    suiteName: String,
    units: DistanceUnits,
    range: SubjectDistanceRange,
    subjectDistance: Float
) throws -> CalculatorViewModel {
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    let settings = UserSettings(defaults: defaults)
    settings.focalLength = 24
    settings.apertureIndex = try #require(Aperture.values.firstIndex(of: 8))
    settings.distanceUnits = units
    settings.subjectDistanceRange = range
    settings.subjectDistance = subjectDistance
    let camera = Camera(name: "Sample")
    camera.coc = CoC(name: "Sample CoC", value: 0.02)
    let viewModel = CalculatorViewModel(settings: settings)
    viewModel.camera = camera
    return viewModel
}
