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

/// Edit screen for a lens: name, type (prime/zoom), aperture range, and focal length range.
struct LensEditView: View {
    @Bindable var lens: Lens
    @State private var lensName: String
    @State private var isZoom: Bool
    @State private var minFocalLengthText: String
    @State private var maxFocalLengthText: String
    @State private var maxApertureText: String
    @State private var minApertureText: String
    @State private var showValidationError = false
    @State private var validationMessage = ""

    init(lens: Lens) {
        self.lens = lens
        _lensName = State(initialValue: lens.name)
        _isZoom = State(initialValue: lens.isZoom)
        _minFocalLengthText = State(initialValue: "\(lens.minimumFocalLength)")
        _maxFocalLengthText = State(initialValue: "\(lens.maximumFocalLength)")
        _maxApertureText = State(initialValue: String(format: "%.1f", lens.maximumAperture))
        _minApertureText = State(initialValue: String(format: "%.1f", lens.minimumAperture))
    }

    var body: some View {
        Form {
            nameSection
            typeSection
            focalLengthSection
            apertureSection
        }
        .navigationTitle(NSLocalizedString("LENS_VIEW_TITLE", comment: "Lens"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            NSLocalizedString("LENS_DATA_VALIDATION_ERROR", comment: "Input Error"),
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
        Section(NSLocalizedString("LENS_NAME_TITLE", comment: "Name")) {
            TextField(
                NSLocalizedString("LENS_NAME_TITLE", comment: "Name"),
                text: $lensName
            )
            .autocorrectionDisabled()
        }
    }

    @ViewBuilder
    private var typeSection: some View {
        Section(NSLocalizedString("LENS_VIEW_TYPE_SECTION_TITLE", comment: "Lens Type")) {
            Picker("Type", selection: $isZoom) {
                Text(NSLocalizedString("LENS_TYPE_PRIME", comment: "Prime")).tag(false)
                Text(NSLocalizedString("LENS_TYPE_ZOOM", comment: "Zoom")).tag(true)
            }
            .pickerStyle(.segmented)
        }
    }

    @ViewBuilder
    private var focalLengthSection: some View {
        Section(NSLocalizedString("LENS_VIEW_FOCAL_LENGTH_SECTION_TITLE", comment: "Focal Length")) {
            HStack {
                Text(NSLocalizedString("LENS_EDIT_0", comment: "Minimum"))
                TextField("mm", text: $minFocalLengthText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            if isZoom {
                HStack {
                    Text(NSLocalizedString("LENS_EDIT_1", comment: "Maximum"))
                    TextField("mm", text: $maxFocalLengthText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    @ViewBuilder
    private var apertureSection: some View {
        Section(NSLocalizedString("LENS_VIEW_APERTURE_SECTION_TITLE", comment: "Aperture")) {
            HStack {
                Text(NSLocalizedString("LENS_EDIT_2", comment: "Maximum (widest)"))
                TextField("f/", text: $maxApertureText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text(NSLocalizedString("LENS_EDIT_3", comment: "Minimum (smallest)"))
                TextField("f/", text: $minApertureText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    // MARK: - Save

    private func save() {
        let trimmedName = lensName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            validationMessage = NSLocalizedString("LENS_ERROR_MISSING_NAME", comment: "Name required")
            showValidationError = true
            return
        }

        guard let minFL = Int(minFocalLengthText), minFL > 0, minFL < 10000 else {
            showFocalLengthError()
            return
        }

        let maxFL: Int
        if isZoom {
            guard let parsed = Int(maxFocalLengthText), parsed >= minFL, parsed < 10000 else {
                showFocalLengthError()
                return
            }
            maxFL = parsed
        } else {
            maxFL = minFL
        }

        guard let maxAp = Float(maxApertureText),
              maxAp >= 0.7, maxAp <= 100 else {
            showApertureError()
            return
        }

        guard let minAp = Float(minApertureText),
              minAp >= maxAp, minAp <= 100 else {
            showApertureError()
            return
        }

        lens.name = trimmedName
        lens.minimumFocalLength = minFL
        lens.maximumFocalLength = maxFL
        lens.maximumAperture = maxAp
        lens.minimumAperture = minAp
    }

    private func showFocalLengthError() {
        validationMessage = String(
            format: NSLocalizedString("LENS_ERROR_BAD_FOCAL_LENGTH", comment: "Bad focal length"),
            "0", "10000"
        )
        showValidationError = true
    }

    private func showApertureError() {
        validationMessage = String(
            format: NSLocalizedString("LENS_ERROR_BAD_APERTURE", comment: "Bad aperture"),
            "0.7", "100"
        )
        showValidationError = true
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @Query var lenses: [Lens]
    NavigationStack {
        if let lens = lenses.first {
            LensEditView(lens: lens)
        }
    }
}
#endif
