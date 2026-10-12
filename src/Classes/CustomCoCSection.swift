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

/// The custom circle of confusion field on the camera edit screen.
///
/// Typing a value that differs from the checked preset clears the check.
struct CustomCoCSection: View {
    @Binding var cocText: String
    @Binding var selectedPresetIndex: Int?

    var body: some View {
        Section(NSLocalizedString("CUSTOM_COC_VIEW_TITLE", comment: "Custom CoC")) {
            HStack {
                Text(NSLocalizedString("COC", comment: "CoC"))
                TextField(CameraEditView.cocString(0.03), text: $cocText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: cocText) {
                        if let index = selectedPresetIndex,
                           cocText != CameraEditView.cocString(CoCPreset.all[index].value) {
                            selectedPresetIndex = nil
                        }
                    }
            }
        }
    }
}
