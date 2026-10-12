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

/// The distance units picker on the settings screen.
struct UnitsSection: View {
    @Binding var units: DistanceUnits

    var body: some View {
        Section(NSLocalizedString("UNITS_SECTION_TITLE", comment: "Units")) {
            Picker("Units", selection: $units) {
                Text(NSLocalizedString("FEET", comment: "Feet")).tag(DistanceUnits.feet)
                Text(NSLocalizedString("FEET_AND_INCHES", comment: "Feet and inches")).tag(DistanceUnits.feetAndInches)
                Text(NSLocalizedString("METRIC_M", comment: "Metres")).tag(DistanceUnits.meters)
                Text(NSLocalizedString("METRIC_CM", comment: "Centimeters")).tag(DistanceUnits.centimeters)
            }
            .pickerStyle(.inline)
            .labelsHidden()
        }
    }
}
