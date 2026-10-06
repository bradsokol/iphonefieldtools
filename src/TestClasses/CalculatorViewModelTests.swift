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
