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

/// Standard third-stop f-number scale used throughout the app.
public enum Aperture {

    /// All f-stop values in third-stop increments, from f/1.0 to f/100.
    public static let values: [Float] = [
        1.0, 1.1, 1.2, 1.4, 1.6, 1.8,
        2.0, 2.2, 2.5, 2.8, 3.2, 3.5,
        4.0, 4.5, 5.0, 5.6, 6.3, 7.1,
        8.0, 9.0, 10.0, 11.0, 13.0, 14.0,
        16.0, 18.0, 20.0, 22.0, 25.0, 28.0,
        32.0, 45.0, 51.0, 57.0, 64.0, 72.0,
        81.0, 91.0, 100.0,
    ]

    /// Default aperture index (f/8.0).
    public static let defaultIndex = 18

    /// Returns the index of the aperture value nearest to `value`.
    ///
    /// - Parameter value: An f-stop number to search for.
    /// - Returns: The index into ``values`` of the closest match.
    public static func nearestIndex(to value: Float) -> Int {
        var bestIndex = 0
        var bestDelta = Float.greatestFiniteMagnitude
        for (index, aperture) in values.enumerated() {
            let delta = abs(aperture - value)
            if delta < bestDelta {
                bestDelta = delta
                bestIndex = index
            }
        }
        return bestIndex
    }
}
