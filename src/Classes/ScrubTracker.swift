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

import CoreGraphics

/// The value of a ``ScrubSlider`` through one drag, ported from OBSlider.
///
/// A horizontal movement changes the value by the same fraction of the range as it
/// covers of the track, scaled by the speed for the finger's distance from the track.
///
/// The tracker also follows where the thumb would be at full speed. While the finger
/// moves back towards the track the thumb is drawn towards that position, more
/// strongly the closer the finger gets, so returning to the track leaves the thumb
/// under the finger again.
struct ScrubTracker: Equatable {
    /// The values the slider can take.
    let range: ClosedRange<Double>

    /// The speeds for each distance from the track.
    let speeds: ScrubbingSpeeds

    /// The vertical position of the track, from which distances are measured.
    let trackY: Double

    /// The value so far, before any step is applied.
    private(set) var value: Double

    /// The value a full speed drag would have reached, which may lie outside `range`.
    private(set) var fullSpeedValue: Double

    /// The speed applied by the latest movement.
    private(set) var speed: Double

    /// Starts tracking a drag from `value`, with the thumb's centre at `trackY`.
    init(value: Double, range: ClosedRange<Double>, trackY: Double, speeds: ScrubbingSpeeds) {
        self.range = range
        self.speeds = speeds
        self.trackY = trackY
        self.value = value
        fullSpeedValue = value
        speed = speeds.speed(atVerticalOffset: 0)
    }

    /// Applies the finger's movement from `previous` to `current`.
    ///
    /// - Parameter trackLength: The distance the thumb's centre travels from one end
    ///   of the range to the other.
    mutating func move(from previous: CGPoint, to current: CGPoint, trackLength: Double) {
        guard trackLength > 0 else { return }
        let verticalOffset = abs(current.y - trackY)
        speed = speeds.speed(atVerticalOffset: verticalOffset)

        let fullSpeedChange = (range.upperBound - range.lowerBound) * (current.x - previous.x) / trackLength
        fullSpeedValue += fullSpeedChange

        let isReturningToTrack = (trackY < current.y && current.y < previous.y)
            || (trackY > current.y && current.y > previous.y)
        let returnAdjustment = isReturningToTrack ? (fullSpeedValue - value) / (1 + verticalOffset) : 0

        value = (value + speed * fullSpeedChange + returnAdjustment).clamped(to: range)
    }

    /// `value` rounded to the nearest multiple of `step` from the start of `range`.
    ///
    /// Without a step the value is only clamped to the range.
    static func stepped(_ value: Double, by step: Double?, in range: ClosedRange<Double>) -> Double {
        guard let step, step > 0 else { return value.clamped(to: range) }
        let steps = ((value - range.lowerBound) / step).rounded()
        return (range.lowerBound + steps * step).clamped(to: range)
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
