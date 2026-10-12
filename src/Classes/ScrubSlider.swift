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

/// A slider whose thumb moves more slowly the further the finger moves above or below
/// the track, for fine adjustment without a longer track.
///
/// It looks like the system slider for the running version of iOS, except that the
/// track has no fill on either side of the thumb. Set the speeds with
/// ``SwiftUICore/View/scrubbingSpeeds(_:)``; the default is ``ScrubbingSpeeds/standard``.
///
/// As with the system slider, a drag must start on the thumb. Assistive technologies
/// see a standard slider.
struct ScrubSlider<Value: BinaryFloatingPoint, Label: View>: View where Value.Stride: BinaryFloatingPoint {
    @Binding private var value: Value
    private let bounds: ClosedRange<Value>
    private let step: Value.Stride?
    private let label: Label
    private let onEditingChanged: (Bool) -> Void

    @Environment(\.scrubbingSpeeds) private var speeds
    @Environment(\.isEnabled) private var isEnabled
    @State private var width: Double = 0
    @State private var drag: DragSession?
    @GestureState private var isDragging = false

    /// Creates a slider moving continuously through `bounds`.
    ///
    /// - Parameters:
    ///   - value: The selected value.
    ///   - bounds: The values the slider can take.
    ///   - label: Describes the slider to assistive technologies.
    ///   - onEditingChanged: Called with `true` when a drag starts and `false` when it ends.
    init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._value = value
        self.bounds = bounds
        self.step = nil
        self.label = label()
        self.onEditingChanged = onEditingChanged
    }

    /// Creates a slider whose value is always a whole number of `step`s from the start
    /// of `bounds`.
    ///
    /// The thumb sits on a step throughout a drag. Slow movements build up until they
    /// reach the next step rather than being lost.
    ///
    /// - Parameters:
    ///   - value: The selected value.
    ///   - bounds: The values the slider can take.
    ///   - step: The distance between allowed values.
    ///   - label: Describes the slider to assistive technologies.
    ///   - onEditingChanged: Called with `true` when a drag starts and `false` when it ends.
    init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value>,
        step: Value.Stride = 1,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._value = value
        self.bounds = bounds
        self.step = step
        self.label = label()
        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        let metrics = ScrubSliderMetrics.current
        ZStack(alignment: .leading) {
            Capsule()
                .fill(.fill)
                .frame(height: metrics.trackHeight)

            ScrubSliderThumb(metrics: metrics, isDragging: isDragging)
                .frame(width: metrics.hitSize, height: metrics.hitSize)
                .contentShape(.rect)
                .offset(x: thumbCentreX(metrics: metrics) - metrics.hitSize / 2)
                .gesture(dragGesture(metrics: metrics))
        }
        .frame(height: metrics.height)
        .frame(maxWidth: .infinity)
        .coordinateSpace(.named(ScrubSliderSpace.name))
        .onGeometryChange(for: Double.self) { $0.size.width } action: { width = $0 }
        .opacity(isEnabled ? 1 : 0.5)
        .onChange(of: isDragging) {
            if !isDragging {
                endDrag()
            }
        }
        .accessibilityRepresentation {
            if let step {
                Slider(value: $value, in: bounds, step: step) { label }
            } else {
                Slider(value: $value, in: bounds) { label }
            }
        }
    }

    // MARK: - Geometry

    private var doubleRange: ClosedRange<Double> {
        Double(bounds.lowerBound)...Double(bounds.upperBound)
    }

    /// Distance the thumb's centre travels from one end of the range to the other.
    private func trackLength(metrics: ScrubSliderMetrics) -> Double {
        max(0, width - metrics.thumbSize.width)
    }

    private func thumbCentreX(metrics: ScrubSliderMetrics) -> Double {
        let span = doubleRange.upperBound - doubleRange.lowerBound
        let fraction = span > 0 ? (Double(value) - doubleRange.lowerBound) / span : 0
        return metrics.thumbSize.width / 2 + min(max(fraction, 0), 1) * trackLength(metrics: metrics)
    }

    // MARK: - Dragging

    private func dragGesture(metrics: ScrubSliderMetrics) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(ScrubSliderSpace.name))
            .updating($isDragging) { _, isDragging, _ in
                isDragging = true
            }
            .onChanged { gesture in
                guard var session = drag else {
                    beginDrag(at: gesture.location, metrics: metrics)
                    return
                }
                session.tracker.move(
                    from: session.location,
                    to: gesture.location,
                    trackLength: trackLength(metrics: metrics)
                )
                session.location = gesture.location
                drag = session
                setValue(session.tracker.value)
            }
    }

    private func beginDrag(at location: CGPoint, metrics: ScrubSliderMetrics) {
        let tracker = ScrubTracker(
            value: Double(value),
            range: doubleRange,
            trackY: metrics.height / 2,
            speeds: speeds
        )
        drag = DragSession(tracker: tracker, location: location)
        onEditingChanged(true)
    }

    private func endDrag() {
        guard drag != nil else { return }
        drag = nil
        onEditingChanged(false)
    }

    private func setValue(_ newValue: Double) {
        let stepped = Value(ScrubTracker.stepped(newValue, by: step.map(Double.init), in: doubleRange))
        if stepped != value {
            value = stepped
        }
    }
}

/// The state of a drag in progress.
private struct DragSession {
    var tracker: ScrubTracker
    var location: CGPoint
}

private enum ScrubSliderSpace {
    static let name = "ScrubSlider"
}

#if DEBUG
#Preview("Compared with Slider") {
    @Previewable @State var value = 0.4
    @Previewable @State var steppedValue = 12.0
    VStack(spacing: 24) {
        Slider(value: $value)
        ScrubSlider(value: $value) { Text("Continuous") }
        Slider(value: $steppedValue, in: 0...20, step: 1)
        ScrubSlider(value: $steppedValue, in: 0...20, step: 1) { Text("Stepped") }
            .scrubbingSpeeds(.focalLength)
        ScrubSlider(value: $value) { Text("Disabled") }
            .disabled(true)
    }
    .padding(24)
}
#endif
