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

/// The focal length fields on the lens edit screen. A prime lens shows only the minimum.
struct LensFocalLengthSection: View {
    let isZoom: Bool
    @Binding var minimumText: String
    @Binding var maximumText: String

    var body: some View {
        Section(NSLocalizedString("LENS_VIEW_FOCAL_LENGTH_SECTION_TITLE", comment: "Focal Length")) {
            HStack {
                Text(NSLocalizedString("LENS_EDIT_0", comment: "Minimum"))
                TextField("mm", text: $minimumText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            if isZoom {
                HStack {
                    Text(NSLocalizedString("LENS_EDIT_1", comment: "Maximum"))
                    TextField("mm", text: $maximumText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
}
