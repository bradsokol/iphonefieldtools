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

/// Units for displaying distances.
public enum DistanceUnits: Int, CaseIterable, Codable, Sendable {
    case feet
    case feetAndInches
    case meters
    case centimeters

    /// Rounds a distance in metres to the subject distance slider's step: a tenth of a
    /// foot, a centimetre, or a millimetre, depending on the units.
    public func roundedToSliderStep(_ metres: Float) -> Float {
        let metresToFeet = DistanceFormatter.metresToFeet
        switch self {
        case .feet, .feetAndInches:
            return (metres * metresToFeet * 10).rounded() * 0.1 / metresToFeet
        case .meters:
            return (metres * 100).rounded() * 0.01
        case .centimeters:
            return (metres * 1000).rounded() * 0.001
        }
    }
}

/// Formats distances (in metres) for display in the selected unit system.
public struct DistanceFormatter: Sendable {

    // MARK: - Constants

    static let metresToFeet: Float = 3.280839895
    static let metresToCentimetres: Float = 100.0

    // MARK: - Configuration

    public var units: DistanceUnits
    public var decimalPlaces: Int

    // MARK: - Init

    public init(units: DistanceUnits = .meters, decimalPlaces: Int = 0) {
        self.units = units
        self.decimalPlaces = min(decimalPlaces, 2)
    }

    // MARK: - Single distance

    /// Formats a distance in metres for display.
    ///
    /// - Parameter distance: Distance in metres. Negative values produce "∞".
    /// - Returns: A localised, human-readable string.
    public func format(_ distance: Float) -> String {
        if distance < 0 {
            return "∞"
        }

        switch units {
        case .feet:
            let converted = distance * Self.metresToFeet
            return "\(localizedNumber(converted)) \(feetAbbreviation)"

        case .feetAndInches:
            return formatFeetAndInches(distance * Self.metresToFeet)

        case .meters:
            return "\(localizedNumber(distance)) \(metresAbbreviation)"

        case .centimeters:
            let converted = distance * Self.metresToCentimetres
            return "\(localizedNumber(converted)) \(centimetresAbbreviation)"
        }
    }

    // MARK: - Range

    /// Formats a near/far distance range as a tab-separated string: near, difference, far.
    ///
    /// - Parameters:
    ///   - near: Near distance in metres.
    ///   - far: Far distance in metres.
    /// - Returns: Tab-separated formatted string.
    public func formatRange(near: Float, far: Float) -> String {
        "\(format(near))\t\(format(far - near))\t\(format(far))"
    }

    /// Describes a near/far range for VoiceOver, naming each value.
    ///
    /// The depth of field is omitted when the far limit is at infinity, as it is on screen.
    ///
    /// - Parameters:
    ///   - near: Near distance in metres.
    ///   - far: Far distance in metres, or a negative value for infinity.
    /// - Returns: A localised description such as "Near limit 4.9 ft, far limit 26.2 ft,
    ///   depth of field 21.4 ft".
    public func accessibilityRange(near: Float, far: Float) -> String {
        let difference = far - near
        guard difference > 0 else {
            let template = NSLocalizedString(
                "RESULT_RANGE_VALUE_TO_INFINITY",
                comment: "VoiceOver value for a near limit and a far limit at infinity"
            )
            return String(format: template, format(near), format(far))
        }
        let template = NSLocalizedString(
            "RESULT_RANGE_VALUE",
            comment: "VoiceOver value for the near limit, far limit and depth of field"
        )
        return String(format: template, format(near), format(far), format(difference))
    }

    // MARK: - Unit conversion

    /// Converts a distance in metres to the specified unit.
    public static func convert(_ distance: Float, to units: DistanceUnits) -> Float {
        switch units {
        case .meters:
            return distance
        case .centimeters:
            return distance * metresToCentimetres
        case .feet, .feetAndInches:
            return distance * metresToFeet
        }
    }

    // MARK: - Private

    private var feetAbbreviation: String {
        NSLocalizedString("FEET_ABBREVIATION", comment: "Abbreviation for feet")
    }

    private var metresAbbreviation: String {
        NSLocalizedString("METRES_ABBREVIATION", comment: "Abbreviation for metres")
    }

    private var centimetresAbbreviation: String {
        NSLocalizedString("CENTIMETRES_ABBREVIATION", comment: "Abbreviation for centimetres")
    }

    private func localizedNumber(_ value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        switch decimalPlaces {
        case 0:
            formatter.positiveFormat = "#,##0.#"
        case 1:
            formatter.positiveFormat = "#,##0.0"
        default:
            formatter.positiveFormat = "#,##0.00"
        }

        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatFeetAndInches(_ distanceInFeet: Float) -> String {
        var feet = floor(distanceInFeet)
        var inches = floor((12.0 * (distanceInFeet - feet) + 0.125) * 100.0) / 100.0

        if inches >= 12.0 {
            feet += 1.0
            inches -= 12.0
        }

        if feet == 0.0 {
            return formatInches(inches)
        } else if inches <= 0.125 {
            return "\(Int(feet))'"
        } else if inches > 11.875 {
            feet += 1.0
            return "\(Int(feet))'"
        } else {
            return "\(Int(feet))' \(formatInches(inches))"
        }
    }

    private func formatInches(_ inches: Float) -> String {
        let quarters = Int(inches / 0.25)
        let fraction: String
        switch quarters % 4 {
        case 1: fraction = "¼"
        case 2: fraction = "½"
        case 3: fraction = "¾"
        default: fraction = ""
        }

        if floor(inches) < 0.5 {
            return "\(fraction)\""
        } else {
            return "\(Int(floor(inches)))\(fraction)\""
        }
    }
}
