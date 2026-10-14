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

/// Edit screen for a camera, combining name, CoC preset selection, and custom CoC entry.
///
/// Replaces the three ObjC view controllers: `CameraViewController`,
/// `CoCViewController`, and `CustomCoCViewController`.
///
/// Presented as a sheet. Edits are made to a draft and written to the camera only when
/// Save succeeds, and Save is enabled only once the draft differs from the camera.
struct CameraEditView: View {

    /// The form's text, before it has been checked.
    struct Draft: Equatable {
        var name: String
        var cocText: String
    }

    /// The form's values, checked and converted for storage.
    struct Values: Equatable {
        var name: String
        var coc: Float
    }

    /// Why the form's values cannot be saved.
    enum ValidationError: Error, Equatable {
        case missingName
        case invalidCoC

        var message: String {
            switch self {
            case .missingName:
                NSLocalizedString("CAMERA_ERROR_MISSING_NAME", comment: "Name required")
            case .invalidCoC:
                NSLocalizedString("CAMERA_ERROR_INVALID_COC", comment: "Invalid CoC")
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let camera: Camera
    @State private var draft: Draft
    @State private var selectedPresetIndex: Int?
    private let savedDraft: Draft
    private let savedPresetIndex: Int?
    @State private var showValidationError = false
    @State private var validationMessage = ""

    init(camera: Camera) {
        self.camera = camera

        let currentValue = camera.coc?.value ?? 0.03
        let matchIndex = CoCPreset.all.firstIndex { abs($0.value - currentValue) < 0.0001 }
        let draft = Draft(name: camera.name, cocText: Self.cocString(currentValue))
        savedDraft = draft
        savedPresetIndex = matchIndex
        _selectedPresetIndex = State(initialValue: matchIndex)
        _draft = State(initialValue: draft)
    }

    var body: some View {
        Form {
            EditNameSection(
                title: NSLocalizedString("CAMERA_NAME_TITLE", comment: "Name"),
                name: $draft.name
            )
            CoCPresetSection(selectedPresetIndex: $selectedPresetIndex, cocText: $draft.cocText)
            CustomCoCSection(cocText: $draft.cocText, selectedPresetIndex: $selectedPresetIndex)
        }
        .navigationTitle(NSLocalizedString("CAMERA_VIEW_TITLE", comment: "Camera"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", systemImage: "checkmark", action: save)
                    .disabled(!hasChanges)
            }
        }
        .alert(
            NSLocalizedString("CAMERA_DATA_VALIDATION_ERROR", comment: "Input Error"),
            isPresented: $showValidationError
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationMessage)
        }
    }

    private var hasChanges: Bool {
        draft != savedDraft || selectedPresetIndex != savedPresetIndex
    }

    // MARK: - Validation

    /// Checks the form's text and converts it for storage.
    ///
    /// - Parameter locale: The locale the CoC was typed in.
    nonisolated static func validate(_ draft: Draft, locale: Locale = .current) throws(ValidationError) -> Values {
        let trimmedName = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { throw .missingName }

        guard let coc = LocalizedNumber.decimal(from: draft.cocText, locale: locale),
              coc > 0, coc < 1 else {
            throw .invalidCoC
        }
        return Values(name: trimmedName, coc: Float(coc))
    }

    /// Formats a circle of confusion in millimetres for the form, in the user's locale.
    static func cocString(_ value: Float) -> String {
        LocalizedNumber.string(value, precision: .significantDigits(1...4))
    }

    // MARK: - Save

    private func save() {
        let values: Values
        do {
            values = try Self.validate(draft)
        } catch {
            validationMessage = error.message
            showValidationError = true
            return
        }

        camera.name = values.name

        let cocName: String
        if let presetIndex = selectedPresetIndex {
            cocName = CoCPreset.all[presetIndex].name
        } else {
            cocName = NSLocalizedString("CUSTOM_COC_DESCRIPTION", comment: "Custom")
        }

        if let coc = camera.coc {
            coc.name = cocName
            coc.value = values.coc
        } else {
            camera.coc = CoC(name: cocName, value: values.coc)
        }

        modelContext.saveLoggingFailure()
        dismiss()
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @Query var cameras: [Camera]
    NavigationStack {
        if let camera = cameras.first {
            CameraEditView(camera: camera)
        }
    }
}
#endif
