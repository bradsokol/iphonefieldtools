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

import Foundation

/// A preset circle of confusion value for a known camera/sensor format.
public struct CoCPreset: Sendable {
    public let name: String
    public let value: Float

    /// All available CoC presets, sorted alphabetically by name.
    public static let all: [CoCPreset] = [
        CoCPreset(name: "35 mm", value: 0.03),
        CoCPreset(name: "4x5 format", value: 0.1),
        CoCPreset(name: "6x6 format", value: 0.045),
        CoCPreset(name: "Canon 1D", value: 0.023),
        CoCPreset(name: "Canon 1Ds/5D", value: 0.03),
        CoCPreset(name: "Canon APS-C", value: 0.019),
        CoCPreset(name: "Contax N", value: 0.03),
        CoCPreset(name: "Fuji FinePix S1/S2/S3/S5", value: 0.02),
        CoCPreset(name: "Kodak DCS Pro", value: 0.03),
        CoCPreset(name: "Kodak DCS-14N", value: 0.003),
        CoCPreset(name: "Kodak DCS-720X", value: 0.019),
        CoCPreset(name: "Kodak DCS-760", value: 0.023),
        CoCPreset(name: "Konica Minolta Maxxum", value: 0.02),
        CoCPreset(name: "Leica M8/X1", value: 0.023),
        CoCPreset(name: "Leica M9", value: 0.03),
        CoCPreset(name: "Mamiya ZD", value: 0.39),
        CoCPreset(name: "Nikon DX", value: 0.02),
        CoCPreset(name: "Nikon FX", value: 0.03),
        CoCPreset(name: "Olympus 4:3", value: 0.015),
        CoCPreset(name: "Panasonic 4:3", value: 0.015),
        CoCPreset(name: "Pentax 645D", value: 0.05),
        CoCPreset(name: "Pentax DSLR", value: 0.02),
        CoCPreset(name: "Samsung DX/NX", value: 0.02),
        CoCPreset(name: "Sony A850, A900", value: 0.03),
        CoCPreset(name: "Sony DSLR", value: 0.02),
    ]
}
