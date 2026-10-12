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
import Testing

@testable import Field_Tools

@Suite("ScrubbingSpeeds Tests")
struct ScrubbingSpeedsTests {

    @Test(
        "Each tier applies from its own distance up to the next",
        arguments: [
            (0.0, 1.0),
            (49.9, 1.0),
            (50.0, 0.5),
            (99.9, 0.5),
            (100.0, 0.25),
            (150.0, 0.1),
            (1000.0, 0.1),
        ]
    )
    func standardTiers(offset: Double, expected: Double) {
        #expect(ScrubbingSpeeds.standard.speed(atVerticalOffset: offset) == expected)
    }

    @Test("Distances below the track choose the same tier as above it", arguments: [30.0, 60.0, 120.0, 200.0])
    func belowTrack(offset: Double) {
        let speeds = ScrubbingSpeeds.standard
        #expect(speeds.speed(atVerticalOffset: -offset) == speeds.speed(atVerticalOffset: offset))
    }

    @Test("Presets keep the OBSlider subclass speeds from main")
    func presets() {
        #expect(ScrubbingSpeeds.focalLength.tiers.map(\.speed) == [1, 0.75, 0.5, 0.25])
        #expect(ScrubbingSpeeds.focalLength.tiers.map(\.verticalOffset) == [0, 50, 100, 150])
        #expect(ScrubbingSpeeds.subjectDistance.tiers.map(\.speed) == [1, 0.5, 0.25, 0.1, 0.05, 0.01])
        #expect(ScrubbingSpeeds.subjectDistance.tiers.map(\.verticalOffset) == [0, 33, 66, 125, 150, 225])
    }

    @Test("Fixed speeds stay at full speed however far the finger moves")
    func fixed() {
        #expect(ScrubbingSpeeds.fixed.speed(atVerticalOffset: 500) == 1)
    }
}

@Suite("ScrubTracker Tests")
struct ScrubTrackerTests {

    /// A tracker at 50 in 0...100, whose 200 point track makes each point half a unit.
    private func makeTracker(speeds: ScrubbingSpeeds = .standard) -> ScrubTracker {
        ScrubTracker(value: 50, range: 0...100, trackY: 0, speeds: speeds)
    }

    private let trackLength = 200.0

    @Test("A drag along the track moves the value at full speed")
    func alongTrack() {
        var tracker = makeTracker()
        tracker.move(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 20, y: 0), trackLength: trackLength)
        #expect(tracker.value == 60)
        #expect(tracker.speed == 1)
    }

    @Test("A drag away from the track is scaled by that distance's speed", arguments: [-60.0, 60.0])
    func awayFromTrack(y: Double) {
        var tracker = makeTracker()
        tracker.move(from: CGPoint(x: 0, y: y), to: CGPoint(x: 20, y: y), trackLength: trackLength)
        #expect(tracker.value == 55)
        #expect(tracker.fullSpeedValue == 60)
        #expect(tracker.speed == 0.5)
    }

    @Test("Moving back towards the track draws the value towards the full speed value", arguments: [-1.0, 1.0])
    func returningToTrack(side: Double) {
        var tracker = makeTracker()
        tracker.move(from: CGPoint(x: 0, y: 120 * side), to: CGPoint(x: 20, y: 120 * side), trackLength: trackLength)
        #expect(tracker.value == 52.5)

        tracker.move(from: CGPoint(x: 20, y: 120 * side), to: CGPoint(x: 20, y: 60 * side), trackLength: trackLength)

        #expect(isClose(tracker.value, 52.5 + (60 - 52.5) / 61))
    }

    @Test("Moving further from the track leaves the value where it was")
    func movingAway() {
        var tracker = makeTracker()
        tracker.move(from: CGPoint(x: 0, y: 60), to: CGPoint(x: 20, y: 60), trackLength: trackLength)
        tracker.move(from: CGPoint(x: 20, y: 60), to: CGPoint(x: 20, y: 120), trackLength: trackLength)
        #expect(tracker.value == 55)
    }

    @Test("The value stops at each end of the range while the full speed value carries on")
    func clamped() {
        var tracker = makeTracker()
        tracker.move(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 300, y: 0), trackLength: trackLength)
        #expect(tracker.value == 100)
        #expect(tracker.fullSpeedValue == 200)

        tracker.move(from: CGPoint(x: 300, y: 0), to: CGPoint(x: -300, y: 0), trackLength: trackLength)
        #expect(tracker.value == 0)
    }

    @Test("A drag starts at full speed")
    func startsAtFullSpeed() {
        #expect(makeTracker(speeds: .subjectDistance).speed == 1)
    }

    @Test("A track with no length leaves the value unchanged")
    func emptyTrack() {
        var tracker = makeTracker()
        tracker.move(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 20, y: 0), trackLength: 0)
        #expect(tracker.value == 50)
    }

    @Test("Slow movements build up until they reach the next step")
    func slowMovementsAccumulate() {
        var tracker = makeTracker()
        var steppedValues: [Double] = []
        for x in 0..<20 {
            tracker.move(from: CGPoint(x: x, y: 160), to: CGPoint(x: x + 1, y: 160), trackLength: trackLength)
            steppedValues.append(ScrubTracker.stepped(tracker.value, by: 1, in: tracker.range))
        }
        #expect(steppedValues.first == 50)
        #expect(steppedValues.last == 51)
    }

    @Test(
        "Values round to the nearest step counted from the start of the range",
        arguments: [
            (2.4, 1.0 as Double?, 0.0...10.0, 2.0),
            (2.6, 1.0, 0.0...10.0, 3.0),
            (4.2, 2.0, 1.0...10.0, 5.0),
            (12.0, 1.0, 0.0...10.0, 10.0),
            (4.2, nil, 0.0...10.0, 4.2),
            (-3.0, nil, 0.0...10.0, 0.0),
        ]
    )
    func stepped(value: Double, step: Double?, range: ClosedRange<Double>, expected: Double) {
        #expect(isClose(ScrubTracker.stepped(value, by: step, in: range), expected))
    }

    private func isClose(_ lhs: Double, _ rhs: Double) -> Bool {
        abs(lhs - rhs) < 1e-9
    }
}
