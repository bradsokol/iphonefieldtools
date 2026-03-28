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

/// Pure value-type depth of field calculator.
///
/// All distances are in **metres**. Focal length is in **millimetres**.
/// A negative return value from ``farLimit(aperture:focalLength:circleOfConfusion:subjectDistance:)``
/// indicates infinity (the far limit exceeds the hyperfocal distance).
public struct DepthOfFieldCalculator {

    // MARK: - True Apertures

    /// Maps displayed (rounded) f-stop values to their true mathematical values
    /// based on the third-stop scale (powers of √2).
    static let trueApertures: [Float: Float] = [
        1.0: 1.0,
        1.1: 1.122462,
        1.2: 1.189207,
        1.4: 1.414214,
        1.6: 1.587401,
        1.8: 1.781797,
        2.0: 2.0,
        2.2: 2.244924,
        2.5: 2.519842,
        2.8: 2.828427,
        3.2: 3.174802,
        3.5: 3.563595,
        4.0: 4.0,
        4.5: 4.489848,
        5.0: 5.039684,
        5.6: 5.656854,
        6.3: 6.349604,
        7.1: 7.127190,
        8.0: 8.0,
        9.0: 8.979696,
        10.0: 10.07937,
        11.0: 11.313708,
        13.0: 12.699208,
        14.0: 14.254382,
        16.0: 16.0,
        18.0: 17.959393,
        20.0: 20.158737,
        22.0: 22.627417,
        25.0: 25.398417,
        28.0: 28.508759,
        32.0: 32.0,
        45.0: 45.254834,
        51.0: 50.796831,
        57.0: 53.817365,
        64.0: 64.0,
        72.0: 71.837568,
        81.0: 80.634927,
        91.0: 90.509668,
        100.0: 101.593663,
    ]

    // MARK: - Calculations

    /// Hyperfocal distance: `H = (f² / (N·c)) + f`, converted to metres.
    ///
    /// - Parameters:
    ///   - aperture: Displayed f-stop value (looked up in ``trueApertures``).
    ///   - focalLength: Focal length in millimetres.
    ///   - circleOfConfusion: Circle of confusion in millimetres.
    /// - Returns: Hyperfocal distance in metres.
    public static func hyperfocalDistance(
        aperture: Float,
        focalLength: Float,
        circleOfConfusion: Float
    ) -> Float {
        let n = trueAperture(aperture)
        return ((focalLength * focalLength) / (n * circleOfConfusion) + focalLength) / 1000.0
    }

    /// Near limit of depth of field: `Dn = s(H - f) / (H + s - 2f)`, in metres.
    ///
    /// - Parameters:
    ///   - aperture: Displayed f-stop value.
    ///   - focalLength: Focal length in millimetres.
    ///   - circleOfConfusion: Circle of confusion in millimetres.
    ///   - subjectDistance: Subject distance in metres.
    /// - Returns: Near limit distance in metres.
    public static func nearLimit(
        aperture: Float,
        focalLength: Float,
        circleOfConfusion: Float,
        subjectDistance: Float
    ) -> Float {
        let h = hyperfocalDistance(
            aperture: aperture,
            focalLength: focalLength,
            circleOfConfusion: circleOfConfusion
        )
        let fMetres = focalLength / 1000.0
        return ((h - fMetres) * subjectDistance) / (h + subjectDistance - 2 * fMetres)
    }

    /// Far limit of depth of field: `Df = s(H - f) / (H - s)`, in metres.
    ///
    /// A negative return value means the far limit is at infinity.
    ///
    /// - Parameters:
    ///   - aperture: Displayed f-stop value.
    ///   - focalLength: Focal length in millimetres.
    ///   - circleOfConfusion: Circle of confusion in millimetres.
    ///   - subjectDistance: Subject distance in metres.
    /// - Returns: Far limit distance in metres, or a negative value for infinity.
    public static func farLimit(
        aperture: Float,
        focalLength: Float,
        circleOfConfusion: Float,
        subjectDistance: Float
    ) -> Float {
        let h = hyperfocalDistance(
            aperture: aperture,
            focalLength: focalLength,
            circleOfConfusion: circleOfConfusion
        )
        let fMetres = focalLength / 1000.0
        return ((h - fMetres) * subjectDistance) / (h - subjectDistance)
    }

    // MARK: - Private

    private static func trueAperture(_ aperture: Float) -> Float {
        guard let value = trueApertures[aperture] else {
            preconditionFailure("No true aperture for displayed value \(aperture)")
        }
        return value
    }
}
