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

/// Edit screen for a camera, combining name, CoC preset selection, and custom CoC entry.
///
/// Replaces the three ObjC view controllers: `CameraViewController`,
/// `CoCViewController`, and `CustomCoCViewController`.
struct CameraEditView: View {
    @Bindable var camera: Camera
    @State private var cameraName: String
    @State private var selectedPresetIndex: Int?
    @State private var customCoCText: String
    @State private var showValidationError = false
    @State private var validationMessage = ""

    init(camera: Camera) {
        self.camera = camera
        _cameraName = State(initialValue: camera.name)

        let currentValue = camera.coc?.value ?? 0.03
        let matchIndex = CoCPreset.all.firstIndex { abs($0.value - currentValue) < 0.0001 }
        _selectedPresetIndex = State(initialValue: matchIndex)
        _customCoCText = State(initialValue: String(format: "%.4g", currentValue))
    }

    var body: some View {
        Form {
            nameSection
            cocPresetSection
            customCoCSection
        }
        .navigationTitle(NSLocalizedString("CAMERA_VIEW_TITLE", comment: "Camera"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            NSLocalizedString("CAMERA_DATA_VALIDATION_ERROR", comment: "Input Error"),
            isPresented: $showValidationError
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationMessage)
        }
        .onDisappear {
            save()
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var nameSection: some View {
        Section(NSLocalizedString("CAMERA_NAME_TITLE", comment: "Name")) {
            TextField(
                NSLocalizedString("CAMERA_NAME_TITLE", comment: "Name"),
                text: $cameraName
            )
            .autocorrectionDisabled()
        }
    }

    @ViewBuilder
    private var cocPresetSection: some View {
        Section(NSLocalizedString("COC_TITLE", comment: "Circle of Confusion")) {
            ForEach(Array(CoCPreset.all.enumerated()), id: \.element.name) { index, preset in
                Button {
                    selectedPresetIndex = index
                    customCoCText = String(format: "%.4g", preset.value)
                } label: {
                    HStack {
                        Text(preset.name)
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(String(format: "%.4g", preset.value))
                            .foregroundStyle(.secondary)
                        if selectedPresetIndex == index {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var customCoCSection: some View {
        Section(NSLocalizedString("CUSTOM_COC_VIEW_TITLE", comment: "Custom CoC")) {
            HStack {
                Text(NSLocalizedString("COC", comment: "CoC"))
                TextField("0.03", text: $customCoCText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: customCoCText) {
                        selectedPresetIndex = nil
                    }
            }
        }
    }

    // MARK: - Save

    private func save() {
        let trimmedName = cameraName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            validationMessage = NSLocalizedString("CAMERA_ERROR_MISSING_NAME", comment: "Name required")
            showValidationError = true
            return
        }

        guard let cocValue = Float(customCoCText), cocValue > 0, cocValue < 1 else {
            validationMessage = NSLocalizedString("CAMERA_ERROR_INVALID_COC", comment: "Invalid CoC")
            showValidationError = true
            return
        }

        camera.name = trimmedName

        let cocName: String
        if let presetIndex = selectedPresetIndex {
            cocName = CoCPreset.all[presetIndex].name
        } else {
            cocName = NSLocalizedString("CUSTOM_COC_DESCRIPTION", comment: "Custom")
        }

        if let coc = camera.coc {
            coc.name = cocName
            coc.value = cocValue
        } else {
            let coc = CoC(name: cocName, value: cocValue)
            camera.coc = coc
        }
    }
}
