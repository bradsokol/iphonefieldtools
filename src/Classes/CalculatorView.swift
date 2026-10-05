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

/// Layout container for the calculator screen.
private struct CalculatorContentView: View {
    var viewModel: CalculatorViewModel
    @Binding var distanceType: DistanceType
    @Binding var showSettings: Bool

    /// Whether this distance type requires a subject distance.
    private var needsSubjectDistance: Bool {
        distanceType != .hyperfocal
    }

    var body: some View {
        VStack(spacing: 16) {
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

            ApertureSliderView(viewModel: viewModel)

            if needsSubjectDistance {
                SubjectDistanceSliderView(viewModel: viewModel)
            }

            Spacer()

            CalculatorFooterView(
                viewModel: viewModel,
                showSettings: $showSettings
            )
        }
        .padding()
    }
}

// MARK: - Result section

/// Result display with focal length shown below.
private struct CalculatorResultSection: View {
    var viewModel: CalculatorViewModel
    var distanceType: DistanceType

    var body: some View {
        VStack(spacing: 4) {
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

            HStack {
                Text("Focal length:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(viewModel.focalLengthText)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Slider sections

/// Aperture slider constrained to the selected lens range.
private struct ApertureSliderView: View {
    var viewModel: CalculatorViewModel

    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Text("Aperture:")
                    .font(.body)
                Spacer()
                Text(viewModel.apertureText)
                    .font(.body.monospacedDigit())
            }
            Slider(
                value: Binding(
                    get: { Float(viewModel.settings.apertureIndex) },
                    set: { viewModel.updateApertureIndex(from: $0) }
                ),
                in: viewModel.apertureRange,
                step: 1
            )
            HStack {
                Text(viewModel.apertureMinLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(viewModel.apertureMaxLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// Subject distance slider with range selection menu.
private struct SubjectDistanceSliderView: View {
    var viewModel: CalculatorViewModel

    var body: some View {
        @Bindable var settings = viewModel.settings
        VStack(spacing: 2) {
            HStack {
                Text("Distance to subject:")
                    .font(.body)
                Spacer()
                Text(viewModel.subjectDistanceText)
                    .font(.body.monospacedDigit())
            }
            Slider(
                value: $settings.subjectDistance,
                in: viewModel.subjectDistanceMinimum...viewModel.subjectDistanceMaximum
            )
            HStack {
                Text(viewModel.subjectDistanceMinLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Menu(viewModel.subjectDistanceRangeLabel) {
                    ForEach(SubjectDistanceRange.allCases, id: \.self) { range in
                        Button(rangeName(range)) {
                            settings.subjectDistanceRange = range
                            viewModel.clampSubjectDistance()
                        }
                    }
                }
                .font(.caption)
                Spacer()
                Text(viewModel.subjectDistanceMaxLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
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
