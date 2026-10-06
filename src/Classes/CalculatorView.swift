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

import SwiftData
import SwiftUI

/// Main calculator screen for depth of field calculations.
struct CalculatorView: View {
    @Environment(UserSettings.self) private var settings
    @Query(sort: \Camera.index) private var cameras: [Camera]
    @Query(sort: \Lens.index) private var lenses: [Lens]
    @State private var viewModel: CalculatorViewModel?
    @State private var showSettings = false
    @State private var distanceType: DistanceType = .hyperfocal

    var body: some View {
        if let viewModel {
            CalculatorContentView(
                viewModel: viewModel,
                distanceType: $distanceType,
                showSettings: $showSettings
            )
            .onChange(of: settings.distanceType) { _, newValue in
                distanceType = DistanceType(rawValue: newValue) ?? .hyperfocal
            }
            .onChange(of: distanceType) { _, newValue in
                settings.distanceType = newValue.rawValue
            }
            .onChange(of: cameras) {
                updateSelectedCamera(viewModel: viewModel)
            }
            .onChange(of: lenses) {
                updateSelectedLens(viewModel: viewModel)
            }
            .sheet(isPresented: $showSettings) {
                updateSelectedCamera(viewModel: viewModel)
                updateSelectedLens(viewModel: viewModel)
                viewModel.onLensChanged()
            } content: {
                SettingsView()
            }
        } else {
            Color.clear.onAppear {
                let model = CalculatorViewModel(settings: settings)
                distanceType = DistanceType(rawValue: settings.distanceType) ?? .hyperfocal
                viewModel = model
                updateSelectedCamera(viewModel: model)
                updateSelectedLens(viewModel: model)
            }
        }
    }

    // MARK: - Helpers

    private func updateSelectedCamera(viewModel: CalculatorViewModel) {
        let index = settings.cameraIndex
        if index < cameras.count {
            viewModel.camera = cameras[index]
        } else if let first = cameras.first {
            viewModel.camera = first
            settings.cameraIndex = 0
        }
    }

    private func updateSelectedLens(viewModel: CalculatorViewModel) {
        let index = settings.lensIndex
        if index < lenses.count {
            viewModel.lens = lenses[index]
        } else if let first = lenses.first {
            viewModel.lens = first
            settings.lensIndex = 0
        }
        viewModel.onLensChanged()
    }
}

// MARK: - Content

/// Spacing for the calculator screen, taken from the storyboard constraints on `main`.
private enum CalculatorLayout {
    static let horizontalMargin: CGFloat = 24
    static let topMargin: CGFloat = 6
    static let resultToPicker: CGFloat = 15
    static let pickerToSliders: CGFloat = 25
    static let betweenSliderRows: CGFloat = 15
    static let titleToSlider: CGFloat = 8
    static let sliderToLimits: CGFloat = 2
}

/// Layout container for the calculator screen.
///
/// The content fills the screen with the footer at the bottom, and scrolls only when
/// it is taller than the screen, as at accessibility text sizes.
private struct CalculatorContentView: View {
    var viewModel: CalculatorViewModel
    @Binding var distanceType: DistanceType
    @Binding var showSettings: Bool

    /// Whether this distance type requires a subject distance.
    private var needsSubjectDistance: Bool {
        distanceType != .hyperfocal
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                content
                    .frame(minHeight: proxy.size.height)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            CalculatorResultSection(
                viewModel: viewModel,
                distanceType: distanceType
            )

            Picker("Distance Type", selection: $distanceType) {
                Text("Hyperfocal").tag(DistanceType.hyperfocal)
                Text("Near").tag(DistanceType.near)
                Text("Far").tag(DistanceType.far)
                Text("Near/Far").tag(DistanceType.nearFar)
            }
            .pickerStyle(.segmented)
            .padding(.top, CalculatorLayout.resultToPicker)

            VStack(spacing: CalculatorLayout.betweenSliderRows) {
                FocalLengthSliderView(viewModel: viewModel)

                ApertureSliderView(viewModel: viewModel)

                if needsSubjectDistance {
                    SubjectDistanceSliderView(viewModel: viewModel)
                }
            }
            .padding(.top, CalculatorLayout.pickerToSliders)

            Spacer(minLength: 0)

            CalculatorFooterView(
                viewModel: viewModel,
                showSettings: $showSettings
            )
        }
        .padding(.horizontal, CalculatorLayout.horizontalMargin)
        .padding(.top, CalculatorLayout.topMargin)
        .padding(.bottom)
    }
}

// MARK: - Result section

/// Result display for the selected distance type.
private struct CalculatorResultSection: View {
    var viewModel: CalculatorViewModel
    var distanceType: DistanceType

    var body: some View {
        switch distanceType {
        case .hyperfocal:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.hyperfocalDistance
            )
        case .near:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.nearLimit
            )
        case .far:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.farLimit
            )
        case .nearFar:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.nearLimit,
                far: viewModel.farLimit
            )
        }
    }
}

// MARK: - Slider sections

/// A titled slider with its current value above, range limits below, and an
/// optional accessory centred beneath the limits.
///
/// When `showsSlider` is false only the title and value are shown, as for the
/// focal length of a prime lens.
private struct LabeledSliderRow<Accessory: View>: View {
    let title: LocalizedStringKey
    let value: String
    @Binding var sliderValue: Float
    let range: ClosedRange<Float>
    var step: Float?
    let minimumLabel: String
    let maximumLabel: String
    var showsSlider = true
    @ViewBuilder var accessory: Accessory

    @ScaledMetric(relativeTo: .title2) private var valueFontSize = 24

    var body: some View {
        VStack(spacing: 0) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    titleText
                    Spacer()
                    valueText
                }
                VStack(alignment: .leading) {
                    titleText
                    valueText
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.secondary)
            if showsSlider {
                slider
                    .padding(.top, CalculatorLayout.titleToSlider)
                HStack {
                    Text(minimumLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(maximumLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, CalculatorLayout.sliderToLimits)
                accessory
            }
        }
    }

    private var titleText: some View {
        Text(title)
            .font(.body)
    }

    private var valueText: some View {
        Text(value)
            .font(.system(size: valueFontSize))
            .monospacedDigit()
    }

    @ViewBuilder private var slider: some View {
        Group {
            if let step {
                Slider(value: $sliderValue, in: range, step: step)
            } else {
                Slider(value: $sliderValue, in: range)
            }
        }
        .tint(.sliderTrack)
        .accessibilityLabel(Text(title))
    }
}

private extension Color {
    /// Grey used on both sides of the thumb on `main`, so a slider shows position without a fill.
    static let sliderTrack = Color(white: 184 / 255)
}

extension LabeledSliderRow where Accessory == EmptyView {
    init(
        title: LocalizedStringKey,
        value: String,
        sliderValue: Binding<Float>,
        range: ClosedRange<Float>,
        step: Float? = nil,
        minimumLabel: String,
        maximumLabel: String,
        showsSlider: Bool = true
    ) {
        self.init(
            title: title,
            value: value,
            sliderValue: sliderValue,
            range: range,
            step: step,
            minimumLabel: minimumLabel,
            maximumLabel: maximumLabel,
            showsSlider: showsSlider
        ) {
            EmptyView()
        }
    }
}

/// Focal length readout, with a slider when the selected lens is a zoom.
private struct FocalLengthSliderView: View {
    var viewModel: CalculatorViewModel

    var body: some View {
        LabeledSliderRow(
            title: "Focal length:",
            value: viewModel.focalLengthText,
            sliderValue: Binding(
                get: { viewModel.settings.focalLength },
                set: { viewModel.updateFocalLength(from: $0) }
            ),
            range: viewModel.focalLengthRange,
            step: 1,
            minimumLabel: viewModel.focalLengthMinLabel,
            maximumLabel: viewModel.focalLengthMaxLabel,
            showsSlider: viewModel.showsFocalLengthSlider
        )
    }
}

/// Aperture slider constrained to the selected lens range.
private struct ApertureSliderView: View {
    var viewModel: CalculatorViewModel

    var body: some View {
        LabeledSliderRow(
            title: "Aperture:",
            value: viewModel.apertureText,
            sliderValue: Binding(
                get: { Float(viewModel.settings.apertureIndex) },
                set: { viewModel.updateApertureIndex(from: $0) }
            ),
            range: viewModel.apertureRange,
            step: 1,
            minimumLabel: viewModel.apertureMinLabel,
            maximumLabel: viewModel.apertureMaxLabel
        )
    }
}

/// Subject distance slider with range selection menu.
private struct SubjectDistanceSliderView: View {
    var viewModel: CalculatorViewModel

    var body: some View {
        @Bindable var settings = viewModel.settings
        LabeledSliderRow(
            title: "Distance to subject:",
            value: viewModel.subjectDistanceText,
            sliderValue: $settings.subjectDistance,
            range: viewModel.subjectDistanceMinimum...viewModel.subjectDistanceMaximum,
            minimumLabel: viewModel.subjectDistanceMinLabel,
            maximumLabel: viewModel.subjectDistanceMaxLabel
        ) {
            Menu(viewModel.subjectDistanceRangeLabel) {
                ForEach(SubjectDistanceRange.allCases, id: \.self) { range in
                    Button(rangeName(range)) {
                        settings.subjectDistanceRange = range
                        viewModel.clampSubjectDistance()
                    }
                }
            }
            .font(.caption)
        }
    }

    private func rangeName(_ range: SubjectDistanceRange) -> String {
        switch range {
        case .macro: NSLocalizedString("SUBJECT_DISTANCE_RANGE_0", comment: "Macro range")
        case .close: NSLocalizedString("SUBJECT_DISTANCE_RANGE_1", comment: "Close range")
        case .mid: NSLocalizedString("SUBJECT_DISTANCE_RANGE_2", comment: "Mid-range")
        case .far: NSLocalizedString("SUBJECT_DISTANCE_RANGE_3", comment: "Full range")
        }
    }
}

// MARK: - Footer

/// Camera/lens description label and settings button at the bottom.
private struct CalculatorFooterView: View {
    var viewModel: CalculatorViewModel
    @Binding var showSettings: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.cameraAndLensDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Button("Settings", systemImage: "gearshape") {
                showSettings = true
            }
        }
    }
}
