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
import TipKit

/// Main calculator screen for depth of field calculations.
///
/// The view model is owned by the app, built from the same ``UserSettings`` the
/// environment carries. The selected camera and lens are resolved from the queried models
/// on appear and whenever those models or the settings sheet change.
struct CalculatorView: View {
    let viewModel: CalculatorViewModel
    @Query(sort: \Camera.index) private var cameras: [Camera]
    @Query(sort: \Lens.index) private var lenses: [Lens]
    @State private var showSettings = false
    @State private var tips = OnboardingTips.makeGroup()

    private var settings: UserSettings { viewModel.settings }

    var body: some View {
        @Bindable var settings = viewModel.settings
        CalculatorContentView(
            viewModel: viewModel,
            distanceType: $settings.distanceType,
            showSettings: $showSettings,
            tips: tips
        )
        .onChange(of: viewModel.showsFocalLengthSlider, initial: true) {
            FocalLengthScrubbingTip.isSliderShown = viewModel.showsFocalLengthSlider
        }
        .onChange(of: settings.distanceType, initial: true) {
            DistanceScrubbingTip.isSliderShown = settings.distanceType.needsSubjectDistance
        }
        .onAppear {
            updateSelectedCamera()
            updateSelectedLens()
        }
        .onChange(of: cameras) {
            updateSelectedCamera()
        }
        .onChange(of: lenses) {
            updateSelectedLens()
        }
        .sheet(isPresented: $showSettings) {
            updateSelectedCamera()
            updateSelectedLens()
        } content: {
            SettingsView()
        }
    }

    // MARK: - Helpers

    private func updateSelectedCamera() {
        let index = settings.cameraIndex
        if index < cameras.count {
            viewModel.camera = cameras[index]
        } else if let first = cameras.first {
            viewModel.camera = first
            settings.cameraIndex = 0
        }
    }

    private func updateSelectedLens() {
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
    static let horizontalMargin: Double = 24
    static let topMargin: Double = 6
    static let resultToPicker: Double = 15
    static let pickerToSliders: Double = 25
    static let betweenSliderRows: Double = 15
    static let titleToSlider: Double = 8
    static let sliderToLimits: Double = 2
    /// 18pt on `main`, less the extra height the footer's 44pt tap target adds below its content.
    static let bottomMargin: Double = 8
    static let minimumTapTarget: Double = 44
}

/// Layout container for the calculator screen.
///
/// The controls fill the screen with the footer at the bottom, and scroll only when
/// they are taller than the screen, as at accessibility text sizes.
private struct CalculatorContentView: View {
    var viewModel: CalculatorViewModel
    @Binding var distanceType: DistanceType
    @Binding var showSettings: Bool
    var tips: TipGroup

    var body: some View {
        ViewThatFits(in: .vertical) {
            controls
            ScrollView {
                controls
            }
        }
    }

    private var controls: some View {
        CalculatorControlsView(
            viewModel: viewModel,
            distanceType: $distanceType,
            showSettings: $showSettings,
            tips: tips
        )
    }
}

/// The result, distance type picker, sliders and footer, stacked top to bottom.
private struct CalculatorControlsView: View {
    var viewModel: CalculatorViewModel
    @Binding var distanceType: DistanceType
    @Binding var showSettings: Bool
    var tips: TipGroup

    var body: some View {
        VStack(spacing: 0) {
            CalculatorResultSection(
                viewModel: viewModel,
                distanceType: distanceType
            )

            Picker("DISTANCE_TYPE", selection: $distanceType) {
                ForEach(DistanceType.allCases, id: \.self) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.top, CalculatorLayout.resultToPicker)

            VStack(spacing: CalculatorLayout.betweenSliderRows) {
                FocalLengthSliderView(
                    viewModel: viewModel,
                    tip: tips.currentTip as? FocalLengthScrubbingTip
                )

                ApertureSliderView(viewModel: viewModel)

                if distanceType.needsSubjectDistance {
                    SubjectDistanceSliderView(
                        viewModel: viewModel,
                        tip: tips.currentTip as? DistanceScrubbingTip
                    )
                }
            }
            .padding(.top, CalculatorLayout.pickerToSliders)

            Spacer(minLength: 0)

            CalculatorFooterView(
                viewModel: viewModel,
                showSettings: $showSettings,
                tip: tips.currentTip as? CameraBagTip
            )
        }
        .padding(.horizontal, CalculatorLayout.horizontalMargin)
        .padding(.top, CalculatorLayout.topMargin)
        .padding(.bottom, CalculatorLayout.bottomMargin)
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
                near: viewModel.hyperfocalDistance,
                accessibilityLabel: distanceType.resultAccessibilityLabel
            )
        case .near:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.nearLimit,
                accessibilityLabel: distanceType.resultAccessibilityLabel
            )
        case .far:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.farLimit,
                accessibilityLabel: distanceType.resultAccessibilityLabel
            )
        case .nearFar:
            ResultView(
                formatter: viewModel.resultFormatter,
                near: viewModel.rangeNearLimit,
                far: viewModel.rangeFarLimit,
                accessibilityLabel: distanceType.resultAccessibilityLabel
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
    var tip: (any Tip)?
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
                    .popoverTip(tip)
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
        if let step {
            ScrubSlider(value: $sliderValue, in: range, step: step) { Text(title) }
        } else {
            ScrubSlider(value: $sliderValue, in: range) { Text(title) }
        }
    }
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
        showsSlider: Bool = true,
        tip: (any Tip)? = nil
    ) {
        self.title = title
        self.value = value
        self._sliderValue = sliderValue
        self.range = range
        self.step = step
        self.minimumLabel = minimumLabel
        self.maximumLabel = maximumLabel
        self.showsSlider = showsSlider
        self.tip = tip
        self.accessory = EmptyView()
    }
}

/// Focal length readout, with a slider when the selected lens is a zoom.
private struct FocalLengthSliderView: View {
    var viewModel: CalculatorViewModel
    var tip: FocalLengthScrubbingTip?

    var body: some View {
        @Bindable var settings = viewModel.settings
        LabeledSliderRow(
            title: "Focal length:",
            value: viewModel.focalLengthText,
            sliderValue: $settings.focalLength,
            range: viewModel.focalLengthRange,
            step: 1,
            minimumLabel: viewModel.focalLengthMinLabel,
            maximumLabel: viewModel.focalLengthMaxLabel,
            showsSlider: viewModel.showsFocalLengthSlider,
            tip: tip
        )
        .scrubbingSpeeds(.focalLength)
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
        .scrubbingSpeeds(.fixed)
    }
}

/// Subject distance slider with range selection menu.
private struct SubjectDistanceSliderView: View {
    var viewModel: CalculatorViewModel
    var tip: DistanceScrubbingTip?

    /// Height of one line of caption text, used to grow the range menu to a full tap
    /// target without moving the text or the rows around it.
    @ScaledMetric(relativeTo: .caption) private var captionLineHeight = 14.33

    private var tapTargetOverhang: Double {
        max(0, (CalculatorLayout.minimumTapTarget - captionLineHeight) / 2)
    }

    var body: some View {
        @Bindable var settings = viewModel.settings
        LabeledSliderRow(
            title: "Distance to subject:",
            value: viewModel.subjectDistanceText,
            sliderValue: $settings.subjectDistance,
            range: viewModel.subjectDistanceMinimum...viewModel.subjectDistanceMaximum,
            minimumLabel: viewModel.subjectDistanceMinLabel,
            maximumLabel: viewModel.subjectDistanceMaxLabel,
            tip: tip
        ) {
            Menu {
                ForEach(SubjectDistanceRange.allCases, id: \.self) { range in
                    Button(range.title) {
                        settings.subjectDistanceRange = range
                        viewModel.clampSubjectDistance()
                    }
                }
            } label: {
                Text(settings.subjectDistanceRange.title)
                    .font(.caption)
                    .frame(
                        minWidth: CalculatorLayout.minimumTapTarget,
                        minHeight: CalculatorLayout.minimumTapTarget
                    )
                    .contentShape(.rect)
            }
            .padding(.vertical, -tapTargetOverhang)
        }
        .scrubbingSpeeds(.subjectDistance)
    }
}

// MARK: - Footer

/// Camera and lens description with an info icon at the bottom right, which opens settings.
private struct CalculatorFooterView: View {
    var viewModel: CalculatorViewModel
    @Binding var showSettings: Bool
    var tip: CameraBagTip?

    var body: some View {
        Button(action: openSettings) {
            HStack(spacing: 8) {
                Text(viewModel.cameraAndLensDescription)
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                Image(systemName: "info.circle")
                    .font(.title3)
                    .accessibilityHidden(true)
            }
            .frame(minHeight: CalculatorLayout.minimumTapTarget)
        }
        .accessibilityHint("Opens settings")
        .accessibilityIdentifier("settingsButton")
        .popoverTip(tip)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func openSettings() {
        CameraBagTip().invalidate(reason: .actionPerformed)
        showSettings = true
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @Environment(UserSettings.self) var settings
    CalculatorView(viewModel: CalculatorViewModel(settings: settings))
}
#endif
