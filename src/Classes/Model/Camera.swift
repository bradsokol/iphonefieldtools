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

/// A camera body with its associated circle of confusion value.
@Model
public final class Camera {
    #Index<Camera>([\.index])

    var index: Int = 0
    var name: String

    @Relationship(deleteRule: .cascade, inverse: \CoC.camera)
    var coc: CoC?

    public init(name: String, index: Int = 0) {
        self.name = name
        self.index = index
    }
}
