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

/// View model for the depth of field calculator.
@MainActor @Observable
final class CalculatorViewModel {
    var settings: UserSettings
    var camera: Camera?
    var lens: Lens?

    init(settings: UserSettings) {
        self.settings = settings
    }

    // MARK: - Computed state

    /// Current aperture f-stop value.
    var aperture: Float {
        let index = min(settings.apertureIndex, Aperture.values.count - 1)
        return Aperture.values[index]
    }

    /// Formatted aperture string (e.g., "f/8" or "f/5.6").
    var apertureText: String {
        let value = aperture
        if value == value.rounded(.down) {
            return "f/\(Int(value))"
        }
        return "f/\(String(format: "%.1f", value))"
    }

    /// Circle of confusion for the selected camera, in millimetres.
    var circleOfConfusion: Float {
        camera?.coc?.value ?? 0.03
    }

    /// Whether the current unit system is metric.
    var isMetric: Bool {
        settings.distanceUnits == .meters || settings.distanceUnits == .centimeters
    }

    /// Minimum subject distance in metres for the current range.
    var subjectDistanceMinimum: Float {
        settings.subjectDistanceRange.minimumDistance(metric: isMetric)
    }

    /// Maximum subject distance in metres for the current range.
    var subjectDistanceMaximum: Float {
        settings.subjectDistanceRange.maximumDistance(metric: isMetric)
    }

    /// Formatted subject distance string.
    var subjectDistanceText: String {
        subjectDistanceFormatter.format(settings.subjectDistance)
    }

    /// Formatted focal length string.
    var focalLengthText: String {
        "\(Int(settings.focalLength)) mm"
    }

    /// Aperture slider range constrained by the selected lens.
    var apertureRange: ClosedRange<Float> {
        guard let lens else { return 0...Float(Aperture.values.count - 1) }
        let minIndex = Float(Aperture.nearestIndex(to: lens.maximumAperture))
        let maxIndex = Float(Aperture.nearestIndex(to: lens.minimumAperture))
        return minIndex...maxIndex
    }

    /// Focal length slider range from the selected lens.
    var focalLengthRange: ClosedRange<Float> {
        guard let lens else { return 1...1000 }
        return Float(lens.minimumFocalLength)...Float(lens.maximumFocalLength)
    }

    /// The selected lens is a prime (non-zoom) lens.
    var isPrimeLens: Bool {
        guard let lens else { return false }
        return !lens.isZoom
    }

    /// Description of the selected camera and lens.
    var cameraAndLensDescription: String {
        let cameraName = camera?.name ?? "No camera"
        let lensName = lens?.name ?? "No lens"
        return "\(cameraName) \u{2013} \(lensName)"
    }

    /// Subject distance range label for display.
    var subjectDistanceRangeLabel: String {
        switch settings.subjectDistanceRange {
        case .macro: NSLocalizedString("SUBJECT_DISTANCE_RANGE_0", comment: "Macro range")
        case .close: NSLocalizedString("SUBJECT_DISTANCE_RANGE_1", comment: "Close range")
        case .mid: NSLocalizedString("SUBJECT_DISTANCE_RANGE_2", comment: "Mid-range")
        case .far: NSLocalizedString("SUBJECT_DISTANCE_RANGE_3", comment: "Full range")
        }
    }

    /// Formatted minimum aperture label (widest, e.g. "f/1.4").
    var apertureMinLabel: String {
        guard let lens else { return "" }
        return formatAperture(lens.maximumAperture)
    }

    /// Formatted maximum aperture label (narrowest, e.g. "f/32").
    var apertureMaxLabel: String {
        guard let lens else { return "" }
        return formatAperture(lens.minimumAperture)
    }

    /// Formatted minimum subject distance label.
    var subjectDistanceMinLabel: String {
        DistanceFormatter(units: settings.distanceUnits, decimalPlaces: 0)
            .format(subjectDistanceMinimum)
    }

    /// Formatted maximum subject distance label.
    var subjectDistanceMaxLabel: String {
        DistanceFormatter(units: settings.distanceUnits, decimalPlaces: 0)
            .format(subjectDistanceMaximum)
    }

    // MARK: - Calculations

    /// Hyperfocal distance in metres.
    var hyperfocalDistance: Float {
        DepthOfFieldCalculator.hyperfocalDistance(
            aperture: aperture,
            focalLength: settings.focalLength,
            circleOfConfusion: circleOfConfusion
        )
    }

    /// Near limit in metres.
    var nearLimit: Float {
        DepthOfFieldCalculator.nearLimit(
            aperture: aperture,
            focalLength: settings.focalLength,
            circleOfConfusion: circleOfConfusion,
            subjectDistance: settings.subjectDistance
        )
    }

    /// Far limit in metres.
    var farLimit: Float {
        DepthOfFieldCalculator.farLimit(
            aperture: aperture,
            focalLength: settings.focalLength,
            circleOfConfusion: circleOfConfusion,
            subjectDistance: settings.subjectDistance
        )
    }

    // MARK: - Formatting

    /// Distance formatter configured for current units and range.
    var resultFormatter: DistanceFormatter {
        DistanceFormatter(units: settings.distanceUnits, decimalPlaces: resultDecimalPlaces)
    }

    // MARK: - Actions

    /// Updates the aperture index from a slider value, rounding to nearest integer.
    func updateApertureIndex(from sliderValue: Float) {
        settings.apertureIndex = Int(sliderValue + 0.5)
    }

    /// Updates the focal length from a slider value, rounding to nearest integer.
    func updateFocalLength(from sliderValue: Float) {
        settings.focalLength = (sliderValue + 0.5).rounded(.down)
    }

    /// Clamps subject distance to the current range bounds.
    func clampSubjectDistance() {
        if settings.subjectDistance < subjectDistanceMinimum {
            settings.subjectDistance = subjectDistanceMinimum
        } else if settings.subjectDistance > subjectDistanceMaximum {
            settings.subjectDistance = subjectDistanceMaximum
        }
    }

    /// When a new lens is selected, constrain focal length for prime lenses.
    func onLensChanged() {
        guard let lens else { return }
        if !lens.isZoom {
            settings.focalLength = Float(lens.minimumFocalLength)
        }
        let clampedIndex = min(max(settings.apertureIndex, Int(apertureRange.lowerBound)),
                               Int(apertureRange.upperBound))
        settings.apertureIndex = clampedIndex
    }

    // MARK: - Private

    private var resultDecimalPlaces: Int {
        let range = settings.subjectDistanceRange
        let units = settings.distanceUnits
        if units == .meters && (range == .close || range == .macro) {
            return 2
        }
        if units == .centimeters && range == .macro {
            return 1
        }
        return 0
    }

    private var subjectDistanceFormatter: DistanceFormatter {
        let range = settings.subjectDistanceRange
        let units = settings.distanceUnits
        var places = 0
        if units == .meters && (range == .close || range == .macro) {
            places = 2
        }
        return DistanceFormatter(units: units, decimalPlaces: places)
    }

    private func formatAperture(_ value: Float) -> String {
        if value == value.rounded(.down) {
            return "f/\(Int(value))"
        }
        return "f/\(String(format: "%.1f", value))"
    }
}
