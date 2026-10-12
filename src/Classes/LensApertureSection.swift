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

/// The widest and smallest aperture fields on the lens edit screen.
struct LensApertureSection: View {
    @Binding var maximumText: String
    @Binding var minimumText: String

    var body: some View {
        Section(NSLocalizedString("LENS_VIEW_APERTURE_SECTION_TITLE", comment: "Aperture")) {
            HStack {
                Text(NSLocalizedString("LENS_EDIT_2", comment: "Maximum (widest)"))
                TextField("f/", text: $maximumText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text(NSLocalizedString("LENS_EDIT_3", comment: "Minimum (smallest)"))
                TextField("f/", text: $minimumText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}
