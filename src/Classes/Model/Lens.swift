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

/// A photographic lens with focal length range and aperture limits.
@Model
public final class Lens {
    #Index<Lens>([\.index])

    var index: Int = 0
    var name: String
    var minimumFocalLength: Int = 50
    var maximumFocalLength: Int = 50
    var minimumAperture: Float = 32
    var maximumAperture: Float = 1.4

    public init(name: String, index: Int = 0) {
        self.name = name
        self.index = index
    }

    /// Whether this lens has a variable focal length.
    var isZoom: Bool { minimumFocalLength != maximumFocalLength }
}
