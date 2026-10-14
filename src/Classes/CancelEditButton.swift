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

/// The cancel button of the camera and lens edit sheets.
///
/// Closes the sheet straight away when nothing has changed, and otherwise asks before
/// discarding the changes.
struct CancelEditButton: View {
    /// Whether the form differs from what was loaded.
    let hasChanges: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingDiscard = false

    var body: some View {
        Button("Cancel", systemImage: "xmark", role: .cancel, action: cancel)
            .confirmationDialog(
                NSLocalizedString("DISCARD_CHANGES_TITLE", comment: "Discard changes?"),
                isPresented: $isConfirmingDiscard
            ) {
                Button(NSLocalizedString("DISCARD_CHANGES", comment: "Discard changes"), role: .destructive) {
                    dismiss()
                }
                Button(NSLocalizedString("KEEP_EDITING", comment: "Keep editing"), role: .cancel) {}
            }
    }

    private func cancel() {
        if hasChanges {
            isConfirmingDiscard = true
        } else {
            dismiss()
        }
    }
}
