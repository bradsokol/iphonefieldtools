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

/// The list of circle of confusion presets on the camera edit screen.
///
/// Choosing a preset checks it and copies its value into the custom CoC field.
struct CoCPresetSection: View {
    @Binding var selectedPresetIndex: Int?
    @Binding var cocText: String

    var body: some View {
        Section(NSLocalizedString("COC_TITLE", comment: "Circle of Confusion")) {
            ForEach(Array(CoCPreset.all.enumerated()), id: \.element.name) { index, preset in
                Button {
                    selectedPresetIndex = index
                    cocText = CameraEditView.cocString(preset.value)
                } label: {
                    HStack {
                        Text(preset.name)
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(CameraEditView.cocString(preset.value))
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
}
