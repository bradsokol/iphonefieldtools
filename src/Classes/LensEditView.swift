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
///
/// Edits are made to a draft and written to the lens only when Save succeeds, so the
/// system back button is replaced by Cancel and Save. Validating when the screen
/// disappears would be too late to show the error or keep the user's input.
struct LensEditView: View {

    /// The form's text, before it has been checked.
    struct Draft: Equatable {
        var name: String
        var isZoom: Bool
        var minFocalLengthText: String
        var maxFocalLengthText: String
        var maxApertureText: String
        var minApertureText: String
    }

    /// The form's values, checked and converted for storage.
    struct Values: Equatable {
        var name: String
        var minimumFocalLength: Int
        var maximumFocalLength: Int
        var maximumAperture: Float
        var minimumAperture: Float
    }

    /// Why the form's values cannot be saved.
    enum ValidationError: Error, Equatable {
        case missingName
        case badFocalLength
        case badAperture

        var message: String {
            switch self {
            case .missingName:
                NSLocalizedString("LENS_ERROR_MISSING_NAME", comment: "Name required")
            case .badFocalLength:
                String(
                    format: NSLocalizedString("LENS_ERROR_BAD_FOCAL_LENGTH", comment: "Bad focal length"),
                    0.formatted(), 10_000.formatted()
                )
            case .badAperture:
                String(
                    format: NSLocalizedString("LENS_ERROR_BAD_APERTURE", comment: "Bad aperture"),
                    0.7.formatted(), 100.formatted()
                )
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let lens: Lens
    @State private var draft: Draft
    @State private var showValidationError = false
    @State private var validationMessage = ""

    init(lens: Lens) {
        self.lens = lens
        _draft = State(initialValue: Draft(
            name: lens.name,
            isZoom: lens.isZoom,
            minFocalLengthText: lens.minimumFocalLength.formatted(.number.grouping(.never)),
            maxFocalLengthText: lens.maximumFocalLength.formatted(.number.grouping(.never)),
            maxApertureText: LocalizedNumber.string(lens.maximumAperture, precision: .fractionLength(1)),
            minApertureText: LocalizedNumber.string(lens.minimumAperture, precision: .fractionLength(1))
        ))
    }

    var body: some View {
        Form {
            EditNameSection(
                title: NSLocalizedString("LENS_NAME_TITLE", comment: "Name"),
                name: $draft.name
            )
            LensTypeSection(isZoom: $draft.isZoom)
            LensFocalLengthSection(
                isZoom: draft.isZoom,
                minimumText: $draft.minFocalLengthText,
                maximumText: $draft.maxFocalLengthText
            )
            LensApertureSection(maximumText: $draft.maxApertureText, minimumText: $draft.minApertureText)
        }
        .navigationTitle(NSLocalizedString("LENS_VIEW_TITLE", comment: "Lens"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: save)
            }
        }
        .alert(
            NSLocalizedString("LENS_DATA_VALIDATION_ERROR", comment: "Input Error"),
            isPresented: $showValidationError
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationMessage)
        }
    }

    // MARK: - Validation

    /// Checks the form's text and converts it for storage.
    ///
    /// A prime lens takes its maximum focal length from its minimum, ignoring the hidden
    /// maximum field.
    ///
    /// - Parameter locale: The locale the numbers were typed in.
    nonisolated static func validate(_ draft: Draft, locale: Locale = .current) throws(ValidationError) -> Values {
        let trimmedName = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { throw .missingName }

        guard let minFL = LocalizedNumber.integer(from: draft.minFocalLengthText, locale: locale),
              minFL > 0, minFL < 10_000 else {
            throw .badFocalLength
        }

        let maxFL: Int
        if draft.isZoom {
            guard let parsed = LocalizedNumber.integer(from: draft.maxFocalLengthText, locale: locale),
                  parsed >= minFL, parsed < 10_000 else {
                throw .badFocalLength
            }
            maxFL = parsed
        } else {
            maxFL = minFL
        }

        guard let maxAp = LocalizedNumber.decimal(from: draft.maxApertureText, locale: locale),
              maxAp >= 0.7, maxAp <= 100 else {
            throw .badAperture
        }

        guard let minAp = LocalizedNumber.decimal(from: draft.minApertureText, locale: locale),
              minAp >= maxAp, minAp <= 100 else {
            throw .badAperture
        }

        return Values(
            name: trimmedName,
            minimumFocalLength: minFL,
            maximumFocalLength: maxFL,
            maximumAperture: Float(maxAp),
            minimumAperture: Float(minAp)
        )
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

        lens.name = values.name
        lens.minimumFocalLength = values.minimumFocalLength
        lens.maximumFocalLength = values.maximumFocalLength
        lens.maximumAperture = values.maximumAperture
        lens.minimumAperture = values.minimumAperture

        modelContext.saveLoggingFailure()
        dismiss()
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
