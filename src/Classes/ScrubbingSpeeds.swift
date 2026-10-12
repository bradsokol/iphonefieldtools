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

import SwiftUI

/// The speeds at which a ``ScrubSlider`` follows a drag, chosen by how far the finger
/// has moved above or below the track.
///
/// Each tier starts at a vertical distance from the track and applies until the next
/// tier's distance is reached, so the further the finger moves from the track, the
/// smaller the change a horizontal movement makes.
struct ScrubbingSpeeds: Equatable, Sendable {

    /// A speed that applies from a vertical distance from the track onwards.
    struct Tier: Equatable, Sendable {
        /// Distance from the track, in points, at which this speed starts.
        let verticalOffset: Double

        /// Fraction of the finger's horizontal movement applied to the value.
        let speed: Double

        /// Creates a tier applying `speed` from `verticalOffset` points away from the track.
        init(from verticalOffset: Double, speed: Double) {
            self.verticalOffset = verticalOffset
            self.speed = speed
        }
    }

    /// The tiers in order of increasing vertical distance, the first starting at zero.
    let tiers: [Tier]

    /// Creates speeds from tiers in order of increasing vertical distance.
    ///
    /// The first tier must start at zero, so a drag along the track has a speed.
    init(_ tiers: [Tier]) {
        precondition(tiers.first?.verticalOffset == 0, "The first tier must start on the track")
        precondition(
            zip(tiers, tiers.dropFirst()).allSatisfy { $0.verticalOffset < $1.verticalOffset },
            "Tiers must be in order of increasing vertical distance"
        )
        self.tiers = tiers
    }

    /// The speed for a finger `verticalOffset` points above or below the track.
    func speed(atVerticalOffset verticalOffset: Double) -> Double {
        let distance = abs(verticalOffset)
        return tiers.last { $0.verticalOffset <= distance }?.speed ?? 1
    }

    /// Full speed wherever the finger is, as a standard slider behaves.
    static let fixed = ScrubbingSpeeds([Tier(from: 0, speed: 1)])

    /// Full, half, quarter and tenth speed every 50 points, the OBSlider defaults.
    static let standard = ScrubbingSpeeds([
        Tier(from: 0, speed: 1),
        Tier(from: 50, speed: 0.5),
        Tier(from: 100, speed: 0.25),
        Tier(from: 150, speed: 0.1),
    ])

    /// Gentler steps suited to the narrow range of a zoom lens.
    static let focalLength = ScrubbingSpeeds([
        Tier(from: 0, speed: 1),
        Tier(from: 50, speed: 0.75),
        Tier(from: 100, speed: 0.5),
        Tier(from: 150, speed: 0.25),
    ])

    /// Steps down to a hundredth of the finger's movement, for fine focusing distances.
    static let subjectDistance = ScrubbingSpeeds([
        Tier(from: 0, speed: 1),
        Tier(from: 33, speed: 0.5),
        Tier(from: 66, speed: 0.25),
        Tier(from: 125, speed: 0.1),
        Tier(from: 150, speed: 0.05),
        Tier(from: 225, speed: 0.01),
    ])
}

extension EnvironmentValues {
    /// The scrubbing speeds of each ``ScrubSlider`` in this environment.
    @Entry var scrubbingSpeeds: ScrubbingSpeeds = .standard
}

extension View {
    /// Sets the scrubbing speeds of each ``ScrubSlider`` within this view.
    func scrubbingSpeeds(_ speeds: ScrubbingSpeeds) -> some View {
        environment(\.scrubbingSpeeds, speeds)
    }
}
